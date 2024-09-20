import 'dart:collection';
import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:skillcraft/api/api.dart';
import 'package:skillcraft/main_state.dart';
import 'package:skillcraft/services/firestore.dart';
import 'package:skillcraft/services/models.dart';
import 'package:skillcraft/shared/shared.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:skillcraft/task/system_messages/system_messages.dart';
import 'package:skillcraft/task/task_state.dart';
import 'package:skillcraft/todo/todo_list/task_section/task_section.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter_svg/flutter_svg.dart';

class TaskScreen extends StatefulWidget {
  const TaskScreen({super.key});

  @override
  State<TaskScreen> createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> {
  @override
  Widget build(BuildContext context) {
    final state = Provider.of<TaskState>(context);

    return GestureDetector(
        onTap: () {
          if (state.isAddingTask) {
            // Hide input field if tapped outside the input area
            setState(() {
              state.setIsAddingTask(false);
            });
          }
        },
        child: Stack(
          children: [
            TaskSection(),
            SystemMessages(),
          ],
        ));
  }
}
