import 'package:flutter/material.dart';
import 'package:skillborn/services/models.dart';

class UserMessage extends StatelessWidget {
  final Message message;

  const UserMessage({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        padding: const EdgeInsets.all(12),
        margin: const EdgeInsets.symmetric(vertical: 4),
        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 60, 86, 99),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          message.content ?? '',
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
