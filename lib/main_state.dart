import 'package:flutter/material.dart';
import 'package:skillcraft/services/models.dart';
import 'package:uuid/uuid.dart';

class MainState with ChangeNotifier {
  int _page = 0;
  List<Task> _tasks = [];
  List<Skill> _skills = [];

  int get page => _page;
  List<Task> get tasks => _tasks;
  List<Skill> get skills => _skills;

  set page(int newValue) {
    _page = newValue;
    notifyListeners();
  }

  set tasks(List<Task> newValue) {
    _tasks = newValue;
    notifyListeners();
  }

  void addTask(String title) {
    final newTask = Task(
      id: Uuid().v4(),
      title: title,
      isCompleted: false,
    );
    _tasks.add(newTask);
  }
}
