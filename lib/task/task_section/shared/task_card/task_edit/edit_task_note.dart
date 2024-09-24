import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skillborn/main_state.dart';
import 'package:skillborn/services/models.dart';

class EditTaskNote extends StatefulWidget {
  final Task task;

  const EditTaskNote({super.key, required this.task});

  @override
  State<EditTaskNote> createState() => _EditTaskNoteState();
}

class _EditTaskNoteState extends State<EditTaskNote> {
  final TextEditingController _taskNoteController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _taskNoteController.text = widget.task.note;
  }

  @override
  Widget build(BuildContext context) {
    final mainState = Provider.of<MainState>(context);

    return Container(
      height: 300,
      padding: const EdgeInsets.fromLTRB(16, 0, 6, 6),
      color: const Color.fromRGBO(45, 45, 45, 1),
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Padding(
          padding: EdgeInsets.fromLTRB(2, 8.5, 2, 0),
          child: Icon(
            Icons.subject,
            size: 26,
            color: Color.fromARGB(255, 160, 160, 160),
          ),
        ),
        Expanded(
          child: TextField(
            controller: _taskNoteController,
            // Style
            style: const TextStyle(
              height: 1.4,
            ),
            decoration: const InputDecoration(
              hintText: "Note",
              hintStyle: TextStyle(
                color: Colors.grey,
                fontSize: 18.0,
              ),
              border: InputBorder.none,
              filled: true,
              fillColor: Color.fromRGBO(45, 45, 45, 1),
            ),
            // Multiline
            maxLines: null,
            keyboardType: TextInputType.multiline,
            // Event
            onChanged: (value) {
              mainState.setTask(widget.task.id, widget.task.title, value,
                  widget.task.index, widget.task.isCompleted);
            },
            onSubmitted: (value) {
              Navigator.pop(context);
            },
          ),
        ),
      ]),
    );
  }
}
