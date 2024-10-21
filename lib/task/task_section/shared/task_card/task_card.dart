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
import 'package:uuid/uuid.dart';

class TaskCard extends StatelessWidget {
  final Task task;
  const TaskCard({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<MainState>(context);
    var localizations =
        Localizations.of<AppLocalizations>(context, AppLocalizations);

    Future levelUpSkills() async {
      var messages = [];
      if (state.skills.isEmpty) return null;
      var skillExps = task.skillExps;
      if (skillExps == null) {
        skillExps = await generateSkillExpFromTask(state, task) ?? [];
        state.setTask(Task(
            id: task.id,
            title: task.title,
            note: task.note,
            skillExps: skillExps,
            index: task.index,
            isCompleted: task.isCompleted));
      }
      // Level up skills
      for (var skillExp in skillExps) {
        state.levelUpSkillById(skillExp["skillId"], skillExp["exp"]);
        var skill = state.skills.firstWhere((s) => s.id == skillExp["skillId"]);
        messages.add("${skill.name} + ${skillExp["exp"]}");
      }
      // Display level up messages
      for (var message in messages) {
        state.addHintMessage(message);
        // Add a delay of 0.2 seconds
        await Future.delayed(const Duration(milliseconds: 500));
      }
    }

    Future drawSkill() async {
      var messages = [];
      const probabilities = {
        "Common": 0.1,
        "Uncommon": 0.05,
        "Rare": 0.01,
        "Epic": 0.005,
        "Legendary": 0.0001,
      };
      // List of ids for the skills that are associated with the task
      // First find existing skills associated with task
      Set<String> skillsId =
          await FirestoreService().getGlobalTaskSkills(task.title) ?? {};
      // If not existing skills, generate new skills for the task
      if (skillsId.isEmpty) {
        // Generate new skills for the task
        var result = await generateNewSkills(state, task.title) ?? [];
        var skills = [];
        // Add generated skills to global skills and global task skills
        for (var skill in result) {
          var id = Uuid().v4();
          var newGlobalSkill = Skill(
            id: id,
            name: skill["name"] ?? "Unknown",
            description: skill["description"] ?? "",
            effect: skill["effect"] ?? "",
            cultivation: skill["cultivation"] ?? "",
            type: skill["type"] ?? "other",
            category: skill["category"] ?? "Other",
            author: "Skillborn GPT",
            rank: "Common",
          );
          state.setGlobalSkill(newGlobalSkill);
          skillsId.add(newGlobalSkill.id);
          skills.add(newGlobalSkill);
        }
        FirestoreService().setGlobalTaskSkills(task.title, skillsId);
      }
      print("skillsId: $skillsId");
      // Filter out skills user already have
      var userSkillIds = state.skills.map((s) => s.id);
      print("userSkillIds: $userSkillIds");
      skillsId = skillsId.where((s) => !userSkillIds.contains(s)).toSet();
      // Find corresponding global skills
      print("skillsId: $skillsId");
      List<Skill> skills =
          state.globalSkills.where((s) => skillsId.contains(s.id)).toList();
      print("skills: $skills");
      if (skills.isEmpty) return;
      // Randomly get a skill (low probability)
      final random = Random();
      for (var skill in skills) {
        var rank = skill.rank;
        var probability = probabilities[rank] ?? 0;
        print("probability: $probability");
        if (random.nextDouble() < (probability / skills.length)) {
          // TODO: Prompt to ask if user want to add the skill
          // Add new skill
          state.setSkill(UserSkill.fromSkill(skill, 0, 0, 1));
          // Generate tasks' skillExps for new skill
          var exps = await generateSkillExpForTasks(
              state, UserSkill.fromSkill(skill, 0, 0, 1));
          if (exps != null) {
            for (var i = 0; i < exps.length; i++) {
              if (exps[i] > 0) {
                var skillExps = state.tasks[i].skillExps ?? [];
                state.setTask(Task(
                    id: state.tasks[i].id,
                    title: state.tasks[i].title,
                    note: state.tasks[i].note,
                    skillExps: [
                      ...skillExps,
                      {"skillId": skill.id, "exp": exps[i]}
                    ],
                    index: state.tasks[i].index,
                    isCompleted: state.tasks[i].isCompleted));
              }
            }
          }
          messages.add("${localizations!.new_skill}: ${skill.name}");
        }
      }
      // Display new skill messages
      for (var message in messages) {
        state.addHintMessage(message);
        // Add a delay of 0.2 seconds
        await Future.delayed(const Duration(milliseconds: 500));
      }
    }

    void onTaskComplete(task) {
      state.addEvaluatingTask(task.id);
      levelUpSkills().then((_) => {
        drawSkill().then((_) {
          state.removeEvaluatingTask(task.id);
          state.toggleTask(task);
        })
      });
    }

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
                      onTaskComplete(task);
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
}
