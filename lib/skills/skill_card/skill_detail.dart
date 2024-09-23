import 'package:flutter/material.dart';
import 'package:skillborn/services/models.dart';
import 'package:skillborn/skills/skill_card/skill_summary.dart';
import 'package:skillborn/skills/skill_icon.dart';

class SkillDetail extends StatelessWidget {
  final Skill skill;

  const SkillDetail({super.key, required this.skill});

  @override
  Widget build(BuildContext context) {
    var cap = 100 * (skill.level * skill.level);
    var percentage = skill.exp / (cap == 0 ? 1 : cap);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Hero(
        tag: 'skill_card_${skill.id}', 
        child: Material(
          child: SingleChildScrollView(
            child: Column(
              children: [
                SkillSummary(skill: skill),
                Padding(
                  padding: EdgeInsets.fromLTRB(16, 10, 16, 10),
                  child: Text(skill.description),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
