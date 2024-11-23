import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skillborn/main_state.dart';
import 'package:skillborn/services/models.dart';
import 'package:skillborn/skills/skill_body/explore/explore_skill_button.dart';
import 'package:skillborn/skills/skill_body/path_title.dart';
import 'package:skillborn/skills/skill_body/skill_card/skill_card.dart';

class SkillBody extends StatefulWidget {
  final List<UserSkill> skills;

  const SkillBody({super.key, required this.skills});

  @override
  State<SkillBody> createState() => _SkillBodyState();
}

class _SkillBodyState extends State<SkillBody> {
  @override
  Widget build(BuildContext context) {
    final state = Provider.of<MainState>(context);

    return Column(
      children: [
        state.selectedPath.id != 'all' ? PathTitle() : SizedBox(),
        ExploreSkillButton(),
        Expanded(
          child: (ReorderableListView.builder(
              itemCount: widget.skills.length,
              onReorder: state.reorderSkill,
              itemBuilder: (context, index) {
                return Container(
                    key: ValueKey(widget.skills[index].id),
                    child: Column(
                      children: [
                        SkillCard(skill: widget.skills[index]),
                        const Divider(
                          height: 5,
                          thickness: 5,
                          color: Colors.transparent,
                        ),
                      ],
                    ));
              })),
        ),
      ],
    );
  }
}
