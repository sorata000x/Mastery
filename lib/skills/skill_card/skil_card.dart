import 'package:flutter/material.dart';
import 'package:skillborn/services/models.dart';
import 'package:skillborn/skills/skill_card/skill_detail.dart';
import 'package:skillborn/skills/skill_card/skill_summary.dart';

class SkillCard extends StatelessWidget {
  final Skill skill;

  const SkillCard({super.key, required this.skill});

  @override
  Widget build(BuildContext context) {
    var cap = 100 * (skill.level * skill.level);
    var percentage = skill.exp / (cap == 0 ? 1 : cap);

    return GestureDetector(
      onTap: () => {
        Navigator.push(
          context, 
          MaterialPageRoute(builder: (context) => 
            SkillDetail(skill: skill)
          ),
        )
      },
      child: Hero(
        tag: 'skill_card_${skill.id}',
        child: SkillSummary(skill: skill),
      ),
    );
  }
}
