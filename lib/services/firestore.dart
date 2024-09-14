import 'dart:core';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:skillcraft/services/auth.dart';
import 'package:skillcraft/services/models.dart';
import 'package:rxdart/rxdart.dart';
import 'package:uuid/uuid.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Task

  Future<List<Task>> getTasks() async {
    var ref = _db.collection('tasks');
    var snapshot = await ref.get();
    var data = snapshot.docs.map((s) => s.data());
    var tasks = data.map((d) => Task.fromJson(d));
    return tasks.toList();
  }

  Future setTaskInFirestore(String id, String title, bool completed) {
    CollectionReference tasks = FirebaseFirestore.instance.collection('tasks');

    // Set data with a custom ID
    return tasks
        .doc(id)
        .set({
          'id': id,
          'title': title,
          'isCompleted': completed,
        })
        .then((value) => print("User Set"))
        .catchError((error) => print("Failed to set user: $error"));
  }

  Future toggleTask(Task task) {
    return setTaskInFirestore(
      task.id,
      task.title,
      !task.isCompleted,
    );
  }

  Future addTaskToFirestore(String title) {
    CollectionReference tasks = FirebaseFirestore.instance.collection('tasks');
    var id = const Uuid().v4();

    return tasks
        .doc(id)
        .set({
          'id': id,
          'title': title,
          'isCompleted': false,
        })
        .then((value) => print("User Set"))
        .catchError((error) => print("Failed to set user: $error"));
  }

  Future<void> deleteTaskFromFirestore(String taskId) async {
    await FirebaseFirestore.instance.collection('tasks').doc(taskId).delete();
  }

  // Skills

  Future<List<Skill>> getSkills() async {
    var ref = _db.collection('skills');
    var snapshot = await ref.get();
    var data = snapshot.docs.map((s) => s.data());
    var skills = data.map((d) => Skill.fromJson(d));
    return skills.toList();
  }

  Future<Skill?> getSkillByTitle(title) async {
    var ref = _db.collection('skills');
    var snapshot = await ref.get();
    var data = snapshot.docs.map((s) => s.data());
    var skills = data.map((d) => Skill.fromJson(d));
    for (var skill in skills) {
      if (skill.title == title) return skill;
    }
    return null;
  }

  Future setSkillInFirestore(String id, String title, int exp, int level) {
    CollectionReference skills =
        FirebaseFirestore.instance.collection('skills');

    // Set data with a custom ID
    return skills
        .doc(id)
        .set({'id': id, 'title': title, 'exp': exp, 'level': level})
        .then((value) => print("User Set"))
        .catchError((error) => print("Failed to set user: $error"));
  }

  Future addSkillToFirestore(String title) {
    CollectionReference skills =
        FirebaseFirestore.instance.collection('skills');
    var id = const Uuid().v4();

    return skills
        .doc(id)
        .set({'id': id, 'title': title, 'exp': 0, 'level': 1})
        .then((value) => print("User Set"))
        .catchError((error) => print("Failed to set user: $error"));
  }
}
