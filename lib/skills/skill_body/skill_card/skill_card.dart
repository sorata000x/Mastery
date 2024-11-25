import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:skillborn/services/models.dart';
import 'package:skillborn/skills/skill_body/skill_card/skill_deletion_dialog.dart';
import 'package:skillborn/skills/skill_body/skill_card/skill_detail.dart';
import 'package:skillborn/skills/skill_body/skill_card/skill_summary.dart';
import 'package:skillborn/skills/skill_icon.dart';

class SkillCard extends StatelessWidget {
  final UserSkill skill;
  final bool isExpanding;
  final void Function(bool) setExpanding;

  const SkillCard({super.key, required this.skill, required this.isExpanding, required this.setExpanding});

  @override
  Widget build(BuildContext context) {
    var cap = 100 * (skill.level * skill.level);
    var percentage = skill.exp / (cap == 0 ? 1 : cap);

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
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300), // Animation duration
                curve: Curves.easeInOut, // Animation curve
        padding: const EdgeInsets.fromLTRB(10, 4, 20, 4),
        child: Column(children: [
          GestureDetector(
            onTap: () => {
              setExpanding(!isExpanding)
            },
            child: Row(
              children: [
                SkillIcon(type: skill.type),
                const SizedBox(width: 5),
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
                          minHeight: 5,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          if (isExpanding)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(skill.description != ''
                  ? skill.description
                  : '(No Description)'),
            )
        ]),
      ),
    );
  }
}
