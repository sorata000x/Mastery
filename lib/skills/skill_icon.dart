import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class SkillIcon extends StatelessWidget {
  final String type;

  const SkillIcon({super.key, required this.type});

  @override
  Widget build(BuildContext context) {
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
    return Padding(
      padding: const EdgeInsets.all(8),
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
    );
  }
}
