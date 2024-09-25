import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class HintCard extends StatelessWidget {
  final String message;

  const HintCard({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 3),
        child: Container(
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.fromLTRB(19.0, 15.0, 19.0, 15.0),
          decoration: BoxDecoration(
            color: const Color.fromRGBO(45, 45, 45, 1),
            // Color.fromRGBO(45, 45, 45, 1)
            borderRadius: BorderRadius.circular(5.0),
            boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.5),  // Shadow color with opacity
                    spreadRadius: 0,  // Spread radius (makes the shadow bigger)
                    blurRadius: 5,  // Blur radius (makes the shadow softer)
                    offset: Offset(0, -4),
                  ),
                ],
          ),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Row(
              children: [
                const FaIcon(
                  FontAwesomeIcons.upLong, // Use a Font Awesome icon here
                  size: 20.0,
                  color: Colors.white,
                ),
                const SizedBox(width: 18),
                Flexible(
                  child: Text(
                    message,
                    style: const TextStyle(color: Colors.white, fontSize: 16),
                    softWrap: true,
                    textAlign: TextAlign.start,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
