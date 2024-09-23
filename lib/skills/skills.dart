import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skillborn/main_state.dart';
import 'package:skillborn/skills/skill_card/skil_card.dart';

class SkillsScreen extends StatelessWidget {
  const SkillsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<MainState>(context);

    return Scaffold(
        appBar: AppBar(
          title: const Text("Skills"),
        ),
        body: buildSkillSection(state, state.skills));
  }

  Widget buildSkillSection(state, List skills) {
    return Container(
      child: (ReorderableListView.builder(
          itemCount: skills.length,
          onReorder: state.reorderSkill,
          itemBuilder: (context, index) {
            return Container(
                key: ValueKey(skills[index].id),
                child: Column(
                  children: [
                    SkillCard(skill: skills[index]),
                    const Divider(
                      height: 5,
                      thickness: 5,
                      color: Colors.transparent,
                    ),
                  ],
                ));
          })),
    );
  }
}
