import 'package:flutter/material.dart';
import 'package:skillcraft/services/models.dart';
import 'package:skillcraft/skills/skill_icon.dart';

class SkillCard extends StatelessWidget {
  final Skill skill;

  const SkillCard({super.key, required this.skill});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(10, 10, 20, 10),
        child: Row(
          children: [
            SkillIcon(type: skill.type),
            const SizedBox(width: 5),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(skill.title),
                  Padding(
                    padding: const EdgeInsets.only(top: 3, bottom: 3),
                    child: LinearProgressIndicator(
                      value: skill.exp / (100 * (skill.level ^ 2)),
                    ),
                  ),
                  Row(
                    children: [
                      Text(
                        "EXP ${skill.exp} / ${100 * (skill.level ^ 2)}",
                        style: const TextStyle(fontSize: 14),
                      ),
                      const Spacer(),
                      Text(
                        "LV.${skill.level}",
                        style: const TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
    );
  }
}
