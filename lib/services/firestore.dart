import 'dart:core';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:skillcraft/services/models.dart';
import 'package:uuid/uuid.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  String? user = FirebaseAuth.instance.currentUser?.uid;

  FirestoreService() {
    FirebaseAuth.instance.authStateChanges().listen((User? currentUser) {
      user = currentUser?.uid;
    });
  }

  // User

  String? getUser() {
    return user;
  }

  void updateUser() {
    user = FirebaseAuth.instance.currentUser?.uid;
  }

  // Task

  Future<List<Task>> getTasks() async {
    var ref = _db
        .collection('users') // User collection
        .doc(user) // Specific user document
        .collection('tasks'); // Tasks subcollection
    var snapshot = await ref.get();
    var data = snapshot.docs.map((s) => s.data());
    var tasks = data.map((d) => Task.fromJson(d));
    return tasks.toList();
  }

  Future setTask(Task task) {
    CollectionReference tasks = _db
        .collection('users') // User collection
        .doc(user) // Specific user document
        .collection('tasks'); // Tasks subcollection

    // Set data with a custom ID
    return tasks
        .doc(task.id)
        .set({
          'id': task.id,
          'title': task.title,
          'index': task.index,
          'isCompleted': task.isCompleted,
        })
        .then((value) => print("Task Set"))
        .catchError((error) => print("Failed to set task: $error"));
  }

  Future setTaskInFirestore(
      String id, String title, int index, bool completed) {
    CollectionReference tasks = _db
        .collection('users') // User collection
        .doc(user) // Specific user document
        .collection('tasks'); // Tasks subcollection

    // Set data with a custom ID
    return tasks
        .doc(id)
        .set({
          'id': id,
          'title': title,
          'index': index,
          'isCompleted': completed,
        })
        .then((value) => print("User Set"))
        .catchError((error) => print("Failed to set user: $error"));
  }

  Future toggleTask(Task task) {
    return setTaskInFirestore(
      task.id,
      task.title,
      task.index,
      !task.isCompleted,
    );
  }

  Future addTaskToFirestore(Task newTask) {
    CollectionReference tasks = _db
        .collection('users') // User collection
        .doc(user) // Specific user document
        .collection('tasks'); // Tasks subcollection

    return tasks
        .doc(newTask.id)
        .set({
          'id': newTask.id,
          'title': newTask.title,
          'index': newTask.index,
          'isCompleted': newTask.isCompleted,
        })
        .then((value) => print("Task Set"))
        .catchError((error) => print("Failed to set task: $error"));
  }

  Future<void> deleteTaskFromFirestore(String taskId) async {
    CollectionReference tasks = _db
        .collection('users') // User collection
        .doc(user) // Specific user document
        .collection('tasks'); // Tasks subcollection
    await tasks.doc(taskId).delete();
  }

  // Skills

  Future<List<Skill>> getSkills() async {
    var ref = _db.collection('users').doc(user).collection('skills');
    var snapshot = await ref.get();
    var data = snapshot.docs.map((s) => s.data());
    var skills = data.map((d) => Skill.fromJson(d));
    return skills.toList();
  }

  Future setSkill(Skill skill) {
    CollectionReference skills = _db
        .collection('users') // User collection
        .doc(user) // Specific user document
        .collection('skills'); // Tasks subcollection

    // Set data with a custom ID
    return skills
        .doc(skill.id)
        .set({
          'id': skill.id,
          'title': skill.title,
          'index': skill.index,
          'exp': skill.exp,
          'level': skill.level,
          'type': skill.type,
        })
        .then((value) => print("Task Set"))
        .catchError((error) => print("Failed to set task: $error"));
  }

  Future setSkillInFirestore(
      String id, int index, String title, int exp, int level, String type) {
    CollectionReference skills = _db
        .collection('users') // User collection
        .doc(user) // Specific user document
        .collection('skills'); // Tasks subcollection

    // Set data with a custom ID
    return skills
        .doc(id)
        .set({
          'id': id,
          'index': index,
          'title': title,
          'exp': exp,
          'level': level,
          'type': type
        })
        .then((value) => print("User Set"))
        .catchError((error) => print("Failed to set user: $error"));
  }

  Future addSkillToFirestore(String title, String type) {
    CollectionReference skills = _db
        .collection('users') // User collection
        .doc(user) // Specific user document
        .collection('skills'); // Tasks subcollection
    var id = const Uuid().v4();

    return skills
        .doc(id)
        .set({'id': id, 'index': 0, 'title': title, 'exp': 0, 'level': 1, 'type': type})
        .then((value) => print("User Set"))
        .catchError((error) => print("Failed to set user: $error"));
  }

  // Task-Skills

  Future addTaskSkills(String taskTitle, List<Map<String, dynamic>> skills) {
    CollectionReference taskSkills = _db.collection('task-skills');

    return taskSkills
        .doc(taskTitle)
        .set({'title': taskTitle, 'skills': skills})
        .then((value) => print("Task-Skills Set"))
        .catchError((error) => print("Failed to set Task-Skills: $error"));
  }

  Future<List<Map<String, dynamic>>?> getSkillsFromTask(taskTitle) async {
    var ref = _db.collection('task-skills');
    var snapshot = await ref.get();
    var data = snapshot.docs.map((s) => s.data());
    var taskSkillsList = data.map((d) => TaskSkills.fromJson(d));
    taskSkillsList = taskSkillsList.toList();
    for (var ts in taskSkillsList) {
      if (ts.title == taskTitle) return ts.skills;
    }
    return null;
  }
}
