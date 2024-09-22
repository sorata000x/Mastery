import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skillborn/main_state.dart';
import 'package:skillborn/services/models.dart';
import 'package:skillborn/task/task_state.dart';

class TaskEdit extends StatefulWidget {
  final Task task;

  const TaskEdit({super.key, required this.task});

  @override
  State<TaskEdit> createState() => _TaskEditState();
}

class _TaskEditState extends State<TaskEdit> {
  TextEditingController _controller = TextEditingController();
  String taskTitle = '';

  @override
  void initState() {
    super.initState();
    _controller.text = widget.task.title;
  }

  @override
  Widget build(BuildContext context) {
    final mainState = Provider.of<MainState>(context);
    final taskState = Provider.of<TaskState>(context);

    return SingleChildScrollView(
      padding: MediaQuery.of(context).viewInsets, // Adjust for keyboard
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(6),
            color: Color.fromRGBO(45, 45, 45, 1),
            child: TextField(
              controller: _controller,
              autofocus: true, // Automatically focus the input when it appears
              decoration: const InputDecoration(
                hintText: "Untitled",
                border: InputBorder.none,
                filled: true,
                fillColor: Color.fromRGBO(45, 45, 45, 1),
              ),
              onChanged: (value) {
                mainState.setTask(widget.task.id, value, widget.task.index,
                    widget.task.isCompleted);
              },
              onSubmitted: (value) {
                Navigator.pop(context);
              },
            ),
          ),
        ],
      ),
    );
  }
}
