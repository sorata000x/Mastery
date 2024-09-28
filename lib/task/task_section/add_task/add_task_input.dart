import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skillborn/main_state.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AddTaskInput extends StatelessWidget {
  const AddTaskInput({super.key});

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<MainState>(context);

    return SingleChildScrollView(
      child: Container(
        color: const Color.fromRGBO(45, 45, 45, 1),
        padding: MediaQuery.of(context).viewInsets, // Adjust for keyboard
        child: Row(
          children: [
            const SizedBox(width: 14, height: 60,),
            const Icon(
              IconData(0xef53, fontFamily: 'MaterialIcons'),
              size: 30,
              color: Color.fromARGB(255, 160, 160, 160),
            ),
            Expanded(
              child: Container(
                color: const Color.fromRGBO(45, 45, 45, 1),
                child: TextField(
                  controller: state.taskController,
                  maxLines: null,
                  textInputAction: TextInputAction.done, 
                  onSubmitted: (value) {
                    state.addTask(state.taskController.text);
                    state.taskController.clear();
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
