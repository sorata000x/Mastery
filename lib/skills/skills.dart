import 'package:flutter/material.dart';
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
      body: buildSkillSection(state.skills)
    );
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

  Widget skillCard(skill) {
    print("skillCard: ${skill.toJson()}");
    return Container(
      padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
      child: SingleChildScrollView(
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
    );
  }
}
