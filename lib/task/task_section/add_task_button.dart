import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skillcraft/task/task_state.dart';

class AddTaskButton extends StatelessWidget {
  const AddTaskButton({super.key});

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<TaskState>(context);

    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: () {
          state.setIsAddingTask(true);
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
