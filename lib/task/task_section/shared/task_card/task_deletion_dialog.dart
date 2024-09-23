import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skillborn/main_state.dart';
import 'package:skillborn/services/models.dart';

class TaskDeletionDialog extends StatelessWidget {
  final Task task;

  const TaskDeletionDialog({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    final mainState = Provider.of<MainState>(context);

    return AlertDialog(
      title: const Text('Delete Task'),
      content: Text('Are you sure you want to delete "${task.title}"?'),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(), // Cancel deletion
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            // Delete the task from Firestore
            mainState.removeTask(task);
            Navigator.of(context).pop(); // Close the dialog
            // Optionally, show a snackbar notification
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Task "${task.title}" deleted')),
            );
          },
          child: const Text('Delete'),
        ),
      ],
    );
  }
}
