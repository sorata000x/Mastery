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
  var expandingSkill;

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
              onReorder: (int oldIndex, int newIndex) {
                state.reorderSkill(oldIndex, newIndex);
                setState(() {
                  expandingSkill = null;
                });
              },
              itemBuilder: (context, index) {
                return Container(
                    key: ValueKey(widget.skills[index].id),
                    child: Column(
                      children: [
                        SkillCard(
                            skill: widget.skills[index],
                            isExpanding: expandingSkill == index,
                            setExpanding: (expanding) => setState(() {
                              if (expanding)
                                expandingSkill = index;
                              else
                                expandingSkill = null;
                            })),
                        const Divider(
                          height: 1,
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
