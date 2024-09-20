import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skillcraft/task/system_messages/hint_card.dart';
import 'package:skillcraft/task/task_state.dart';

class SystemMessages extends StatelessWidget {
  const SystemMessages({super.key});

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<TaskState>(context);

    return Positioned(
        bottom: 56,
        width: MediaQuery.of(context).size.width,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: ClipRRect(
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(5.0), // Radius for bottom-left corner
              bottomRight:
                  Radius.circular(5.0), // Radius for bottom-right corner
            ),
            child: Column(
              children: state.hintMessages
                  .map((m) => Column(
                        children: [
                          HintCard(message: m),
                          const Divider(
                            height: 5,
                            thickness: 5,
                            color: Colors.transparent,
                          ),
                        ],
                      ))
                  .toList(),
            ),
          ),
        ));
  }
}