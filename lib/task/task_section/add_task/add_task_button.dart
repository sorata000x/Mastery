import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skillborn/main_state.dart';
import 'package:skillborn/task/task_section/add_task/add_task_input.dart';
import 'package:skillborn/task/task_state.dart';

class AddTaskButton extends StatelessWidget {
  const AddTaskButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              builder: (BuildContext context) {
                return AddTaskInput();
              });
        },
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.fromLTRB(14.0, 14.0, 14.0, 14.0),
          backgroundColor: const Color.fromRGBO(48, 48, 48, 1),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
          ),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Icon(Icons.add),
            SizedBox(width: 11),
            Text(
              "Add a Task",
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
