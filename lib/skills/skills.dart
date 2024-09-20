import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:skillcraft/main_state.dart';
import 'package:skillcraft/services/services.dart';
import 'package:skillcraft/shared/bottom_nav.dart';
import 'package:skillcraft/shared/error.dart';
import 'package:skillcraft/shared/loading.dart';

class SkillsScreen extends StatelessWidget {
  const SkillsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<MainState>(context);

    return Scaffold(
        appBar: AppBar(
          title: Text("Skills"),
        ),
        body: buildSkillSection(state.skills));
  }

  Widget buildSkillSection(List skills) {
    return SingleChildScrollView(
      child: Column(
        children: skills.map<Widget>((skill) {
          return Column(
            children: [
              skillCard(skill),
              const Divider(
                height: 5,
                thickness: 5,
                color: Colors.transparent,
              ),
            ],
          );
        }).toList(),
      ),
    );
  }

  Widget SkillIcon(type) {
    var iconName = 'star';
    if (type == 'fitness') {
      iconName = 'run';
    }
    if (type == 'sports') {
      iconName = 'star';
    }
    if (type == 'strength') {
      iconName = 'muscle_up';
    }
    if (type == 'chores') {
      iconName = 'broom';
    }
    if (type == 'thinking') {
      iconName = 'brain';
    }
    if (type == 'memory') {
      iconName = 'brain';
    }
    if (type == 'focus') {
      iconName = 'focus';
    }
    if (type == 'learning') {
      iconName = 'open_book';
    }
    if (type == 'emotion') {
      iconName = 'emotion';
    }
    if (type == 'creative') {
      iconName = 'lightbulb';
    }
    if (type == 'social') {
      iconName = 'handshake';
    }
    if (type == 'software') {
      iconName = 'code';
    }
    if (type == 'hardware') {
      iconName = 'gear';
    }
    if (type == 'cook') {
      iconName = 'cook';
    }
    return Container(
      child: Padding(
        padding: EdgeInsets.all(8),
        child: SizedBox(
          height: 34,
          width: 34,
          child: SvgPicture.asset(
            'lib/assets/icons/$iconName.svg',
            colorFilter: const ColorFilter.mode(
              Colors.white, // Replace with your desired color
              BlendMode
                  .srcIn, // This blend mode ensures the color is applied to the SVG
            ),
          ),
        ),
      ),
    );
  }

  Widget skillCard(skill) {
    print("skillCard: ${skill.toJson()}");
    return Container(
      padding: EdgeInsets.fromLTRB(10, 10, 20, 10),
      child: Expanded(
        child: Row(
          children: [
            SkillIcon(skill.type),
            SizedBox(width: 5),
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
                        style: TextStyle(fontSize: 14),
                      ),
                      Spacer(),
                      Text(
                        "LV.${skill.level}",
                        style: TextStyle(fontSize: 14),
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
