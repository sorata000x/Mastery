import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SkillsListCard extends StatelessWidget {
  final String title;

  const SkillsListCard({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 10, 10, 10),
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: const Color.fromRGBO(45, 45, 45, 1),
        borderRadius: BorderRadius.circular(5.0),
      ),
      child: Row(children: [
        const Icon(
          FontAwesomeIcons.bolt,
          size: 14,
          color: Colors.white,
        ),
        const SizedBox(width: 14),
        Text(title)
        ]),
    );
  }
}