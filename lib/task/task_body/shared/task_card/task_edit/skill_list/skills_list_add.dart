import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:skillborn/api/api.dart';
import 'package:skillborn/main_state.dart';
import 'package:skillborn/services/models.dart';
import 'package:skillborn/task/task_body/shared/task_card/task_edit/skill_list/select_skill_dialog/option_skill_card.dart';
import 'package:skillborn/task/task_body/shared/task_card/task_edit/skill_list/select_skill_dialog/select_skill_dialog.dart';

class SkillsListAdd extends StatelessWidget {
  final Task task;

  const SkillsListAdd({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<MainState>(context, listen: false);

    void _showItemSelectionDialog() {
      showDialog<String>(
        context: context,
        builder: (BuildContext context) {
          return SelectSkillDialog(task: task);
        },
      );
    }

    return Container(
      width: MediaQuery.of(context).size.width,
      child: TextButton(
        onPressed: _showItemSelectionDialog,
        child: Row(children: [
          const Icon(
            Icons.add,
            size: 22,
            color: Colors.grey,
          ),
          const SizedBox(width: 9),
          Text(
            "Add Linked Skill",
            style: TextStyle(
              color: Colors.grey,
            ),
          ),
        ]),
      ),
    );
  }
}
