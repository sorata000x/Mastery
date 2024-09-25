import 'package:flutter/material.dart';
import 'package:skillborn/task/task_section/add_task/add_task_input.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AddTaskButton extends StatelessWidget {
  const AddTaskButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
            padding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 10.0),
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.8),  // Shadow color with opacity
                  spreadRadius: 2,  // Spread radius (makes the shadow bigger)
                  blurRadius: 5,  // Blur radius (makes the shadow softer)
                ),
              ],
            ),
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
            backgroundColor: const Color.fromRGBO(45, 45, 45, 1),
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
