import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skillborn/main_state.dart';
import 'package:skillborn/services/models.dart';
import 'package:skillborn/task/task_state.dart';

class AddTaskInput extends StatelessWidget {
  const AddTaskInput({super.key});

  @override
  Widget build(BuildContext context) {
    final mainState = Provider.of<MainState>(context);
    final taskState = Provider.of<TaskState>(context);

    return SingleChildScrollView(
      child: Padding(
        padding: MediaQuery.of(context).viewInsets, // Adjust for keyboard
        child: Row(
          children: [
            Expanded(
              child: Container(
                padding: EdgeInsets.all(6),
                color: Color.fromRGBO(45, 45, 45, 1),
                child: TextField(
                  controller: taskState.taskController,
                  autofocus:
                      true, // Automatically focus the input when it appears
                  decoration: const InputDecoration(
                    hintText: "Enter task name",
                    border: InputBorder.none,
                    filled: true,
                    fillColor: Color.fromRGBO(45, 45, 45, 1),
                  ),
                ),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.check, color: Colors.blue),
              onPressed: () {
                mainState.addTask(taskState.taskController.text);
                taskState.taskController.clear();
              },
            ),
          ],
        ),
      ),
    );
  }
}
