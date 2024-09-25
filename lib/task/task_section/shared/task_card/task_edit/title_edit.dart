import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skillborn/main_state.dart';
import 'package:skillborn/services/models.dart';
import 'package:skillborn/task/task_state.dart';

class TitleEdit extends StatefulWidget {
  final Task task;

  const TitleEdit({super.key, required this.task});

  @override
  State<TitleEdit> createState() => _TitleEditState();
}

class _TitleEditState extends State<TitleEdit> {
  final TextEditingController _taskTitleController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _taskTitleController.text = widget.task.title;
  }

  @override
  Widget build(BuildContext context) {
    final mainState = Provider.of<MainState>(context);
    final taskState = Provider.of<TaskState>(context);

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 6, 6, 0),
      child: Row(
        children: [
          const Icon(
            IconData(0xef53, fontFamily: 'MaterialIcons'),
            size: 30,
            color: Color.fromARGB(255, 160, 160, 160),
          ),
          Expanded(
            child: TextField(
              controller: _taskTitleController,
              // Style
              maxLines: null,
              textInputAction: TextInputAction.done, 
              decoration: const InputDecoration(
                hintText: "Untitled",
                hintStyle: TextStyle(
                  color: Colors.grey,
                  fontSize: 18.0,
                ),
                border: InputBorder.none,
                filled: true,
              ),
              onChanged: (value) {
                taskState.setTitleEditText(value);
              },
            ),
          ),
        ],
      ),
    );
  }
}
