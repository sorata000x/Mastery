import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skillborn/main_state.dart';
import 'package:skillborn/services/models.dart';

class SkillDeletionDialog extends StatelessWidget {
  final Skill skill;

  const SkillDeletionDialog({super.key, required this.skill});

  @override
  Widget build(BuildContext context) {
    final mainState = Provider.of<MainState>(context);

    return AlertDialog(
      title: const Text('Delete Skill'),
      content: Text('Are you sure you want to delete "${skill.name}"?'),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(), // Cancel deletion
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            // Delete the skill from Firestore
            mainState.removeSkill(skill);
            Navigator.of(context).pop(); // Close the dialog
            // Optionally, show a snackbar notification
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Skill "${skill.name}" deleted')),
            );
          },
          child: const Text('Delete'),
        ),
      ],
    );
  }
}
