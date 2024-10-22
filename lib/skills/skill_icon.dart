import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class SkillIcon extends StatelessWidget {
  final String type;
  final double size;

  const SkillIcon({super.key, required this.type, this.size = 34});

  @override
  Widget build(BuildContext context) {
    var iconName = 'star';
    if (type == 'energy') {
      iconName = 'bolt';
    }
    if (type == 'endurance') {
      iconName = 'mountain';
    }
    if (type == 'run-walk') {
      iconName = 'run';
    }
    if (type == 'cycling') {
      iconName = 'cycling';
    }
    if (type == 'swim') {
      iconName = 'swim';
    }
    if (type == 'sports') {
      iconName = 'star';
    }
    if (type == 'strength') {
      iconName = 'muscle_up';
    }
    if (type == 'stretching') {
      iconName = 'stretching';
    }
    if (type == 'clean') {
      iconName = 'clean_hand';
    }
    if (type == 'cook') {
      iconName = 'cook';
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
    if (type == 'creativity') {
      iconName = 'lightbulb';
    }
    if (type == 'problem-solving') {
      iconName = 'problem-solving';
    }
    if (type == 'mental') {
      iconName = 'brain';
    }
    if (type == 'sleep') {
      iconName = 'sleep';
    }
    if (type == 'food') {
      iconName = 'food';
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
    if (type == 'design') {
      iconName = 'design';
    }
    var padding = 4.0;
    if (size > 30) {
      padding = 10.0;
    }
    return Container(
      padding: EdgeInsets.all(padding),
      decoration: BoxDecoration(
        color: const Color.fromARGB(120, 0, 0, 0),
        shape: BoxShape.circle,
      ),
      child: SizedBox(
        height: size,
        width: size,
        child: SvgPicture.asset(
          'lib/assets/icons/skills/$iconName.svg',
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
