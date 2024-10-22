import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skillborn/main_state.dart';
import 'package:skillborn/services/models.dart';

class GetSkillButton extends StatelessWidget {
  final Map? rank;
  final Skill globalSkill;

  const GetSkillButton(
      {super.key, required this.rank, required this.globalSkill});

  @override
  Widget build(BuildContext context) {
    final mainState = Provider.of<MainState>(context);

    if (mainState.karma < rank?['cost']) {
      return TextButton(
          onPressed: () {},
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
              Text('${rank?['cost']})', style: TextStyle(fontSize: 16)),
            ],
          ));
    }

    return TextButton(
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
            Text('${rank?['cost']})', style: TextStyle(fontSize: 16)),
          ],
        ));
  }
}
