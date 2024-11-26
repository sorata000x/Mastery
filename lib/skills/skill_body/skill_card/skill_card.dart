import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import 'package:skillborn/main_state.dart';
import 'package:skillborn/services/models.dart';
import 'package:skillborn/skills/skill_body/skill_card/skill_deletion_dialog.dart';
import 'package:skillborn/skills/skill_body/skill_card/skill_detail.dart';
import 'package:skillborn/skills/skill_body/skill_card/skill_summary.dart';
import 'package:skillborn/skills/skill_icon.dart';

class SkillCard extends StatelessWidget {
  final UserSkill skill;
  final bool isExpanding;
  final void Function(bool) setExpanding;

  const SkillCard(
      {super.key,
      required this.skill,
      required this.isExpanding,
      required this.setExpanding});

  @override
  Widget build(BuildContext context) {
    var cap = 100 * (skill.level * skill.level);
    var percentage = skill.exp / (cap == 0 ? 1 : cap);
    final state = Provider.of<MainState>(context);
    var pathName = state.paths
        .firstWhere((path) => path.id == skill.path, orElse: () => SkillPath()).title;
    void _showPathDialog(BuildContext context) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Choose an Option"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: state.paths.map((path) {
                return ListTile(
                  title: Text(path.title),
                  onTap: () {
                    Navigator.of(context)
                        .pop(path.title); // Close dialog and return option
                    state.setSkill(skill.id, path: path.id);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                          content: Text(
                              'Moved "${skill.name}" to path "${path.title}"',
                              style: TextStyle(
                                color: Colors.white,
                              )
                              ),
                        ),
                    );
                  },
                );
              }).toList(),
            ),
          );
        },
      );
    }

    return Slidable(
      key: Key(skill.id),
      endActionPane: ActionPane(
        motion: const DrawerMotion(),
        extentRatio: 0.15,
        children: [
          SlidableAction(
            onPressed: (context) {
              // Show a confirmation dialog
              showDialog(
                  context: context,
                  builder: (context) => SkillDeletionDialog(skill: skill));
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
        padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
        child: Column(children: [
          GestureDetector(
            onTap: () => {
              Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SkillDetail(skill: skill)),
          )
            },
            child: Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Row(
                children: [
                  SkillIcon(type: skill.type),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(skill.name,
                                style: TextStyle(
                                    fontSize: 17, fontWeight: FontWeight.w500)),
                            const Spacer(),
                            Text(
                              "LV ${skill.level}",
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 6,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 3, bottom: 4),
                          child: LinearProgressIndicator(
                            color: Colors.blueGrey,
                            value: percentage,
                            minHeight: 6,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 10,)
                ],
              ),
            ),
          ),
          if (isExpanding)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(skill.description != ''
                      ? skill.description
                      : '(No Description)'),
                  SizedBox(height: 10,),
                  TextButton(
                    onPressed: () => {_showPathDialog(context)},
                    child: Text('Path: ${pathName == '' ? 'none' : pathName}'),
                    style: TextButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(10), // Rounded corners
                        ),
                        backgroundColor:
                            Theme.of(context).colorScheme.primaryContainer),
                  ),
                ],
              ),
            )
        ]),
      ),
    );
  }
}
