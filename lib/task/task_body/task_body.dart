import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skillborn/main_state.dart';
import 'package:skillborn/services/models.dart';
import 'package:skillborn/task/task_body/add_task/add_task_button.dart';
import 'package:skillborn/task/task_body/completed_list/completed_list.dart';
import 'package:skillborn/task/task_body/list_title.dart';
import 'package:skillborn/task/task_body/todo_list/todo_list.dart';

class TaskBody extends StatefulWidget {
  const TaskBody({super.key});

  @override
  State<TaskBody> createState() => _TaskBodyState();
}

class _TaskBodyState extends State<TaskBody> {
  @override
  Widget build(BuildContext context) {
    final state = Provider.of<MainState>(context);
    return Column(
      children: [
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(15),
            children: [
              state.selectedList?.id != 'inbox' ? ListTitle() : SizedBox(),
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
