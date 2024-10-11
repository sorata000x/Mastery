import 'package:flutter/material.dart';

class ProfileField extends StatelessWidget {
  final String label;

  const ProfileField({super.key, required this.label});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(4, 4, 8, 4),
            child: Text(
              label,
              style: TextStyle(
                color: Color.fromARGB(255, 180, 180, 180),
              ),
            ),
          ),
          Container(
            height: 30,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6),
              color: const Color.fromRGBO(45, 45, 45, 1),
            ),
            child: TextField(
              decoration: InputDecoration(
                border: InputBorder.none,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
