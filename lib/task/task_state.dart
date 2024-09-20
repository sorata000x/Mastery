import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:skillcraft/main_state.dart';

class TaskState extends MainState {
  bool _isAddingTask = false; // Track if user is in 'Add Task' mode
  List<String> _evaluatingTasks =
      []; // List of tasks that are currently getting responses from
  TextEditingController taskController = TextEditingController();
  Queue<String> _hintMessages = Queue();

  bool get isAddingTask => _isAddingTask;
  List<String> get evaluatingTasks => _evaluatingTasks;
  Queue<String> get hintMessages => _hintMessages;

  void setIsAddingTask(value) {
    _isAddingTask = value;
    notifyListeners();
  }

  void addEvaluatingTask(String taskId) {
    _evaluatingTasks.add(taskId);
    notifyListeners();
  }

  void removeEvaluatingTask(String taskId) {
    _evaluatingTasks.remove(taskId);
    notifyListeners();
  }

  void addHintMessage(message) {
    if (_hintMessages.length == 3) _hintMessages.removeFirst();
    _hintMessages.add(message);
    notifyListeners();
    Future.delayed(Duration(seconds: 3), () {
      _hintMessages.remove(message);
      notifyListeners();
    });
  }
}
