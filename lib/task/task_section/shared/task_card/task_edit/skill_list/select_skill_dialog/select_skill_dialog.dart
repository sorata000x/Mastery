import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skillborn/main_state.dart';
import 'package:skillborn/services/models.dart';
import 'package:skillborn/task/task_section/shared/task_card/task_edit/skill_list/select_skill_dialog/option_skill_card.dart';

class SelectSkillDialog extends StatelessWidget {
  final Task task;

  const SelectSkillDialog({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<MainState>(context, listen: false);
    var selectableSkills = state.skills
        .where((s) => 
        task.skillExps == null || !task.skillExps!.map((s2) => s2["skillId"]).contains(s.id)).toList();
    return Dialog(
      child: Container(
        padding: EdgeInsets.fromLTRB(10, 6, 10, 0),
        width: double.maxFinite,
        height: 500, // Adjust the height as needed
        decoration: BoxDecoration(
            color: const Color.fromARGB(255, 30, 30, 30),
            borderRadius: BorderRadius.circular(10)),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "Select a skill",
              ),
            ),
            
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(5),
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: selectableSkills.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Column(
                      children: [
                        OptionSkillCard(task: task, skill: selectableSkills[index]),
                        index != selectableSkills.length - 1 ?
                        const Divider(
                          height: 1,
                          color: Color.fromARGB(255, 120, 120, 120),
                        ) : SizedBox(),
                      ],
                    );
                  },
                ),
              ),
            ),
            Spacer(),
            TextButton(onPressed: () => {}, child: Text("Cancel"))
          ],
        ),
      ),
    );
  }
}
