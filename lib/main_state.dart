import 'package:flutter/material.dart';
import 'package:skillcraft/services/firestore.dart';
import 'package:skillcraft/services/models.dart';
import 'package:uuid/uuid.dart';

class MainState with ChangeNotifier {
  int _page = 0;
  List<Task> _tasks = [];
  List<Skill> _skills = [];

  int get page => _page;
  List<Task> get tasks => _tasks;
  List<Skill> get skills => _skills;

  MainState() {
    initTask();
    initSkill();
  }

  // Init

  void initTask() async {
    _tasks = await FirestoreService().getTasks();
    notifyListeners();
  }

  void initSkill() async {
    _skills = await FirestoreService().getSkills();
    notifyListeners();
  }

  // Set

  set page(int newValue) {
    _page = newValue;
    notifyListeners();
  }

  set tasks(List<Task> newValue) {
    _tasks = newValue;
    notifyListeners();
  }

  set skills(List<Skill> newValue) {
    _skills = newValue;
    notifyListeners();
  }

  void setSkill(String id, String title, int exp, int level) {
    var newSkill = Skill(
      id: id,
      title: title,
      exp: exp,
      level: level,
    );
    for (var skill in skills) {
      if (skill.id == id) skill = newSkill;
    }
    FirestoreService().setSkillInFirestore(id, title, exp, level);
    notifyListeners();
  }

  void levelUpSkill(Skill target, int gain) {
    int cap = (100 * (target.level ^ 2)).toInt();
    var exp = (target.exp + gain);
    var level = target.level + (exp ~/ cap);
    exp = exp % cap;
    var newSkill = Skill(
      id: target.id,
      title: target.title,
      exp: exp,
      level: level,
    );
    for (var skill in skills) {
      if (skill.id == target.id) skill = newSkill;
    }
    FirestoreService().setSkillInFirestore(target.id, target.title, exp, level);
    notifyListeners();
  }

  Skill? getSkillByTitle(title) {
    for (var skill in skills) {
      if (skill.title == title) return skill;
    }
    return null;
  }

  bool containSkillTitle(title) {
    for (var skill in skills) {
      if (skill.title == title) return true;
    }
    return false;
  }

  void addTask(String title) {
    final newTask = Task(
      id: Uuid().v4(),
      title: title,
      isCompleted: false,
    );
    _tasks.add(newTask);
    FirestoreService().addTaskToFirestore(title);
    notifyListeners();
  }

  void addSkill(String title, int gain) {
    var cap = 100;
    var exp = gain;
    var level = 1 + (exp ~/ cap);
    exp = exp % cap;
    final newSkill =
        Skill(id: const Uuid().v4(), title: title, exp: exp, level: level);
    _skills.add(newSkill);
    FirestoreService().addSkillToFirestore(title);
    notifyListeners();
  }

  void toggleTask(Task target) {
    // Set local
    Task? task = tasks.firstWhere((task) => task.id == target.id);
    task.isCompleted = !task.isCompleted;
    // Set firestore
    FirestoreService().setTask(task);
    notifyListeners();
  }

  void removeTask(task) {
    tasks.remove(task);
    FirestoreService().deleteTaskFromFirestore(task.id);
    notifyListeners();
  }
}
