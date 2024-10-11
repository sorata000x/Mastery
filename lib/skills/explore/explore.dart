import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:skillborn/main_state.dart';
import 'package:skillborn/skills/explore/categories/categories.dart';
import 'package:skillborn/skills/explore/create_skill/create_skill.dart';
import 'package:skillborn/skills/explore/explore_skill_card/explore_skill_card.dart';
import 'package:skillborn/skills/explore/explore_state.dart';

class Explore extends StatelessWidget {
  const Explore({super.key});

  @override
  Widget build(BuildContext context) {
    final mainState = Provider.of<MainState>(context);
    final exploreState = Provider.of<ExploreState>(context);
    var category = exploreState.categories[exploreState.selected];

    return Scaffold(
      appBar: AppBar(
        title: Text("Explore"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Stack(
        children: [
          Column(
            children: [
              Categories(),
              SizedBox(
                height: 10,
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18),
                  child: (ListView.builder(
                      itemCount: category == 'My Skills'
                          ? mainState.createdSkills.length
                          : mainState.globalSkills.length,
                      itemBuilder: (context, index) {
                        if (category == 'My Skills') {
                          return Column(
                            children: [
                              ExploreSkillCard(
                                  globalSkill: mainState.createdSkills[index]),
                              SizedBox(
                                height: 6,
                              )
                            ],
                          );
                        } else if (category == 'Top Picks') {
                          return Column(
                            children: [
                              ExploreSkillCard(
                                  globalSkill: mainState.globalSkills[index]),
                              SizedBox(
                                height: 6,
                              )
                            ],
                          );
                        } else if (category ==
                            mainState.globalSkills[index].category) {
                          return Column(
                            children: [
                              ExploreSkillCard(
                                  globalSkill: mainState.globalSkills[index]),
                              SizedBox(
                                height: 6,
                              )
                            ],
                          );
                        } else {
                          return null;
                        }
                      })),
                ),
              )
            ],
          ),
          Positioned(
              left: 0,
              right: 0,
              bottom: 20,
              child: Center(
                child: Container(
                  padding: EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                      onPressed: () => {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => CreateSkill()),
                            )
                          },
                      icon: Icon(
                        Icons.add,
                        color: Colors.black,
                        size: 40,
                      )),
                ),
              ))
        ],
      ),
    );
  }
}
