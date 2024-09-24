import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skillborn/main_state.dart';
import 'package:skillborn/services/models.dart';
import 'package:skillborn/task/task_section/shared/task_card/task_edit/edit_task_note.dart';
import 'package:skillborn/task/task_section/shared/task_card/task_edit/edit_task_title.dart';
import 'package:skillborn/task/task_section/shared/task_card/task_edit/task_skills_list/task_skills_list.dart';

class TaskEdit extends StatefulWidget {
  final Task task;

  const TaskEdit({super.key, required this.task});

  @override
  State<TaskEdit> createState() => _TaskEditState();
}

class _TaskEditState extends State<TaskEdit> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      padding: MediaQuery.of(context).viewInsets, // Adjust for keyboard
      child: Column(
        children: [
          EditTaskTitle(task: widget.task),
          EditTaskNote(task: widget.task),
          TaskSkillsList(task: widget.task,)
        ],
      ),
    );
  }
}
