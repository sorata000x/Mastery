import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skillborn/main_state.dart';
import 'package:skillborn/services/models.dart';
import 'package:skillborn/task/task_body/shared/task_card/task_edit/skill_list/skills_list_add.dart';
import 'package:skillborn/task/task_body/shared/task_card/task_edit/skill_list/skills_list_card.dart';

class SkillsList extends StatelessWidget {
  final Task task;

  const SkillsList({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    final mainState = Provider.of<MainState>(context, listen: false);
    var skills = mainState.skills
        .where((s) =>
          task.skillExps != null && task.skillExps!.any((se) => se["skillId"] == s.id))
        .toList();
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.fromLTRB(16, 6, 16, 6),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Padding(
          padding: EdgeInsets.fromLTRB(3, 6, 3, 6),
          child: Text("Linked Skills",
              style: TextStyle(
                color: Colors.grey,
                fontSize: 16,
              )
            )
          ),
        ...skills.map((s) => Column(
          children: [
            SkillsListCard(task: task, skill: s),
            const SizedBox(
              height: 4,
            ),
          ],
        )),
        SkillsListAdd(task: task),
      ]),
    );
  }
}
