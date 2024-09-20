import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skillcraft/main_state.dart';
import 'package:skillcraft/task/task_state.dart';

class TaskInputField extends StatelessWidget {
  const TaskInputField({super.key});

  @override
  Widget build(BuildContext context) {
    final mainState = Provider.of<MainState>(context);
    final taskState = Provider.of<TaskState>(context);

    return SizedBox(
      height: 50,
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: taskState.taskController,
              autofocus: true, // Automatically focus the input when it appears
              decoration: InputDecoration(
                hintText: "Enter task name",
                filled: true,
                fillColor: const Color.fromRGBO(45, 45, 45, 1),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
              onTap: () {
                // Prevent hiding when tapping inside the input
              },
            ),
          ),
          IconButton(
            icon: const Icon(Icons.check, color: Colors.blue),
            onPressed: () {
              mainState.addTask(taskState.taskController.text);
              taskState.taskController.clear();
              taskState.setIsAddingTask(false);
            },
          ),
        ],
      ),
    );
  }
}
