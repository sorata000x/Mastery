
import 'package:flutter/material.dart';
import 'package:skillborn/task/system_messages/system_messages.dart';
import 'package:skillborn/task/task_section/task_section.dart';

class TaskScreen extends StatefulWidget {
  const TaskScreen({super.key});

  @override
  State<TaskScreen> createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        child: const Stack(
          children: [
            TaskSection(),
            SystemMessages(),
          ],
        ));
  }
}
