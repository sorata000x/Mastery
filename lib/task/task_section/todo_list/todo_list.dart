import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skillborn/main_state.dart';
import 'package:skillborn/task/task_section/shared/task_card/task_card.dart';
import 'package:skillborn/task/task_section/shared/task_evaluration_card.dart';

class TodoList extends StatelessWidget {
  const TodoList({super.key});

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<MainState>(context);
    var todos = state.tasks.where((task) => !task.isCompleted).toList();

    return ReorderableListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: todos.length,
        onReorder: (oldIndex, newIndex) => state.reorderTask(todos[oldIndex].index, todos[newIndex].index),
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
