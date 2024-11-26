import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:skillborn/skills/skill_body/explore/explore.dart';
import 'package:skillborn/skills/skill_body/explore/explore_state.dart';

class ExploreSkillButton extends StatelessWidget {
  const ExploreSkillButton({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => {
        Navigator.push(
          context, 
          MaterialPageRoute(builder: (context) => 
          ChangeNotifierProvider(
            create: (_) => ExploreState(),
            child: Explore(),
          ),
          ),
        )
      },
      child: Padding(
        padding: const EdgeInsets.fromLTRB(10, 0, 10, 4),
        child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primaryContainer,
            borderRadius: BorderRadius.circular(10), // Circular border radius
          ),
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
                child: SizedBox(
                  height: 30,
                  width: 30,
                  child: SvgPicture.asset(
                    'lib/assets/icons/explore.svg',
                    colorFilter: const ColorFilter.mode(
                      Color.fromARGB(
                          255, 180, 180, 180), // Replace with your desired color
                      BlendMode
                          .srcIn, // This blend mode ensures the color is applied to the SVG
                    ),
                  ),
                ),
              ),
              Text(
                "Explore Skills",
                style: TextStyle(
                  fontSize: 18.0, // Set the font size here
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
