import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skillborn/main_state.dart';
import 'package:skillborn/services/models.dart';
import 'package:skillborn/task/task_body/shared/task_card/task_card.dart';
import 'package:skillborn/task/task_body/shared/task_evaluration_card.dart';

class TodoList extends StatelessWidget {
  final List<Task> todos;

  const TodoList({super.key, required this.todos});

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<MainState>(context);

    return ReorderableListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: todos.length,
        onReorder: (oldIndex, newIndex) {
          if (newIndex > oldIndex) {
            newIndex -= 1;
          }
          state.reorderTask(todos[oldIndex].index, todos[newIndex].index);
        },
        itemBuilder: (context, index) {
          return Container(
              padding: const EdgeInsets.symmetric(vertical: 2.0),
              key: ValueKey(todos[index].id),
              child: Column(
                children: [
                  state.evaluatingTasks.contains(todos[index].id)
                      ? const TaskEvalurationCard()
                      : TaskCard(task: todos[index]),
                ],
              ));
        });
  }
}
