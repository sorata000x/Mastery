import 'package:flutter/material.dart';
import 'package:skillborn/task/task_body/add_task/add_task_input.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AddTaskButton extends StatelessWidget {
  const AddTaskButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 10.0),
      color: Colors.black,
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: () {
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              builder: (BuildContext context) {
                return const AddTaskInput();
              });
          },
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.fromLTRB(14.0, 14.0, 14.0, 14.0),
            backgroundColor: Theme.of(context).colorScheme.primaryContainer,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Icon(Icons.add),
              const SizedBox(width: 8),
              Text(
                AppLocalizations.of(context)!.add_a_task,
                style: const TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
