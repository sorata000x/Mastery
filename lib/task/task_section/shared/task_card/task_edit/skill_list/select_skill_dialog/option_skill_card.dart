import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skillborn/api/api.dart';
import 'package:skillborn/main_state.dart';
import 'package:skillborn/services/models.dart';
import 'package:skillborn/skills/skill_card/skill_detail.dart';
import 'package:skillborn/skills/skill_card/skill_summary.dart';
import 'package:skillborn/task/task_section/shared/task_card/task_edit/skill_list/select_skill_dialog/option_skill_summary.dart';

class OptionSkillCard extends StatelessWidget {
  final Task task;
  final UserSkill skill;

  const OptionSkillCard({super.key, required this.task, required this.skill});

  @override
  Widget build(BuildContext context) {
    var cap = 100 * (skill.level * skill.level);
    var percentage = skill.exp / (cap == 0 ? 1 : cap);
    final state = Provider.of<MainState>(context, listen: false);

    return GestureDetector(
      onTap: () async {
        var exps = await generateSkillExpForTasks(
                state, UserSkill.fromSkill(skill, 0, 0, 1), state.tasks) ??
            [20];
        var newSkillExp = {
          "skillId": skill.id,
          "exps": exps[0],
        };
        WidgetsBinding.instance.addPostFrameCallback((_) {
          // Use call back for async function
          state.setTask(Task(
            id: task.id,
            title: task.title,
            note: task.note,
            skillExps: [...?task.skillExps, newSkillExp],
            index: task.index,
            isCompleted: task.isCompleted,
          ));
        });
        Navigator.pop(context);
      },
      child: OptionSkillSummary(skill: skill),
    );
  }
}
