import 'dart:collection';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:skillborn/services/firestore.dart';
import 'package:skillborn/services/models.dart';
import 'package:uuid/uuid.dart';

class MainState with ChangeNotifier {
  int _page = 0; // Index to navigate between pages
  // USER
  List<Task> _tasks = []; // List of user tasks
  List<Skill> _skills = []; // List of user skills
  List<GlobalSkill> _createdSkills =
      []; // List of skills user created in Explore
  String? _user; // user id
  // API: ChatGPT
  List<Map<String, dynamic>> _functions =
      []; // List of functions for function call
  // Task Page
  final List<String> _evaluatingTasks =
      []; // List of tasks that are currently getting responses from api request
  TextEditingController taskController =
      TextEditingController(); // controller for adding task
  final Queue<String> _hintMessages = Queue();
  String _titleEditText = "";
  // Explore Page
  List<GlobalSkill> _globalSkills = [];

  int get page => _page;
  List<Task> get tasks => _tasks;
  List<Skill> get skills => _skills;
  List<GlobalSkill> get createdSkills => _createdSkills;
  String? get user => _user;
  List<Map<String, dynamic>> get functions => _functions;
  List<String> get evaluatingTasks => _evaluatingTasks;
  Queue<String> get hintMessages => _hintMessages;
  String get titleEditText => _titleEditText;
  List<GlobalSkill> get globalSkills => _globalSkills;

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

  // Functions

  void initFunctions() async {
    _functions = await FirestoreService().getFunctions();
    notifyListeners();
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
    // Ensure reordering will work
    for (int i = 0; i < _tasks.length; i++) {
      _tasks[i].index = i;
    }
    notifyListeners();
  }

  void addTask(String title) {
    final newTask = Task(
      id: const Uuid().v4(),
      title: title,
      note: '',
      skills: [],
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

  void setTask(String id, String title, String note, List<String> skills,
      int index, bool isCompleted) {
    for (var task in tasks) {
      if (task.id == id) {
        task.id = id;
        task.title = title;
        task.note = note;
        task.skills = skills;
        task.index = index;
        task.isCompleted = isCompleted;
      }
    }
    FirestoreService()
        .setTaskInFirestore(id, title, note, skills, index, isCompleted);
    notifyListeners();
  }

  void toggleTask(Task target) {
    Task? task = tasks.firstWhere((task) => task.id == target.id);
    // Set firestore
    FirestoreService().setTask(task);
    // Set local after firestore
    task.isCompleted = !task.isCompleted;
    notifyListeners();
  }

  void removeTask(task) {
    tasks.remove(task);
    FirestoreService().deleteTaskFromFirestore(task.id);
    notifyListeners();
  }

  void reorderTask(oldIndex, newIndex) {
    final Task task = _tasks.removeAt(oldIndex);
    _tasks.insert(newIndex, task);
    for (int i = 0; i < _tasks.length; i++) {
      _tasks[i].index = i;
    }
    FirestoreService().setTasks(_tasks);
    notifyListeners();
  }

  void addSkillToTask(taskId, skillId) {
    for (int i = 0; i < _tasks.length; i++) {
      if (_tasks[i].id == taskId) {
        _tasks[i].skills?.add(skillId);
        FirestoreService().setTask(_tasks[i]);
      }
    }
    notifyListeners();
  }

  // Skill

  void initSkill() async {
    _skills = await FirestoreService().getSkills();
    // Ensure reordering will work
    for (int i = 0; i < _skills.length; i++) {
      _skills[i].index = i;
    }
    notifyListeners();
  }

  set skills(List<Skill> newValue) {
    _skills = newValue;
    notifyListeners();
  }

  void setSkill(String id, int index, String title, String description, int exp,
      int level, String type) {
    var newSkill = Skill(
      id: id,
      index: index,
      title: title,
      description: description,
      effect: '',
      cultivation: '',
      type: type,
      category: '',
      author: 'Unknown',
      rank: 'Common',
      exp: exp,
      level: level,
    );
    for (var skill in skills) {
      if (skill.id == id) skill = newSkill;
    }
    FirestoreService()
        .setSkillInFirestore(id, index, title, description, exp, level, type);
    notifyListeners();
  }

  void levelUpSkill(Skill target, int gain) {
    int cap = (100 * (target.level * target.level)).toInt();
    int exp = (target.exp + gain);
    var level = target.level + (exp ~/ cap);
    exp = exp % cap;
    var newSkill = Skill(
      id: target.id,
      index: target.index,
      title: target.title,
      description: target.description,
      effect: target.effect,
      cultivation: target.cultivation,
      type: target.type,
      category: target.category,
      author: target.author,
      rank: target.rank,
      exp: exp,
      level: level,
    );
    for (var skill in skills) {
      if (skill.id == target.id) {
        skill.exp = newSkill.exp;
        skill.level = newSkill.level;
      }
    }
    FirestoreService().setSkillInFirestore(
        newSkill.id,
        newSkill.index,
        newSkill.title,
        newSkill.description,
        newSkill.exp,
        newSkill.level,
        newSkill.type);
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

  Skill addSkill(String title, String description, int gain, String type) {
    var cap = 100;
    var exp = gain;
    var level = 1 + (exp ~/ cap);
    exp = exp % cap;
    var id = const Uuid().v4();
    var index = 0;
    // TODO: fill new fields
    final newSkill = Skill(
      id: id,
      index: index,
      title: title,
      description: description,
      effect: '',
      cultivation: '',
      type: type,
      category: '',
      author: 'Unknown',
      rank: 'Common',
      exp: 0,
      level: 1,
    );
    _skills.insert(0, newSkill);
    for (int i = 0; i < _skills.length; i++) {
      _skills[i].index = i;
    }
    FirestoreService().setSkills(_skills);
    notifyListeners();
    return newSkill;
  }

  Skill? addSkillFromStore(skill) {
    var index = 0;
    if (_skills.any((s) => s.id == skill.id)) return null;
    final newSkill = Skill(
      id: skill.id,
      index: index,
      title: skill.title,
      description: skill.description,
      effect: skill.effect,
      cultivation: skill.cultivation,
      type: skill.type,
      category: skill.category,
      author: skill.author,
      rank: skill.rank,
      exp: 0,
      level: 1,
    );
    _skills.insert(0, newSkill);
    for (int i = 0; i < _skills.length; i++) {
      _skills[i].index = i;
    }
    FirestoreService().setSkills(_skills);
    notifyListeners();
    return newSkill;
  }

  void reorderSkill(oldIndex, newIndex) {
    if (newIndex > oldIndex) {
      newIndex -= 1;
    }
    for (int i = 0; i < _skills.length; i++) {
      _skills[i].index = i;
    }
    final Skill skill = _skills.removeAt(oldIndex);
    _skills.insert(newIndex, skill);
    for (int i = 0; i < _skills.length; i++) {
      _skills[i].index = i;
    }
    FirestoreService().setSkills(_skills);
    notifyListeners();
  }

  // Created Skill

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
    FirestoreService().setGlobalSkills(createdSkill);
    notifyListeners();
  }

  // Task Page

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

  void initGlobalSkills() async {
    _globalSkills = await FirestoreService().getGlobalSkills() ?? [];
    notifyListeners();
  }
}
