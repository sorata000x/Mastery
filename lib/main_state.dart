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
  Map<String, List<Map>> _taskSkillExps =
      {}; // List of task to skillId and exp pair
  List<Conversation> _conversations = [];
  // API: ChatGPT
  List<dynamic> _functions = []; // List of functions for function call
  // Task Page
  TaskList? _selectedList = TaskList(id: 'inbox', index: -1, title: 'inbox');
  TextEditingController _listTitleController = TextEditingController();
  final List<String> _evaluatingTasks =
      []; // List of tasks that are currently getting responses from api request
  TextEditingController taskController =
      TextEditingController(); // controller for adding task
  final Queue<String> _hintMessages = Queue();
  String _titleEditText = "";
  // Skill Page
  SkillPath _selectedPath = SkillPath(id: 'all', index: -1, title: 'All');
  TextEditingController _pathTitleController = TextEditingController();
  // Explore Page
  List<Skill> _globalSkills = [];
  // Chat (Assistant) Page
  Conversation? _currentConversation = null;

  int get page => _page;
  String? get user => _user;
  int get exp => _exp;
  int get karma => _karma;
  List<Task> get tasks => _tasks;
  List<TaskList> get lists => _lists;
  List<UserSkill> get skills => _skills;
  List<SkillPath> get paths => _paths;
  List<Skill> get createdSkills => _createdSkills;
  Map<String, List<Map>> get taskSkillExps => _taskSkillExps;
  List<Conversation> get conversations => _conversations;
  List<dynamic> get functions => _functions;
  TaskList? get selectedList => _selectedList;
  TextEditingController get listTitleController => _listTitleController;
  List<String> get evaluatingTasks => _evaluatingTasks;
  Queue<String> get hintMessages => _hintMessages;
  String get titleEditText => _titleEditText;
  SkillPath get selectedPath => _selectedPath;
  TextEditingController get pathTitleController => _pathTitleController;
  List<Skill> get globalSkills => _globalSkills;
  Conversation? get currentConversation => _currentConversation;

  MainState() {
    initTask();
    initLists();
    initSkill();
    initPaths();
    initCreatedSkills();
    initFunctions();
    initGlobalSkills();
    initConversations();
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
      path: path,
      description: description,
      type: type,
      category: category,
      author: author,
      rank: rank ?? 'Common',
      index: index,
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

  // User - Messages

  Message addMessage(String role, String context, String conversationId) {
    Message newMessage = Message(
        timeStamp: DateTime.now().toString(), role: role, content: context);
    List<Conversation> newConversations = conversations;
    for (var conversation in newConversations) {
      if (conversation.id == conversationId) {
        conversation.messages.add(newMessage.toJson());
        currentConversation = conversation;
      }
    }
    conversations = [...newConversations];
    FirestoreService().addMessage(conversationId, newMessage);
    notifyListeners();
    return newMessage;
  }

  // User - Conversation

  set conversations(List<Conversation> value) {
    _conversations = value;
    notifyListeners();
  }

  void initConversations() async {
    var data = await FirestoreService().getConversations();
    _conversations = data;
    if (data.isNotEmpty) {
      print("data: ${data[0].toJson()}");
      _currentConversation = data[0];
    }
    notifyListeners();
  }

  void setConversation(id,
      {String? timeStamp,
      String? title,
      String? agent,
      List<Map<String, String>>? agentQueue,
      List<Map<String, dynamic>>? messages}) {
    List<Conversation> newConversations = _conversations;
    for (var conversation in newConversations) {
      if (conversation.id == id) {
        conversation.timeStamp = timeStamp ?? conversation.timeStamp;
        conversation.title = title ?? conversation.title;
        conversation.agentQueue = agentQueue ?? conversation.agentQueue;
        conversation.messages = messages ?? conversation.messages;
        FirestoreService().setConversation(conversation);
      }
    }
    conversations = newConversations;
    notifyListeners();
  }

  Conversation addConversation(String title) {
    var id = Uuid().v4();
    Conversation conversation = Conversation(
        id: id,
        timeStamp: DateTime.now().toString(),
        title: title,
        messages: []);
    List<Conversation> newConversations = _conversations;
    newConversations.add(conversation);
    _conversations = [...newConversations];
    FirestoreService().setConversation(conversation);
    notifyListeners();
    return conversation;
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

  // System - Skill Page

  // System - Skill Page - Selected List

  void setSelectedPath(SkillPath path) {
    _selectedPath = path;
    notifyListeners();
  }

  // System - Chat Page - Conversation

  set currentConversation(Conversation? conversation) {
    _currentConversation = conversation;
    notifyListeners();
  }
}
