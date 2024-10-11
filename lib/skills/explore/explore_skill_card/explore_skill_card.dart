import 'package:flutter/material.dart';
import 'package:skillborn/services/models.dart';
import 'package:skillborn/skills/explore/explore_skill_card/explore_skill_detail.dart';
import 'package:skillborn/skills/explore/explore_skill_card/explore_skill_summary.dart';

class ExploreSkillCard extends StatelessWidget {
  final GlobalSkill globalSkill;

  const ExploreSkillCard({super.key, required this.globalSkill});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => {
        Navigator.push(
          context, 
          MaterialPageRoute(builder: (context) => 
            ExploreSkillDetail(globalSkill: globalSkill)
          ),
        )
      },
      child: Hero(
        tag: 'skill_card_${globalSkill.id}',
        child: ExploreSkillSummary(globalSkill: globalSkill),
      ),
    );
  }
}
