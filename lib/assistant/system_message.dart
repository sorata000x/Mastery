import 'package:flutter/material.dart';
import 'package:skillborn/services/models.dart';

class SystemMessage extends StatelessWidget {
  final Message message;

  const SystemMessage({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      color: Colors.transparent,
      child: Text(
        message.content,
        style: TextStyle(
          color: const Color.fromARGB(255, 220, 220, 220),
          fontSize: 15,
          ),
      ),
    );
  }
}
