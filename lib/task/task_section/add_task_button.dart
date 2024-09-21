import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skillborn/main_state.dart';
import 'package:skillborn/task/task_state.dart';

class AddTaskButton extends StatelessWidget {
  const AddTaskButton({super.key});

  @override
  Widget build(BuildContext context) {
    final mainState = Provider.of<MainState>(context);
    final taskState = Provider.of<TaskState>(context);

    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: () {
          showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              builder: (BuildContext context) {
                return SingleChildScrollView(
                  child: Padding(
                    padding: MediaQuery.of(context).viewInsets, // Adjust for keyboard
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: taskState.taskController,
                            autofocus:
                                true, // Automatically focus the input when it appears
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
                          },
                        ),
                      ],
                    ),
                  ),
                );
              });
        },
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 14),
          backgroundColor: const Color.fromRGBO(45, 45, 45, 1),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
          ),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Icon(Icons.add),
            SizedBox(width: 11),
            Text("Add a Task"),
          ],
        ),
      ),
    );
  }
}
