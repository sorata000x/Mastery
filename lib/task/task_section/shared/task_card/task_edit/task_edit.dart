import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skillborn/main_state.dart';
import 'package:skillborn/services/models.dart';
import 'package:skillborn/task/task_section/shared/task_card/task_edit/note_edit.dart';
import 'package:skillborn/task/task_section/shared/task_card/task_edit/skill_list/skills_list.dart';
import 'package:skillborn/task/task_section/shared/task_card/task_edit/title_edit.dart';
import 'package:skillborn/task/task_state.dart';

class TaskEdit extends StatefulWidget {
  final Task task;

  const TaskEdit({super.key, required this.task});

  @override
  State<TaskEdit> createState() => _TaskEditState();
}

class _TaskEditState extends State<TaskEdit> {
  @override
  Widget build(BuildContext context) {
    final mainState = Provider.of<MainState>(context);
    final taskState = Provider.of<TaskState>(context);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
            if (taskState.titleEditText != "") {
              mainState.setTask(
                  widget.task.id,
                  taskState.titleEditText,
                  widget.task.note,
                  widget.task.skills!,
                  widget.task.index,
                  widget.task.isCompleted);
            }
          },
        ),
      ),
      body: Container(
        child: SingleChildScrollView(
          child: Column(
            children: [
              TitleEdit(task: widget.task),
              NoteEdit(task: widget.task),
              SkillsList(task: widget.task),
            ],
          ),
        ),
      ),
    );
  }
}
