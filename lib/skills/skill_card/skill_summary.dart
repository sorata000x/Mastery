import 'package:flutter/material.dart';
import 'package:skillborn/services/models.dart';
import 'package:skillborn/skills/skill_icon.dart';

class SkillSummary extends StatelessWidget {
  final Skill skill;

  const SkillSummary({super.key, required this.skill});

  @override
  Widget build(BuildContext context) {
    var cap = 100 * (skill.level * skill.level);
    var percentage = skill.exp / (cap == 0 ? 1 : cap);

    return Material(
      child: Container(
        padding: const EdgeInsets.fromLTRB(10, 4, 20, 4),
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
                      Text(skill.title, style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500)),
                      const Spacer(),
                      Text(
                        "LV ${skill.level}",
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                  SizedBox(height: 6,),
                  Padding(
                    padding: const EdgeInsets.only(top: 3, bottom: 4),
                    child: LinearProgressIndicator(
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
    );
  }
}
