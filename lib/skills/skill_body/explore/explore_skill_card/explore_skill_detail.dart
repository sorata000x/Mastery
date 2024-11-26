import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skillborn/main_state.dart';
import 'package:skillborn/services/models.dart';
import 'package:skillborn/skills/skill_body/explore/explore_skill_card/explore_skill_summary.dart';
import 'package:skillborn/skills/skill_body/explore/explore_skill_card/get_skill_button.dart';
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
                    globalSkill.path == '' ? SizedBox() : Text(globalSkill.path, style: TextStyle(color: Colors.grey, fontSize: 18, fontWeight: FontWeight.w500)),
                    Text(
                      globalSkill.name,
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    //Text(
                    //  globalSkill.rank,
                    //  style: TextStyle(
                    //      color: rank?['color'], fontWeight: FontWeight.w500),
                    //),
                    //Text("(Max Level: ${rank?['max-level']})",
                    //    style: TextStyle(color: Colors.grey, fontSize: 14)),
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
                  ],
                ),
              ),
            ),
            Container(
              color: Colors.black,
              width: double.infinity,
              padding: EdgeInsets.only(bottom: 60),
              child: Center(
                child: Container(
                    width: 200,
                    decoration: BoxDecoration(
                        color: mainState.karma < rank?['cost']
                            ? const Color.fromARGB(255, 70, 70, 70)
                            : const Color.fromARGB(255, 72, 93, 104),
                        borderRadius: BorderRadius.circular(10)),
                    child: TextButton(
                        onPressed: () {
                          if (mainState.karma < rank?['cost']) return;
                          int cost = rank?['cost'];
                          mainState.setKarma(mainState.karma - cost);
                          mainState.setSkill(
                              globalSkill.id,
                              name: globalSkill.name,
                              description: globalSkill.description,
                              type: globalSkill.type,
                              category: globalSkill.category,
                              author: globalSkill.author,
                              rank: globalSkill.rank,
                              );
                          // Return to skill page
                          Navigator.pop(context);
                          Navigator.pop(context);
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Get Skill (',
                              style: TextStyle(
                                  fontSize: 16,
                                  color: mainState.karma < rank?['cost']
                                      ? const Color.fromARGB(255, 170, 170, 170)
                                      : Colors.white),
                            ),
                            Icon(Icons.emergency,
                                size: 16,
                                color: mainState.karma < rank?['cost']
                                    ? const Color.fromARGB(255, 170, 170, 170)
                                    : Colors.white),
                            Text('${rank?['cost']})',
                                style: TextStyle(
                                    fontSize: 16,
                                    color: mainState.karma < rank?['cost']
                                        ? const Color.fromARGB(
                                            255, 170, 170, 170)
                                        : Colors.white)),
                          ],
                        ))),
              ),
            )
          ],
        ),
      ),
    );
  }
}
