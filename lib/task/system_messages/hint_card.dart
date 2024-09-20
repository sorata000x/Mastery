import 'package:flutter/material.dart';

class HintCard extends StatelessWidget {
  final String message;

  const HintCard({required this.message});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: 52,
        padding: EdgeInsets.symmetric(horizontal: 19.0),
        decoration: BoxDecoration(
          color: Color.fromRGBO(50, 50, 50, 1),
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
              SizedBox(width: 18),
              Text(
                message,
                style: TextStyle(color: Colors.white, fontSize: 16),
                textAlign: TextAlign.start,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
