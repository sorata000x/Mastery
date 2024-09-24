import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skillborn/main_state.dart';
import 'package:skillborn/task/task_state.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AddTaskInput extends StatelessWidget {
  const AddTaskInput({super.key});

  @override
  Widget build(BuildContext context) {
    final mainState = Provider.of<MainState>(context);
    final taskState = Provider.of<TaskState>(context);

    return SingleChildScrollView(
      child: Container(
        color: const Color.fromRGBO(45, 45, 45, 1),
        padding: MediaQuery.of(context).viewInsets, // Adjust for keyboard
        child: Row(
          children: [
            const SizedBox(
              width: 14,
              height: 60,
            ),
            const Icon(
              IconData(0xef53, fontFamily: 'MaterialIcons'),
              size: 30,
              color: Color.fromARGB(255, 160, 160, 160),
            ),
            Expanded(
              child: Container(
                color: const Color.fromRGBO(45, 45, 45, 1),
                child: TextField(
                  controller: taskState.taskController,
                  onSubmitted: (value) {
                    if (value.isNotEmpty) {
                      // Add to tasks
                      var task = mainState.addTask(taskState.taskController.text);
                      taskState.taskController.clear();
                      // Evaluate and set task skills
                      mainState.genTaskSkills(task);
                    }
                  },
                  autofocus:
                      true, // Automatically focus the input when it appears
                  decoration: InputDecoration(
                    hintText: AppLocalizations.of(context)!.add_a_task,
                    hintStyle: const TextStyle(
                      color: Colors.grey,
                    ),
                    border: InputBorder.none,
                    filled: true,
                    fillColor: const Color.fromRGBO(45, 45, 45, 1),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
