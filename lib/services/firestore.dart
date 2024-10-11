import 'dart:core';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:skillborn/services/models.dart';
import 'package:uuid/uuid.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  String? user = FirebaseAuth.instance.currentUser?.uid;

  FirestoreService() {
    // Update user whenever user changes
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

  Future<List<Map<String, dynamic>>> getFunctions() async {
    var ref = _db.collection('functions'); // User collection
    var snapshot = await ref.get();
    var data = snapshot.docs.map((s) => s.data());
    var functions = data
        .map((d) => {
              "name": d["function"]["name"],
              "parameters": d["function"]["parameters"]
            })
        .toList();
    return functions;
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
          'note': task.note,
          'skills': task.skills,
          'index': task.index,
          'isCompleted': !task.isCompleted,
        })
        .then((value) => print("Task Set"))
        .catchError((error) => print("Failed to set task: $error"));
  }

  Future setTaskInFirestore(String id, String title, String note,
      List<String> skills, int index, bool completed) {
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
          'note': note,
          'skills': skills,
          'index': index,
          'isCompleted': completed,
        })
        .then((value) => print("User Set"))
        .catchError((error) => print("Failed to set user: $error"));
  }

  Future setTasks(List<Task> newTasks) async {
    CollectionReference tasks = _db
        .collection('users') // User collection
        .doc(user) // Specific user document
        .collection('tasks'); // Tasks subcollection
    try {
      // Replace all tasks with new tasks
      for (var task in newTasks) {
        await tasks
            .doc(task.id)
            .set({
              'id': task.id,
              'title': task.title,
              'note': task.note,
              'skills': task.skills,
              'index': task.index,
              'isCompleted': task.isCompleted,
            })
            .then((value) => print("Task Set"))
            .catchError((error) => print("Failed to set task: $error"));
      }
      print("Tasks collection successfully replaced.");
    } catch (e) {
      print("Error replacing tasks collection: $e");
    }
  }

  Future toggleTask(Task task) {
    return setTaskInFirestore(
      task.id,
      task.title,
      task.note,
      task.skills!,
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
          'note': newTask.note,
          'skills': newTask.skills,
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
          'description': skill.description,
          'index': skill.index,
          'exp': skill.exp,
          'level': skill.level,
          'type': skill.type,
        })
        .then((value) => print("Task Set"))
        .catchError((error) => print("Failed to set task: $error"));
  }

  Future setSkillInFirestore(String id, int index, String title,
      String description, int exp, int level, String type) {
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
          'description': description,
          'exp': exp,
          'level': level,
          'type': type
        })
        .then((value) => print("User Set"))
        .catchError((error) => print("Failed to set user: $error"));
  }

  Future setSkills(List<Skill> newSkills) async {
    CollectionReference skills = _db
        .collection('users') // User collection
        .doc(user) // Specific user document
        .collection('skills'); // Skills subcollection
    try {
      // Replace all skills with new skills
      for (var skill in newSkills) {
        await skills
            .doc(skill.id)
            .set({
              'id': skill.id,
              'index': skill.index,
              'title': skill.title,
              'description': skill.description,
              'exp': skill.exp,
              'level': skill.level,
              'type': skill.type
            })
            .then((value) => print("Skill Set"))
            .catchError((error) => print("Failed to set skill: $error"));
      }
      print("Skills collection successfully replaced.");
    } catch (e) {
      print("Error replacing skills collection: $e");
    }
  }

  Future addSkillToFirestore(String title, String type) {
    CollectionReference skills = _db
        .collection('users') // User collection
        .doc(user) // Specific user document
        .collection('skills'); // Skills subcollection
    var id = const Uuid().v4();

    return skills
        .doc(id)
        .set({
          'id': id,
          'index': 0,
          'title': title,
          'description': '',
          'exp': 0,
          'level': 1,
          'type': type
        })
        .then((value) => print("User Set"))
        .catchError((error) => print("Failed to set user: $error"));
  }

  // Created Skills

  Future<List<GlobalSkill>?> getCreatedSkills() async {
    var ref = _db
        .collection('users') // User collection
        .doc(user) // Specific user document
        .collection('created-skills'); // Tasks subcollection
    var snapshot = await ref.get();
    var data = snapshot.docs.map((s) => s.data());
    var createdSkills = data.map((d) => GlobalSkill.fromJson(d));
    return createdSkills.toList();
  }

  Future setCreatedSkills(GlobalSkill createdSkill) {
    CollectionReference createdSkills = _db
        .collection('users') // User collection
        .doc(user) // Specific user document
        .collection('created-skills'); // Tasks subcollection

    // Set data with a custom ID
    return createdSkills
        .doc(createdSkill.id)
        .set({
          'id': createdSkill.id,
          'title': createdSkill.title,
          'description': createdSkill.description,
          'effect': createdSkill.effect,
          'cultivation': createdSkill.cultivation,
          'type': createdSkill.type,
          'category': createdSkill.category,
          'author': createdSkill.author,
          'rank': createdSkill.rank,
        })
        .then((value) => print("Created Skills Set"))
        .catchError((error) => print("Failed to set created skill: $error"));
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

  // Global Skills

  Future<List<GlobalSkill>?> getGlobalSkills() async {
    var ref = _db.collection('global-skills');
    var snapshot = await ref.get();
    var data = snapshot.docs.map((s) => s.data());
    var globalSkillList = data.map((d) => GlobalSkill.fromJson(d));
    return globalSkillList.toList();
  }

  Future setGlobalSkills(GlobalSkill createdSkill) {
    CollectionReference globalSkills = _db.collection('global-skills');

    // Set data with a custom ID
    return globalSkills
        .doc(createdSkill.id)
        .set({
          'id': createdSkill.id,
          'title': createdSkill.title,
          'description': createdSkill.description,
          'effect': createdSkill.effect,
          'cultivation': createdSkill.cultivation,
          'type': createdSkill.type,
          'category': createdSkill.category,
          'author': createdSkill.author,
          'rank': createdSkill.rank,
        })
        .then((value) => print("Global Skills Set"))
        .catchError((error) => print("Failed to set global skill: $error"));
  }
}
