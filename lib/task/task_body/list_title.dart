import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skillborn/main_state.dart';
import 'package:skillborn/services/models.dart';

class ListTitle extends StatelessWidget {
  const ListTitle({super.key});

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<MainState>(context);
    return TextField(
      autofocus: false,
      controller: state.listTitleController,
      style: TextStyle(
        fontSize: 22, // Set the text size here
      ),
      decoration: InputDecoration(
        hintText: 'Untitled',
        hintStyle: TextStyle(
          color: const Color.fromARGB(255, 140, 140, 140),
        ),
        border: OutlineInputBorder(
          borderSide: BorderSide.none,
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
      onChanged: (value) {
        state.setList(TaskList(
          id: state.selectedList!.id,
          index: state.selectedList!.index,
          title: state.listTitleController.text,
        ));
      },
    );
  }
}
