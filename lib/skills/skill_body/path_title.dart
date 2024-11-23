import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skillborn/main_state.dart';
import 'package:skillborn/services/models.dart';

class PathTitle extends StatelessWidget {
  const PathTitle({super.key});

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<MainState>(context);
    
    return TextField(
      autofocus: false,
      controller: state.pathTitleController,
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
        state.setPath(SkillPath(
          id: state.selectedPath!.id,
          index: state.selectedPath!.index,
          title: state.pathTitleController.text,
        ));
      },
    );
  }
}
