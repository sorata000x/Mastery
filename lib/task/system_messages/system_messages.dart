import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skillborn/task/system_messages/hint_card.dart';
import 'package:skillborn/task/task_state.dart';

class SystemMessages extends StatelessWidget {
  const SystemMessages({super.key});

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<TaskState>(context);

    return Positioned(
        bottom: 64,
        width: MediaQuery.of(context).size.width,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16.0, 10.0, 16.0, 0),
          child: ClipRRect(
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(5.0), // Radius for bottom-left corner
              bottomRight:
                  Radius.circular(5.0), // Radius for bottom-right corner
            ),
            child: Column(
              children: [
                const SizedBox(height: 10,),
                ...state.hintMessages
                  .map((m) => HintCard(message: m))
                  ],
            ),
          ),
        ));
  }
}