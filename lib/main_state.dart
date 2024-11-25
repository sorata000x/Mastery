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
  List<TaskList> _lists = [];
  List<UserSkill> _skills = []; // List of user skills
  List<SkillPath> _paths = [];
  List<Skill> _createdSkills = []; // List of skills user created in Explore
  List<Message> _conversation = [];
  List<Agent> _agentQueue = [];
  List<Option> _options = []; // Options to reply to assistant
  // API: ChatGPT
  List<dynamic> _functions = []; // List of functions for function call
  // Task Page
  TaskList? _selectedList = TaskList(id: 'inbox', index: -1, title: 'inbox');
  TextEditingController _listTitleController = TextEditingController();
  TextEditingController taskController =
      TextEditingController(); // controller for adding task
  String _titleEditText = "";
  // Skill Page
  SkillPath _selectedPath = SkillPath(id: 'all', index: -1, title: 'All');
  TextEditingController _pathTitleController = TextEditingController();
  // Explore Page
  List<Skill> _globalSkills = [];

  int get page => _page;
  String? get user => _user;
  int get exp => _exp;
  int get karma => _karma;
  List<Task> get tasks => _tasks;
  List<TaskList> get lists => _lists;
  List<UserSkill> get skills => _skills;
  List<SkillPath> get paths => _paths;
  List<Skill> get createdSkills => _createdSkills;
  List<Message> get conversation => _conversation;
  List<Agent> get agentQueue => _agentQueue;
  List<Option> get options => _options;
  List<dynamic> get functions => _functions;
  TaskList? get selectedList => _selectedList;
  TextEditingController get listTitleController => _listTitleController;
  String get titleEditText => _titleEditText;
  SkillPath get selectedPath => _selectedPath;
  TextEditingController get pathTitleController => _pathTitleController;
  List<Skill> get globalSkills => _globalSkills;

  MainState() {
    initKarma();
    initTask();
    initLists();
    initSkill();
    initPaths();
    initCreatedSkills();
    initFunctions();
    initGlobalSkills();
    initConversation();
    initAgentQueue();
    initOptions();
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

  void setTask(id, {title, list, note, skillExps, index, karma, isCompleted}) {
    for (var task in tasks) {
      if (task.id == id) {
        task.title = title ?? task.title;
        task.list = list ?? task.list;
        task.note = note ?? task.note;
        task.skillExps = skillExps ?? task.skillExps;
        task.index = index ?? task.index;
        task.isCompleted = isCompleted ?? task.isCompleted;
        FirestoreService().setTask(Task(
            id: task.id,
            title: task.title,
            list: task.list,
            note: task.note,
            skillExps: task.skillExps,
            karma: task.karma,
            index: task.index,
            isCompleted: task.isCompleted));
      }
    }
    notifyListeners();
  }

  void setTasks(List<Task> newTasks) {
    _tasks = newTasks;
    FirestoreService().setTasks(newTasks);
    notifyListeners();
  }

  void addTask(String listId, String title) async {
    final newTask = Task(
      id: const Uuid().v4(),
      title: title,
      list: listId,
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
      list: target.list,
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

  // User - List

  void initLists() async {
    var data = await FirestoreService().getLists();
    data.sort((a, b) => a.index.compareTo(b.index));
    _lists = [..._lists, ...data];
    _listTitleController.text = 'Inbox';
    notifyListeners();
  }

  void setList(TaskList newList) {
    for (var list in lists) {
      if (list.id == newList.id) {
        list.id = newList.id;
        list.title = newList.title;
        list.index = newList.index;
      }
    }
    FirestoreService().setList(newList);
    notifyListeners();
  }

  void addList() async {
    final newList =
        TaskList(id: const Uuid().v4(), title: '', index: lists.length);
    _lists.add(newList);
    for (int i = 0; i < _lists.length; i++) {
      _lists[i].index = i;
    }
    FirestoreService().setLists(_lists);
    notifyListeners();
  }

  void removeList(TaskList list) {
    lists.remove(list);
    FirestoreService().deleteList(list.id);
    notifyListeners();
  }

  void reorderList(int oldIndex, int newIndex) {
    final TaskList list = _lists.removeAt(oldIndex);
    _lists.insert(newIndex, list);
    for (int i = 0; i < _lists.length; i++) {
      _lists[i].index = i;
    }
    FirestoreService().setLists(_lists);
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

  void setSkill(id,
      {name,
      path,
      description,
      type,
      category,
      author,
      rank,
      index,
      exp,
      level}) async {
    // Update state
    bool exist = false;
    UserSkill newSkill = UserSkill(
      id: id,
      name: name ?? 'Unknown',
      path: path ?? '',
      description: description ?? '',
      type: type ?? 'other',
      category: category ?? '',
      author: author ?? 'Unknown',
      rank: rank ?? 'Common',
      index: index ?? 0,
      exp: exp ?? 0,
      level: level ?? 1,
    );

    for (var i = 0; i < skills.length; i++) {
      if (skills[i].id == id) {
        newSkill = UserSkill(
          id: id,
          name: name ?? skills[i].name,
          path: path ?? skills[i].path,
          description: description ?? skills[i].description,
          type: type ?? skills[i].type,
          category: category ?? skills[i].category,
          author: author ?? skills[i].author,
          rank: rank ?? skills[i].rank,
          index: index ?? skills[i].index,
          exp: exp ?? skills[i].exp,
          level: level ?? skills[i].level,
        );
        skills[i] = newSkill;
        exist = true;
      }
    }
    // Add new skill if doesn't exist
    if (exist == false) {
      _skills.insert(0, newSkill);
      for (int i = 0; i < _skills.length; i++) {
        _skills[i].index = i;
      }
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

  // User - Path

  void initPaths() async {
    var data = await FirestoreService().getPaths();
    data.sort((a, b) => a.index.compareTo(b.index));
    _paths = [..._paths, ...data];
    _pathTitleController.text = 'All';
    notifyListeners();
  }

  void setPath(SkillPath newPath) {
    for (var path in paths) {
      if (path.id == newPath.id) {
        path.id = newPath.id;
        path.title = newPath.title;
        path.index = newPath.index;
      }
    }
    FirestoreService().setPath(newPath);
    notifyListeners();
  }

  void addPath() async {
    final newPath =
        SkillPath(id: const Uuid().v4(), title: '', index: paths.length);
    _paths.add(newPath);
    for (int i = 0; i < _paths.length; i++) {
      _paths[i].index = i;
    }
    FirestoreService().setPaths(_paths);
    notifyListeners();
  }

  void removePath(SkillPath path) {
    paths.remove(path);
    FirestoreService().deletePath(path.id);
    notifyListeners();
  }

  void reorderPath(int oldIndex, int newIndex) {
    final SkillPath path = _paths.removeAt(oldIndex);
    _paths.insert(newIndex, path);
    for (int i = 0; i < _paths.length; i++) {
      _paths[i].index = i;
    }
    FirestoreService().setPaths(_paths);
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

  // User - Conversation

  void initConversation() async {
    var data = await FirestoreService().getConversation();
    print("conversation: ${conversation.toString()}");
    _conversation = data;
    notifyListeners();
  }

  Message addMessage(String role, String context) {
    Message newMessage = Message(
        timestamp: DateTime.now().toIso8601String(),
        role: role,
        content: context);
    conversation.add(newMessage);
    FirestoreService().setMessage(newMessage);
    notifyListeners();
    return newMessage;
  }

  // User - AgentQueue

  set agentQueue(List<Agent> value) {
    _agentQueue = value;
    notifyListeners();
  }

  void initAgentQueue() async {
    var data = await FirestoreService().getAgentQueue();
    _agentQueue = data;
    notifyListeners();
  }

  void setAgentQueue(List<Agent> newAgentQueue) {
    _agentQueue = newAgentQueue;
    FirestoreService().setAgentQueue(newAgentQueue);
    notifyListeners();
  }

  // User - Options

  set options(List<Option> value) {
    _options = value;
    notifyListeners();
  }

  void initOptions() async {
    var data = await FirestoreService().getOptions();
    _options = data;
    notifyListeners();
  }

  void setOptions(List<Option> newOptions) {
    _options = newOptions;
    FirestoreService().setOptions(newOptions);
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

  // System - Task Page - Selected List

  void setSelectedList(TaskList list) {
    _selectedList = list;
    notifyListeners();
  }

  // System - Task Page - Title Edit Text

  void setTitleEditText(value) {
    _titleEditText = value;
    notifyListeners();
  }

  // System - Skill Page

  // System - Skill Page - Selected List

  void setSelectedPath(SkillPath path) {
    _selectedPath = path;
    notifyListeners();
  }
}
