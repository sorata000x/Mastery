import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skillborn/main_state.dart';
import 'package:skillborn/skills/skill_body/explore/explore_skill_button.dart';
import 'package:skillborn/skills/skill_body/skill_body.dart';
import 'package:skillborn/skills/skill_body/skill_card/skill_card.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:skillborn/skills/skills_drawer.dart';

class SkillsScreen extends StatelessWidget {
  const SkillsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<MainState>(context);

    return Scaffold(
        appBar: AppBar(
          title: Text(AppLocalizations.of(context)!.skills),
        ),
        drawer: SkillsDrawer(),
        body: SkillBody( skills:
            state.skills
                .where((s) =>
                    s.path == state.selectedPath.id || state.selectedPath.id == 'all')
                .toList()));
  }
}
