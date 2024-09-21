import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import 'package:skillborn/api/api.dart';
import 'package:skillborn/main_state.dart';
import 'package:skillborn/services/firestore.dart';
import 'package:skillborn/services/models.dart';
import 'package:skillborn/task/task_state.dart';

class TaskCard extends StatelessWidget {
  final Task task;
  const TaskCard({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    final mainState = Provider.of<MainState>(context);

    return Slidable(
      key: Key(task.id),
      endActionPane: ActionPane(
        motion: const DrawerMotion(),
        extentRatio: 0.15,
        children: [
          SlidableAction(
            onPressed: (context) {
              // Show a confirmation dialog
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Delete Task'),
                  content:
                      Text('Are you sure you want to delete "${task.title}"?'),
                  actions: [
                    TextButton(
                      onPressed: () =>
                          Navigator.of(context).pop(), // Cancel deletion
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () {
                        // Delete the task from Firestore
                        mainState.removeTask(task);
                        Navigator.of(context).pop(); // Close the dialog
                        // Optionally, show a snackbar notification
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content: Text('Task "${task.title}" deleted')),
                        );
                      },
                      child: const Text('Delete'),
                    ),
                  ],
                ),
              );
            },
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
            icon: Icons.delete,
            padding: const EdgeInsets.all(0.0),
            borderRadius: const BorderRadius.only(
              topRight:
                  Radius.circular(5.0), // Apply border radius to top right
              bottomRight:
                  Radius.circular(5.0), // Apply border radius to bottom right
            ),
          ),
        ],
      ),
      child: Container(
        decoration: BoxDecoration(
          color: const Color.fromRGBO(45, 45, 45, 1), // Background color
          borderRadius: BorderRadius.circular(5), // Circular radius
        ),
        height: 52,
        alignment: Alignment.center,
        padding: const EdgeInsets.only(left: 2.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            IconButton(
                onPressed: () {
                  if (task.isCompleted == false) {
                    onTaskComplete(context, task);
                  } else {
                    // Directly toggle tasks of no need to wait for response
                    mainState.toggleTask(task);
                  }
                },
                icon: task.isCompleted
                    ? const Icon(IconData(0xe159, fontFamily: 'MaterialIcons'))
                    : const Icon(
                        IconData(0xef53, fontFamily: 'MaterialIcons'))),
            Text(
              task.title,
              style: TextStyle(
                fontSize: 17,
                decoration:
                    task.isCompleted ? TextDecoration.lineThrough : null,
                color: task.isCompleted ? Colors.grey : null,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future onTaskComplete(context, task) async {
    final mainState = Provider.of<MainState>(context, listen: false);
    final taskState = Provider.of<TaskState>(context, listen: false);
    var skills = await FirestoreService().getSkillsFromTask(task.title);

    /// Generate new skills from task title with OpenAI api
    Future<List<Map<String, dynamic>>?> generateSkillsFromTaskTitle(
        taskTitle) async {
      // Get skill as a string of List<Map<String, int>>
      var messages =
          getTaskCompletionMessages(FirestoreService().getSkills(), taskTitle);
      var result = await callChatGPT(mainState, messages, functions);
      if (result == null) return [];
      // Decode string to List<Map<String, dynamic>>
      List<Map<String, dynamic>> skills =
          List<Map<String, dynamic>>.from(json.decode(result));

      // Add the new instance of task-skills to database
      FirestoreService().addTaskSkills(taskTitle, skills);
      // Return skills
      return skills;
    }

    /// Level up & add new skills
    void parseSkills(skills) async {
      List<Map<String, dynamic>> newSkills = [];
      var messages = [];

      for (var s1 in skills) {
        Skill? s2;
        if (mainState.skills.any((s) => s.title == s1['skill'])) {
          s2 = mainState.skills.firstWhere((s) => s.title == s1['skill']);
        }
        if (s2 != null) {
          mainState.levelUpSkill(s2, s1['exp']);
          messages.add("${s1['skill']} + ${s1['exp']}");
        } else {
          newSkills.add(s1);
        }
      }

      Map<String, dynamic>? getNewSkill(List<Map<String, dynamic>> skills) {
        skills.sort((a, b) => b['probability'].compareTo(a['probability']));

        Random random = Random();
        double chance = random.nextDouble();

        for (var skill in skills) {
          if (chance < skill['probability']) return skill;
        }

        return null;
      }

      if (newSkills.isNotEmpty) {
        // Randomly pick 1 skill to give to user
        var newSkill = getNewSkill(newSkills);
        if (newSkill != null) {
          mainState.addSkill(newSkill['skill'], newSkill['exp'], newSkill['type']);
          messages.add("New Skill: ${newSkill['skill']} + ${newSkill['exp']}");
        }
      }

      for (var message in messages) {
        taskState.addHintMessage(message);
        // Add a delay of 0.2 seconds
        await Future.delayed(const Duration(milliseconds: 500));
      }
    }

    if (skills == null) {
      // If task not found in database, create new skills
      taskState.addEvaluatingTask(task.id);
      skills = await generateSkillsFromTaskTitle(task.title);
      taskState.removeEvaluatingTask(task.id);
    }

    parseSkills(skills);
    mainState.toggleTask(task);
  }
}
