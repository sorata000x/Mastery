import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:skillcraft/services/firestore.dart';
import 'package:skillcraft/services/models.dart';
import 'package:uuid/uuid.dart';

class MainState with ChangeNotifier {
  int _page = 0;
  List<Task> _tasks = [];
  List<Skill> _skills = [];
  String? _user;

  int get page => _page;
  List<Task> get tasks => _tasks;
  List<Skill> get skills => _skills;
  String? get user => _user;

  MainState() {
    initTask();
    initSkill();
    updateUser();
    FirebaseAuth.instance.authStateChanges().listen((User? currentUser) {
      _user = currentUser?.uid;
      notifyListeners();
    });
  }

  // User

  void updateUser() {
    _user = FirebaseAuth.instance.currentUser?.uid;
    notifyListeners();
  }

  // Page

  set page(int newValue) {
    _page = newValue;
    notifyListeners();
  }

  // Task

  void initTask() async {
    _tasks = await FirestoreService().getTasks();
    _tasks.sort((a, b) => a.index.compareTo(b.index));
    notifyListeners();
  }

  void addTask(String title) {
    final newTask = Task(
      id: const Uuid().v4(),
      title: title,
      index: _tasks.length,
      isCompleted: false,
    );
    _tasks.add(newTask);
    FirestoreService().addTaskToFirestore(newTask);
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

  void reorderTask(oldIndex, newIndex) {
    if (newIndex > oldIndex) {
      newIndex -= 1;
    }
    final Task task = _tasks.removeAt(oldIndex);
    task.index = newIndex;
    _tasks.insert(newIndex, task);
    FirestoreService().setTask(task);
    notifyListeners();
  }

  // Skill

  void initSkill() async {
    _skills = await FirestoreService().getSkills();
    notifyListeners();
  }

  set skills(List<Skill> newValue) {
    _skills = newValue;
    notifyListeners();
  }

  void setSkill(String id, int index, String title, int exp, int level, String type) {
    var newSkill = Skill(
      id: id,
      title: title,
      index: index,
      exp: exp,
      level: level,
      type: type,
    );
    for (var skill in skills) {
      if (skill.id == id) skill = newSkill;
    }
    FirestoreService().setSkillInFirestore(id, index, title, exp, level, type);
    notifyListeners();
  }

  void levelUpSkill(Skill target, int gain) {
    int cap = (100 * (target.level ^ 2)).toInt();
    int exp = (target.exp + gain);
    var level = target.level + (exp ~/ cap);
    exp = exp % cap;
    var newSkill = Skill(
      id: target.id,
      title: target.title,
      exp: exp,
      level: level,
    );
    for (var skill in skills) {
      if (skill.id == target.id) {
        skill.exp = newSkill.exp;
        skill.level = newSkill.level;
      }
    }
    FirestoreService().setSkillInFirestore(newSkill.id, newSkill.index, newSkill.title,
        newSkill.exp, newSkill.level, newSkill.type);
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

  void addSkill(String title, int gain, String type) {
    var cap = 100;
    var exp = gain;
    var level = 1 + (exp ~/ cap);
    exp = exp % cap;
    final newSkill = Skill(
        id: const Uuid().v4(),
        title: title,
        exp: exp,
        level: level,
        type: type);
    _skills.add(newSkill);
    FirestoreService().addSkillToFirestore(title, type);
    notifyListeners();
  }

  void reorderSkill(oldIndex, newIndex) {
    if (newIndex > oldIndex) {
      newIndex -= 1;
    }
    final Skill skill = _skills.removeAt(oldIndex);
    skill.index = newIndex;
    _skills.insert(newIndex, skill);
    FirestoreService().setSkill(skill);
    notifyListeners();
  }
}
