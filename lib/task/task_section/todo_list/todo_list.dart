import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skillborn/main_state.dart';
import 'package:skillborn/task/task_section/shared/task_card/task_card.dart';
import 'package:skillborn/task/task_section/shared/task_evaluration_card.dart';
import 'package:skillborn/task/task_state.dart';

class TodoList extends StatelessWidget {
  const TodoList({super.key});

  @override
  Widget build(BuildContext context) {
    final mainState = Provider.of<MainState>(context);
    final taskState = Provider.of<TaskState>(context);
    var todos = mainState.tasks.where((task) => !task.isCompleted).toList();

    return ReorderableListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: todos.length,
        onReorder: mainState.reorderTask,
        itemBuilder: (context, index) {
          return Container(
              key: ValueKey(todos[index].id),
              child: Column(
                children: [
                  taskState.evaluatingTasks.contains(todos[index].id)
                      ? const TaskEvalurationCard()
                      : TaskCard(task: todos[index]),
                  const Divider(
                    // This creates a horizontal line between tasks
                    height: 4,
                    thickness: 4,
                    color: Colors.transparent,
                  ),
                ],
              ));
        });
  }
}
