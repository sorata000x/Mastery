import 'dart:collection';
import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:skillborn/api/api.dart';
import 'package:skillborn/services/firestore.dart';
import 'package:skillborn/services/models.dart';
import 'package:uuid/uuid.dart';

class MainState with ChangeNotifier {
  int _page = 0; // Index to navigate between pages
  // USER
  String? _user; // user id
  int _exp = 0;
  int _karma = 0;
  List<Task> _tasks = []; // List of user tasks
  List<UserSkill> _skills = []; // List of user skills
  List<Skill> _createdSkills = []; // List of skills user created in Explore
  Map<String, List<Map>> _taskSkillExps =
      {}; // List of task to skillId and exp pair
  // API: ChatGPT
  List<dynamic> _functions = []; // List of functions for function call
  // Task Page
  final List<String> _evaluatingTasks =
      []; // List of tasks that are currently getting responses from api request
  TextEditingController taskController =
      TextEditingController(); // controller for adding task
  final Queue<String> _hintMessages = Queue();
  String _titleEditText = "";
  // Explore Page
  List<Skill> _globalSkills = [];

  int get page => _page;
  String? get user => _user;
  int get exp => _exp;
  int get karma => _karma;
  List<Task> get tasks => _tasks;
  List<UserSkill> get skills => _skills;
  List<Skill> get createdSkills => _createdSkills;
  Map<String, List<Map>> get taskSkillExps => _taskSkillExps;
  List<dynamic> get functions => _functions;
  List<String> get evaluatingTasks => _evaluatingTasks;
  Queue<String> get hintMessages => _hintMessages;
  String get titleEditText => _titleEditText;
  List<Skill> get globalSkills => _globalSkills;

  MainState() {
    initTask();
    initSkill();
    initCreatedSkills();
    initFunctions();
    initGlobalSkills();
    updateUser();
    FirebaseAuth.instance.authStateChanges().listen((User? currentUser) {
      _user = currentUser?.uid;
      notifyListeners();
    });
  }

  /* User */

  void updateUser() {
    _user = FirebaseAuth.instance.currentUser?.uid;
    notifyListeners();
  }

  // User - Exp

  void initExp() async {
    _exp = await FirestoreService().getExp();
    notifyListeners();
  }

  void setExp(int newExp) async {
    _exp = newExp;
    await FirestoreService().setExp(newExp);
    notifyListeners();
  }

  void addExp(int add) async {
    _exp += add;
    await FirestoreService().setExp(_exp + add);
    notifyListeners();
  }

  String getNextRank() {
    if (exp < 1000) {
      return "Novice";
    }
    if (exp < 10000) {
      return "Intermediate";
    }
    if (exp < 100000) {
      return "Professional";
    }
    if (exp < 1000000) {
      return "Expert";
    }
    return "Master";
  }

  String getRank() {
    if (exp < 1000) {
      return "Beginner";
    }
    if (exp < 10000) {
      return "Novice";
    }
    if (exp < 100000) {
      return "Intermediate";
    }
    if (exp < 1000000) {
      return "Professional";
    }
    if (exp < 10000000) {
      return "Expert";
    }
    return "Master";
  }

  int getMaxExp() {
    if (exp < 1000) {
      // Beginner
      return 1000 - exp;
    }
    if (exp < 10000) {
      // Novice
      return 10000 - exp;
    }
    if (exp < 100000) {
      // Intermediate
      return 100000 - exp;
    }
    if (exp < 1000000) {
      // Professional
      return 1000000 - exp;
    }
    if (exp < 10000000) {
      // Expert
      return 10000000 - exp;
    }
    // Master
    return 100000000 - exp;
  }

  int getMaxSkillsNum() {
    if (exp < 1000) {
      // Beginner
      return 5;
    }
    if (exp < 10000) {
      // Novice
      return 10;
    }
    if (exp < 100000) {
      // Intermediate
      return 15;
    }
    if (exp < 1000000) {
      // Professional
      return 20;
    }
    if (exp < 10000000) {
      // Expert
      return 25;
    }
    // Master
    return 30;
  }

  // User - Karma

  void initKarma() async {
    _karma = await FirestoreService().getKarma();
    notifyListeners();
  }

  void setKarma(int newKarma) async {
    _karma = newKarma;
    await FirestoreService().setKarma(newKarma);
    notifyListeners();
  }

  void addKarma(int add) async {
    _karma += add;
    await FirestoreService().setKarma(_karma + add);
    notifyListeners();
  }

  // User - Task

  void initTask() async {
    _tasks = await FirestoreService().getTasks();
    _tasks.sort((a, b) => a.index.compareTo(b.index));
    // Ensure reordering will work
    for (int i = 0; i < _tasks.length; i++) {
      _tasks[i].index = i;
    }
    notifyListeners();
  }

  void setTask(Task newTask) {
    for (var task in tasks) {
      if (task.id == newTask.id) {
        task.id = newTask.id;
        task.title = newTask.title;
        task.note = newTask.note;
        task.skillExps = newTask.skillExps;
        task.index = newTask.index;
        task.isCompleted = newTask.isCompleted;
      }
    }
    FirestoreService().setTask(newTask);
    notifyListeners();
  }

  void addTask(String title) async {
    final newTask = Task(
      id: const Uuid().v4(),
      title: title,
      note: '',
      skillExps: null,
      index: 0,
      isCompleted: false,
    );
    _tasks.insert(0, newTask);
    for (int i = 0; i < _tasks.length; i++) {
      _tasks[i].index = i;
    }
    FirestoreService().setTasks(_tasks);
    notifyListeners();
  }

  void removeTask(Task task) {
    tasks.remove(task);
    FirestoreService().deleteTask(task.id);
    notifyListeners();
  }

