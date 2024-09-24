import 'package:flutter/material.dart';
import 'package:skillborn/services/models.dart';

class TaskSkillsList extends StatelessWidget {
  final Task task;

  const TaskSkillsList({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    if (task.isEvaluating) {
      return Container(
        height: 100,
        child: Column(
          children: [
            Text('Evaluating'),
            Text('Evaluating'),
            Text('Evaluating'),
          ],
        ),
      );
    } else {
      return Container(
        height: 100,
        child: Column(
          children: task.skills.map((e) => Text(e['skill'])).toList(),
        ),
      );
    }
  }
}
