import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skillborn/main_state.dart';
import 'package:skillborn/services/models.dart';
import 'package:skillborn/task/task_section/add_task/add_task_button.dart';
import 'package:skillborn/task/task_section/completed_list/completed_list.dart';
import 'package:skillborn/task/task_section/todo_list/todo_list.dart';

class TaskSection extends StatefulWidget {
  const TaskSection({super.key});

  @override
  State<TaskSection> createState() => _TaskSectionState();
}

class _TaskSectionState extends State<TaskSection> {
  @override
  Widget build(BuildContext context) {
    final state = Provider.of<MainState>(context);
    return Column(
      children: [
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(15),
            children: [
              SizedBox(height: 4),
              TextField(
                autofocus: false,
                controller: state.listTitleController,
                style: TextStyle(
                  fontSize: 22, // Set the text size here
                ),
                decoration: InputDecoration(
                  hintText: state.selectedList!.title == ''
                      ? 'Untitled'
                      : '',
                  hintStyle: TextStyle(
                    color: const Color.fromARGB(255, 140, 140, 140),
                  ),
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                  ),
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
                onChanged: (value) {
                  state.setList(TaskList(
                    id: state.selectedList!.id,
                    index: state.selectedList!.index,
                    title: state.listTitleController.text,
                  ));
                },
              ),
              TodoList(
                  todos: state.tasks
                      .where((task) =>
                          task.list == state.selectedList!.id &&
                          !task.isCompleted)
                      .toList()),
              CompletedList(
                  completed: state.tasks
                      .where((task) =>
                          task.list == state.selectedList!.id &&
                          task.isCompleted)
                      .toList()),
            ],
          ),
        ),
        const AddTaskButton(), // Display add task button or input field at the bottom
      ],
    );
  }
}
