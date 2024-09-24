import 'dart:collection';

import 'package:flutter/material.dart';

class TaskState extends ChangeNotifier {
  TextEditingController taskController = TextEditingController();
  final Queue<String> _hintMessages = Queue();

  Queue<String> get hintMessages => _hintMessages;

  

  void addHintMessage(message) {
    if (_hintMessages.length == 3) _hintMessages.removeFirst();
    _hintMessages.add(message);
    notifyListeners();
    Future.delayed(const Duration(seconds: 3), () {
      _hintMessages.remove(message);
      notifyListeners();
    });
  }
}
