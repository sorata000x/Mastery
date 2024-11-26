import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skillborn/main_state.dart';
import 'package:skillborn/services/models.dart';
import 'package:skillborn/task/task_body/shared/task_card/task_card.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CompletedList extends StatelessWidget {
  final List<Task> completed;

  const CompletedList({super.key, required this.completed});

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<MainState>(context);

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
                  child: TaskCard(task: completed[index])
                );
              })
        ]);
  }
}
