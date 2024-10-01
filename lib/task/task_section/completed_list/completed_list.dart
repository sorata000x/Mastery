import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skillborn/main_state.dart';
import 'package:skillborn/task/task_section/shared/task_card/task_card.dart';
import 'package:skillborn/task/task_section/shared/task_evaluration_card.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CompletedList extends StatelessWidget {
  const CompletedList({super.key});

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<MainState>(context);
    var completed =
        state.tasks.where((task) => task.isCompleted == true).toList();

    return ExpansionTile(
        title: Text(
          AppLocalizations.of(context)!.completed,
          style: const TextStyle(fontSize: 14, color: Colors.grey),
        ),
        initiallyExpanded: true,
        collapsedShape: const RoundedRectangleBorder(
          side:
              BorderSide(color: Colors.transparent), // No border when collapsed
        ),
        shape: const RoundedRectangleBorder(
          side:
              BorderSide(color: Colors.transparent), // No border when expanded
        ),
        children: [
          ReorderableListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: completed.length,
              onReorder: (oldIndex, newIndex) {
                if (newIndex > oldIndex) {
                  newIndex -= 1;
                }
                state.reorderTask(
                    completed[oldIndex].index, completed[newIndex].index);
              },
              itemBuilder: (context, index) {
                return Container(
                  key: ValueKey(completed[index].id),
                  padding: const EdgeInsets.symmetric(vertical: 2.0),
                  child: state.evaluatingTasks.contains(completed[index].id)
                      ? const TaskEvalurationCard()
                      : TaskCard(task: completed[index]),
                );
              })
        ]);
  }
}
