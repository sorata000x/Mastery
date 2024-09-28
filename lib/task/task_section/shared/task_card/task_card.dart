import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import 'package:skillborn/api/api.dart';
import 'package:skillborn/main_state.dart';
import 'package:skillborn/services/firestore.dart';
import 'package:skillborn/services/models.dart';
import 'package:skillborn/task/task_section/shared/task_card/task_deletion_dialog.dart';
import 'package:skillborn/task/task_section/shared/task_card/task_edit/task_edit.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class TaskCard extends StatelessWidget {
  final Task task;
  const TaskCard({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<MainState>(context);

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
                  builder: (context) => TaskDeletionDialog(task: task));
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
      child: GestureDetector(
        onTap: () => {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => TaskEdit(task: task)),
          )
        },
        child: Container(
          decoration: BoxDecoration(
            color: task.isCompleted
                ? const Color.fromRGBO(40, 40, 40, 1)
                : const Color.fromRGBO(45, 45, 45, 1), // Background color
            borderRadius: BorderRadius.circular(5), // Circular radius
          ),
          alignment: Alignment.center,
          padding: const EdgeInsets.fromLTRB(2.0, 3.0, 0, 3.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              IconButton(
                  onPressed: () {
                    if (task.isCompleted == false) {
                      onTaskComplete(context, task);
                    } else {
                      // Directly toggle tasks of no need to wait for response
                      state.toggleTask(task);
                    }
                  },
                  icon: task.isCompleted
                      ? const Icon(
                          IconData(0xe159, fontFamily: 'MaterialIcons'),
                          size: 30,
                          color: Color.fromARGB(255, 160, 160, 160),
                        )
                      : const Icon(
                          IconData(0xef53, fontFamily: 'MaterialIcons'),
                          size: 30,
                          color: Color.fromARGB(255, 160, 160, 160),
                        )),
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 10, 10, 10),
                  child: Text(
                    task.title,
                    style: TextStyle(
                      fontSize: 17,
                      decoration:
                          task.isCompleted ? TextDecoration.lineThrough : null,
                      color: task.isCompleted ? Colors.grey : null,
                    ),
                    softWrap: true, // Enables wrapping
                    overflow: TextOverflow.visible,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future onTaskComplete(context, task) async {
    final state = Provider.of<MainState>(context, listen: false);
    var skills = await FirestoreService().getSkillsFromTask(task.title);
    var localizations =
        Localizations.of<AppLocalizations>(context, AppLocalizations);

    /// Generate new skills from task title with OpenAI api
    Future<List<Map<String, dynamic>>?> generateSkillsFromTaskTitle(
        taskTitle) async {
      // Get skill as a string of List<Map<String, int>>
      var messages =
          getTaskCompletionMessages(FirestoreService().getSkills(), taskTitle, WidgetsBinding.instance.window.locale);
      var functions = state.functions;
      var result = await callChatGPT(state, messages, functions);
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

      // Find and level up existing skills
      for (var s1 in skills) {
        Skill? s2;
        if (state.skills.any((s) => s.title == s1['skill'])) {
          s2 = state.skills.firstWhere((s) => s.title == s1['skill']);
        }
        if (s2 != null) {
          state.levelUpSkill(s2, s1['exp']);
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
        print("newSkill: $newSkill");
        if (newSkill != null) {
          var skillId = state
              .addSkill(
                newSkill['skill'],
                newSkill['description'] ?? "Error: No description",
                newSkill['exp'] ?? 1,
                newSkill['type'] ?? "error",
              )
              .id;
          state.addSkillToTask(task.id, skillId);
          messages.add(
              "${localizations!.new_skill}: ${newSkill['skill']} + ${newSkill['exp']}");
        }
      }

      for (var message in messages) {
        state.addHintMessage(message);
        // Add a delay of 0.2 seconds
        await Future.delayed(const Duration(milliseconds: 500));
      }
    }

    if (skills == null) {
      // If task not found in database, create new skills
      state.addEvaluatingTask(task.id);
      skills = await generateSkillsFromTaskTitle(task.title);
      state.removeEvaluatingTask(task.id);
    }

    parseSkills(skills);
    state.toggleTask(task);
  }
}
