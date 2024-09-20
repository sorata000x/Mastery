import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skillcraft/main_state.dart';
import 'package:skillcraft/services/models.dart';
import 'package:skillcraft/task/task_section/shared/task_card.dart';
import 'package:skillcraft/task/task_state.dart';
import 'package:skillcraft/todo/todo_list/task_section/components/task_evaluration_card.dart';

class TodoList extends StatelessWidget {
  const TodoList({super.key});

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<TaskState>(context);
    var todos = state.tasks.where((task) => !task.isCompleted).toList();

    return Flexible(
      child: ReorderableListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: todos.length,
          onReorder: state.reorderTask,
          itemBuilder: (context, index) {
            return Expanded(
                key: ValueKey(todos[index].id),
                child: Column(
                  children: [
                    state.evaluatingTasks.contains(todos[index].id)
                        ? TaskEvalurationCard()
                        : TaskCard(task: todos[index]),
                    const Divider(
                      // This creates a horizontal line between tasks
                      height: 5,
                      thickness: 5,
                      color: Colors.transparent,
                    ),
                  ],
                ));
          }),
    );
  }
}