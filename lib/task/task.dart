import 'package:flutter/material.dart';
import 'package:skillborn/task/task_body/task_body.dart';
import 'package:skillborn/task/task_drawer.dart';

class TaskScreen extends StatefulWidget {
  const TaskScreen({super.key});

  @override
  State<TaskScreen> createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        child: Stack(
      children: [
        Scaffold(
          appBar: AppBar(
              //actions: [
              //  IconButton(
              //    icon: const Icon(Icons.person_add),
              //    onPressed: () {
              //      // Add action for the button
              //    },
              //  ),
              //],
              ),
          drawer: TaskDrawer(),
          body: const TaskBody(),
        ),
      ],
    ));
  }
}
