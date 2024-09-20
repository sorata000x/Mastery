import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skillcraft/task/task_section/add_task_button.dart';
import 'package:skillcraft/task/task_section/completed_list/completed_list.dart';
import 'package:skillcraft/task/task_section/task_input_field.dart';
import 'package:skillcraft/task/task_section/todo_list/todo_list.dart';
import 'package:skillcraft/task/task_state.dart';

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
              padding: const EdgeInsets.all(16),
              children: const [
                TodoList(),
                SizedBox(height: 20),
                CompletedList(),
              ],
            ),
          ),
          buildAddTaskButtonOrInput(context), // Display add task button or input field at the bottom
        ],
      ),
    );
  }

  // This function handles the display of the "Add a Task" button or the input field
  Widget buildAddTaskButtonOrInput(context) {
    final state = Provider.of<TaskState>(context);

    return Padding(
        padding: const EdgeInsets.fromLTRB(16.0, 0, 16.0, 4.0),
        child: state.isAddingTask
            ? const TaskInputField() // Show input field if the user clicked the "+ Add a Task" button
            : const AddTaskButton());
  }
}