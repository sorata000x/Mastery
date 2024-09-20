
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skillcraft/task/system_messages/system_messages.dart';
import 'package:skillcraft/task/task_section/task_section.dart';
import 'package:skillcraft/task/task_state.dart';

class TaskScreen extends StatefulWidget {
  const TaskScreen({super.key});

  @override
  State<TaskScreen> createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> {
  @override
  Widget build(BuildContext context) {
    final state = Provider.of<TaskState>(context);

    return GestureDetector(
        child: const Stack(
          children: [
            TaskSection(),
            SystemMessages(),
          ],
        ));
  }
}
