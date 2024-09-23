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
      child: Container(
        color: Color.fromRGBO(45, 45, 45, 1),
        padding: MediaQuery.of(context).viewInsets, // Adjust for keyboard
        child: Row(
          children: [
            SizedBox(width: 14, height: 60,),
            const Icon(
              IconData(0xef53, fontFamily: 'MaterialIcons'),
              size: 30,
              color: Color.fromARGB(255, 160, 160, 160),
            ),
            Expanded(
              child: Container(
                color: Color.fromRGBO(45, 45, 45, 1),
                child: TextField(
                  controller: taskState.taskController,
                  onSubmitted: (value) {
                    mainState.addTask(taskState.taskController.text);
                    taskState.taskController.clear();
                  },
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
          ],
        ),
      ),
    );
  }
}
