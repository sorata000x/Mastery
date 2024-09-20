import 'package:flutter/material.dart';

class TaskEvalurationCard extends StatelessWidget {
  const TaskEvalurationCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.transparent, // Background color
        borderRadius: BorderRadius.circular(5), // Circular radius
      ),
      height: 52,
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.only(left: 16.0),
      child: const Row(
        children: [
          SizedBox(height: 20, width: 20, child: CircularProgressIndicator()),
          SizedBox(width: 16),
          Text(
            "Evaluating",
            style: TextStyle(
              fontSize: 17,
            ),
          ),
        ],
      ),
    );
  }
}