import 'dart:collection';

import 'package:flutter/material.dart';

class TaskState extends ChangeNotifier {
  final List<String> _evaluatingTasks =
      []; // List of tasks that are currently getting responses from
  TextEditingController taskController = TextEditingController();
  final Queue<String> _hintMessages = Queue();
  String _titleEditText = "";

  List<String> get evaluatingTasks => _evaluatingTasks;
  Queue<String> get hintMessages => _hintMessages;
  String get titleEditText => _titleEditText;

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
    Future.delayed(const Duration(seconds: 3), () {
      _hintMessages.remove(message);
      notifyListeners();
    });
  }

  void setTitleEditText(value) {
    _titleEditText = value;
    notifyListeners();
  }
}
