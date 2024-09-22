import 'package:flutter/material.dart';
import 'package:skillborn/task/task_section/add_task/add_task_button.dart';
import 'package:skillborn/task/task_section/completed_list/completed_list.dart';
import 'package:skillborn/task/task_section/todo_list/todo_list.dart';

class TaskSection extends StatelessWidget {
  const TaskSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: const Icon(Icons.person_add),
            onPressed: () {
              // Add action for the button
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(15),
              children: const [
                SizedBox(height: 16),
                TodoList(),
                SizedBox(height: 0),
                CompletedList(),
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.fromLTRB(16.0, 0, 16.0, 0),
            child: AddTaskButton()), // Display add task button or input field at the bottom
            ],
      ),
    );
  }
}