  void toggleTask(Task target) {
    Task? task = tasks.firstWhere((task) => task.id == target.id);
    // Set firestore
    FirestoreService().setTask(Task(
      id: target.id,
      title: target.title,
      note: target.note,
      skillExps: target.skillExps,
      index: target.index,
      isCompleted: !target.isCompleted,
    ));
    // Set local after firestore
    task.isCompleted = !target.isCompleted;

    notifyListeners();
  }

  void reorderTask(int oldIndex, int newIndex) {
    final Task task = _tasks.removeAt(oldIndex);
    _tasks.insert(newIndex, task);
    for (int i = 0; i < _tasks.length; i++) {
      _tasks[i].index = i;
    }
    FirestoreService().setTasks(_tasks);
    notifyListeners();
  }

  // User - Skill

  void initSkill() async {
    _skills = await FirestoreService().getSkills();
    // Ensure reordering will work
    for (int i = 0; i < _skills.length; i++) {
      _skills[i].index = i;
    }
    notifyListeners();
  }

  UserSkill? getSkillByName(String name) {
    for (var skill in skills) {
      if (skill.name == name) return skill;
    }
    return null;
  }

  set skills(List<UserSkill> newValue) {
    _skills = newValue;
    notifyListeners();
  }

  void setSkill(UserSkill newSkill) async {
    // Update state
    bool exist = false;
    for (var i = 0; i < skills.length; i++) {
      if (skills[i].id == newSkill.id) {
        skills[i] = newSkill;
        exist = true;
      }
    }
    // Add new skill if doesn't exist
    if (exist == false) {
      skills.add(newSkill);
    }
    // Update firestore
    FirestoreService().setSkill(newSkill);
    notifyListeners();
  }

  void levelUpSkill(UserSkill target, int gain) {
    int cap = (100 * (target.level * target.level)).toInt();
    int exp = (target.exp + gain);
    var level = target.level + (exp ~/ cap);
    exp = exp % cap;
    var newSkill = {
      ...target as Map,
      exp: exp,
      level: level,
    } as UserSkill;
    for (var skill in skills) {
      if (skill.id == target.id) {
        skill.exp = newSkill.exp;
        skill.level = newSkill.level;
      }
    }
    FirestoreService().setSkill(newSkill);
    notifyListeners();
  }

  void levelUpSkillById(String id, int gain) {
    UserSkill target = skills.firstWhere((s) => s.id == id);
    int cap = (100 * (target.level * target.level)).toInt();
    int exp = (target.exp + gain);
    var level = target.level + (exp ~/ cap);
    exp = exp % cap;
    target.exp = exp;
    target.level = level;
    for (var skill in skills) {
      if (skill.id == target.id) {
        skill.exp = exp;
        skill.level = level;
      }
    }
    FirestoreService().setSkill(target);
    notifyListeners();
  }

  bool containSkillName(String name) {
    for (var skill in skills) {
      if (skill.name == name) return true;
    }
    return false;
  }

  void reorderSkill(int oldIndex, int newIndex) {
    if (newIndex > oldIndex) {
      newIndex -= 1;
    }
    for (int i = 0; i < _skills.length; i++) {
      _skills[i].index = i;
    }
    final UserSkill skill = _skills.removeAt(oldIndex);
    _skills.insert(newIndex, skill);
    for (int i = 0; i < _skills.length; i++) {
      _skills[i].index = i;
    }
    FirestoreService().setSkills(_skills);
    notifyListeners();
  }

  // User - Created Skill

  void initCreatedSkills() async {
    _createdSkills = await FirestoreService().getCreatedSkills() ?? [];
    notifyListeners();
  }

  void addCreatedSkill(createdSkill) async {
    _createdSkills.add(createdSkill);
    FirestoreService().setCreatedSkills(createdSkill);
    notifyListeners();
  }

  void publishSkill(createdSkill) async {
    _globalSkills.add(createdSkill);
    FirestoreService().setGlobalSkill(createdSkill);
    notifyListeners();
  }

  /* Global */

  // Global - Skills

  void initGlobalSkills() async {
    _globalSkills = await FirestoreService().getGlobalSkills() ?? [];
    notifyListeners();
  }

  void setGlobalSkill(Skill newGlobalSkill) async {
    // Update state
    var exist = false;
    for (var i = 0; i < globalSkills.length; i++) {
      if (globalSkills[i].id == newGlobalSkill.id) {
        globalSkills[i] = newGlobalSkill;
        exist = true;
      }
    }
    if (exist == false) _globalSkills.add(newGlobalSkill);
    // Update firestore
    FirestoreService().setGlobalSkill(newGlobalSkill);
    notifyListeners();
  }

  // Global - Functions

  void initFunctions() async {
    _functions = await FirestoreService().getFunctions();
    notifyListeners();
  }

  /* System */

  // System - Page

  set page(int newValue) {
    _page = newValue;
    notifyListeners();
  }

  // System - Task Page

  // System - Task Page - Evaluating Task

  void addEvaluatingTask(String taskId) {
    _evaluatingTasks.add(taskId);
    notifyListeners();
  }

  void removeEvaluatingTask(String taskId) {
    _evaluatingTasks.remove(taskId);
    notifyListeners();
  }

  // System - Task Page - Hint Messages

  void addHintMessage(message) {
    if (_hintMessages.length == 3) _hintMessages.removeFirst();
    _hintMessages.add(message);
    notifyListeners();
    Future.delayed(const Duration(seconds: 3), () {
      _hintMessages.remove(message);
      notifyListeners();
    });
  }

  // System - Task Page - Title Edit Text

  void setTitleEditText(value) {
    _titleEditText = value;
    notifyListeners();
  }
}
