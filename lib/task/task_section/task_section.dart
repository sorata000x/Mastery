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
                TodoList(),
                CompletedList(),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 10.0),
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.8),  // Shadow color with opacity
                  spreadRadius: 2,  // Spread radius (makes the shadow bigger)
                  blurRadius: 5,  // Blur radius (makes the shadow softer)
                ),
              ],
            ),
            child: const AddTaskButton()), // Display add task button or input field at the bottom
            ],
      ),
    );
  }
}