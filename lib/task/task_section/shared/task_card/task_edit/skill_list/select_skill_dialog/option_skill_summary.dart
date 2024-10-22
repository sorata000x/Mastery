import 'package:flutter/material.dart';
import 'package:skillborn/services/models.dart';
import 'package:skillborn/skills/skill_icon.dart';

class OptionSkillSummary extends StatelessWidget {
  final UserSkill skill;

  const OptionSkillSummary({super.key, required this.skill});

  @override
  Widget build(BuildContext context) {
    var cap = 100 * (skill.level * skill.level);
    var percentage = skill.exp / (cap == 0 ? 1 : cap);

    return Material(
      child: Container(
        padding: const EdgeInsets.fromLTRB(16, 10, 10, 10),
        color: const Color.fromARGB(255, 50, 50, 50),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(skill.name, style: TextStyle(fontSize: 16)),
                      const Spacer(),
                      Text(
                        "Lv ${skill.level}",
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
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
