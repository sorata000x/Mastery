import 'package:flutter/material.dart';
import 'package:skillborn/services/models.dart';

class MessageBlock extends StatelessWidget {
  final Message message;

  const MessageBlock({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    final isUserMessage = message.role == 'user';
    var color;
    if (isUserMessage) {
      color = Theme.of(context).colorScheme.primaryContainer;
    } else if (message.content.startsWith('[System Message]')) {
      color = const Color.fromARGB(80, 96, 125, 139);
    } else {
      color = Colors.transparent;
    }
    return Container(
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.symmetric(vertical: 4),
      constraints: isUserMessage
          ? BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75)
          : BoxConstraints(maxWidth: MediaQuery.of(context).size.width),
      decoration: BoxDecoration(
        color: color,
        borderRadius: isUserMessage ? BorderRadius.circular(12) : null,
      ),
      child: Text(
        message.content ?? '',
        style: TextStyle(color: Colors.white),
      ),
    );
  }
}
