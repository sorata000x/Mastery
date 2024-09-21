import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class HintCard extends StatelessWidget {
  final String message;

  const HintCard({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: 58,
        padding: const EdgeInsets.symmetric(horizontal: 19.0),
        decoration: BoxDecoration(
          color: const Color.fromRGBO(50, 50, 50, 1),
          // Color.fromRGBO(45, 45, 45, 1)
          borderRadius: BorderRadius.circular(5.0),
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
              Text(
                message,
                style: const TextStyle(color: Colors.white, fontSize: 16),
                textAlign: TextAlign.start,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
