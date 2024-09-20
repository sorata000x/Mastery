import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skillcraft/main_state.dart';
import 'package:skillcraft/task/task_section/shared/task_card.dart';
import 'package:skillcraft/task/task_section/shared/task_evaluration_card.dart';
import 'package:skillcraft/task/task_state.dart';

class CompletedList extends StatelessWidget {

  const CompletedList({super.key});

  @override
  Widget build(BuildContext context) {
    final mainState = Provider.of<MainState>(context);
    final taskState = Provider.of<TaskState>(context);
    var completed =
        mainState.tasks.where((task) => task.isCompleted == true).toList();

    return ExpansionTile(
        title: const Text(
          'Completed',
          style: TextStyle(fontSize: 14, color: Colors.grey),
        ),
        initiallyExpanded: true,
        children: [
          ReorderableListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: completed.length,
              onReorder: mainState.reorderTask,
              itemBuilder: (context, index) {
                return Container(
                    key: ValueKey(completed[index].id),
                    child: Column(
                      children: [
                        taskState.evaluatingTasks.contains(completed[index].id)
                            ? const TaskEvalurationCard()
                            : TaskCard(task: completed[index]),
                        const Divider(
                          // This creates a horizontal line between tasks
                          height: 5,
                          thickness: 5,
                          color: Colors.transparent,
                        ),
                      ],
                    ));
              })
        ]);
  }
}
