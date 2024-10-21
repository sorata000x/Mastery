import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skillborn/main_state.dart';
import 'package:skillborn/services/models.dart';
import 'package:skillborn/skills/explore/explore_skill_card/explore_skill_summary.dart';
import 'package:skillborn/skills/skill_icon.dart';

class ExploreSkillDetail extends StatelessWidget {
  final Skill globalSkill;

  const ExploreSkillDetail({super.key, required this.globalSkill});

  final Map ranks = const {
    'Mythic': {
      'max-level': 100,
      'cost': 2000,
      'color': Colors.purple,
    },
    'Legendary': {
      'max-level': 80,
      'cost': 1000,
      'color': Color.fromARGB(255, 211, 172, 32),
    },
    'Rare': {
      'max-level': 50,
      'cost': 500,
      'color': Colors.blue,
    },
    'Uncommon': {
      'max-level': 30,
      'cost': 200,
      'color': Colors.green,
    },
    'Common': {
      'max-level': 10,
      'cost': 100,
      'color': Colors.grey,
    },
  };

  @override
  Widget build(BuildContext context) {
    final mainState = Provider.of<MainState>(context);
    Map? rank = ranks[globalSkill.rank];

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Material(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SkillIcon(type: globalSkill.type, size: 46),
                    SizedBox(
                      height: 8,
                    ),
                    Text(
                      globalSkill.name,
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      globalSkill.rank,
                      style: TextStyle(
                          color: rank?['color'], fontWeight: FontWeight.w500),
                    ),
                    Text("(Max Level: ${rank?['max-level']})",
                        style: TextStyle(color: Colors.grey, fontSize: 14)),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Description",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(globalSkill.description),
                        ],
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Effect",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(globalSkill.effect.replaceAll('\\n', '\n')),
                        ],
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Cultivation",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(globalSkill.cultivation),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              color: Colors.black,
              width: double.infinity,
              padding: EdgeInsets.all(10),
              child: Center(
                child: Container(
                  width: 200,
                  decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 100, 100, 100),
                      borderRadius: BorderRadius.circular(10)),
                  child: TextButton(
                      onPressed: () {
                        mainState.setSkill(UserSkill.fromSkill(globalSkill, 0, 0, 1));
                        // Return to skill page
                        Navigator.pop(context);
                        Navigator.pop(context);
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Get Skill (',
                            style: TextStyle(fontSize: 16),
                          ),
                          Icon(
                            Icons.emergency,
                            size: 16,
                          ),
                          Text('${rank?['cost']})',
                              style: TextStyle(fontSize: 16)),
                        ],
                      )),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
