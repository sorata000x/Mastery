import 'dart:collection';
import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:skillcraft/api/api.dart';
import 'package:skillcraft/main_state.dart';
import 'package:skillcraft/services/firestore.dart';
import 'package:skillcraft/services/models.dart';
import 'package:skillcraft/shared/shared.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ToDoScreen extends StatefulWidget {
  const ToDoScreen({super.key});

  @override
  State<ToDoScreen> createState() => _ToDoScreenState();
}

class _ToDoScreenState extends State<ToDoScreen> {
  bool isAddingTask = false; // Track if user is in 'Add Task' mode
  TextEditingController taskController = TextEditingController();
  List<String> evaluatingTasks =
      []; // List of tasks that are currently getting responses from

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<MainState>(context);

    return GestureDetector(
        onTap: () {
          if (isAddingTask) {
            // Hide input field if tapped outside the input area
            setState(() {
              isAddingTask = false;
            });
          }
        },
        child: Stack(
          children: [
            ToDoList(state.tasks),
            SystemMessages(),
          ],
        ));
  }

  Widget ToDoList(tasks) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("To Do"),
        actions: [
          IconButton(
            icon: const Icon(Icons.person_add),
            onPressed: () {
              // Add action for the button
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                buildToDoSection(tasks),
                const SizedBox(height: 20),
                buildCompletedSection(tasks),
              ],
            ),
          ),
          buildAddTaskButtonOrInput(), // Display add task button or input field at the bottom
        ],
      ),
    );
  }

  Widget buildToDoSection(tasks) {
    final state = Provider.of<MainState>(context);
    var todos = tasks.where((task) => !task.isCompleted).toList();
    return Flexible(
      child: ReorderableListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: todos.length,
          onReorder: state.reorderTask,
          itemBuilder: (context, index) {
            return Flexible(
                key: ValueKey(todos[index].id),
                child: Column(
                  children: [
                    evaluatingTasks.contains(todos[index].id)
                        ? taskEvaluatingCard()
                        : taskCard(todos[index]),
                    const Divider(
                      // This creates a horizontal line between tasks
                      height: 5,
                      thickness: 5,
                      color: Colors.transparent,
                    ),
                  ],
                ));
          }),
    );
  }

  Widget taskCard(task) {
    final state = Provider.of<MainState>(context);

    return Slidable(
      key: Key(task.id),
      endActionPane: ActionPane(
        motion: const DrawerMotion(),
        extentRatio: 0.15,
        children: [
          SlidableAction(
            onPressed: (context) {
              // Show a confirmation dialog
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text('Delete Task'),
                  content:
                      Text('Are you sure you want to delete "${task.title}"?'),
                  actions: [
                    TextButton(
                      onPressed: () =>
                          Navigator.of(context).pop(), // Cancel deletion
                      child: Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () {
                        // Delete the task from Firestore
                        state.removeTask(task);
                        Navigator.of(context).pop(); // Close the dialog
                        // Optionally, show a snackbar notification
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content: Text('Task "${task.title}" deleted')),
                        );

                        setState(() {}); // Refresh the UI
                      },
                      child: Text('Delete'),
                    ),
                  ],
                ),
              );
            },
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
            icon: Icons.delete,
            padding: EdgeInsets.all(0.0),
            borderRadius: BorderRadius.only(
              topRight:
                  Radius.circular(5.0), // Apply border radius to top right
              bottomRight:
                  Radius.circular(5.0), // Apply border radius to bottom right
            ),
          ),
        ],
      ),
      child: Container(
        decoration: BoxDecoration(
          color: Color.fromRGBO(45, 45, 45, 1), // Background color
          borderRadius: BorderRadius.circular(5), // Circular radius
        ),
        height: 52,
        alignment: Alignment.center,
        padding: const EdgeInsets.only(left: 2.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            IconButton(
                onPressed: () {
                  if (task.isCompleted == false) {
                    taskToSkills(task);
                  } else {
                    // Directly toggle tasks of no need to wait for response
                    setState(() {
                      state.toggleTask(task);
                    });
                  }
                },
                icon: task.isCompleted
                    ? const Icon(IconData(0xe159, fontFamily: 'MaterialIcons'))
                    : const Icon(
                        IconData(0xef53, fontFamily: 'MaterialIcons'))),
            Text(
              task.title,
              style: TextStyle(
                fontSize: 17,
                decoration:
                    task.isCompleted ? TextDecoration.lineThrough : null,
                color: task.isCompleted ? Colors.grey : null,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future taskToSkills(task) async {
    final state = Provider.of<MainState>(context, listen: false);
    var skills = await FirestoreService().getSkillsFromTask(task.title);

    /// Generate new skills from task title with OpenAI api
    Future<List<Map<String, dynamic>>?> generateSkillsFromTaskTitle(
        taskTitle) async {
      // Get skill as a string of List<Map<String, int>>
      var messages =
          getTaskCompletionMessages(FirestoreService().getSkills(), taskTitle);
      var result = await callChatGPT(state, messages, functions);
      if (result == null) return [];
      // Decode string to List<Map<String, dynamic>>
      List<Map<String, dynamic>> skills =
          List<Map<String, dynamic>>.from(json.decode(result));

      // Add the new instance of task-skills to database
      FirestoreService().addTaskSkills(taskTitle, skills);
      // Return skills
      return skills;
    }

    /// Level up & add new skills
    void parseSkills(skills) async {
      List<Map<String, dynamic>> newSkills = [];
      var messages = [];

      for (var s1 in skills) {
        Skill? s2;
        if (state.skills.any((s) => s.title == s1['skill'])) {
          s2 = state.skills.firstWhere((s) => s.title == s1['skill']);
        }
        if (s2 != null) {
          state.levelUpSkill(s2, s1['exp']);
          messages.add("${s1['skill']} + ${s1['exp']}");
        } else {
          newSkills.add(s1);
        }
      }

      Map<String, dynamic>? getNewSkill(List<Map<String, dynamic>> skills) {
        skills.sort((a, b) => b['probability'].compareTo(a['probability']));

        Random random = Random();
        double chance = random.nextDouble();

        for (var skill in skills) {
          if (chance < skill['probability']) return skill;
        }

        return null;
      }

      if (newSkills.isNotEmpty) {
        // Randomly pick 1 skill to give to user
        var newSkill = getNewSkill(newSkills);
        if (newSkill != null) {
          state.addSkill(newSkill['skill'], newSkill['exp'], newSkill['type']);
          messages.add("New Skill: ${newSkill['skill']} + ${newSkill['exp']}");
        }
      }

      for (var message in messages) {
        _addHintMessage(message);
        // Add a delay of 0.2 seconds
        await Future.delayed(Duration(milliseconds: 500));
      }
    }

    if (skills == null) {
      // If task not found in database, create new skills
      setState(() {
        evaluatingTasks.add(task.id);
      });
      skills = await generateSkillsFromTaskTitle(task.title);
      setState(() {
        evaluatingTasks.remove(task.id);
      });
    }

    parseSkills(skills);
    state.toggleTask(task);
  }

  Widget taskEvaluatingCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.transparent, // Background color
        borderRadius: BorderRadius.circular(5), // Circular radius
      ),
      height: 52,
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.only(left: 16.0),
      child: Row(
        children: [
          SizedBox(height: 20, width: 20, child: CircularProgressIndicator()),
          SizedBox(width: 16),
          Text(
            "Evaluating",
            style: TextStyle(
              fontSize: 17,
            ),
          ),
        ],
      ),
    );
  }

  Queue<String> hintMessages = Queue();

  // This method creates the overlay entry
  Widget SystemMessages() {
    return Positioned(
        bottom: 56,
        width: MediaQuery.of(context).size.width,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: ClipRRect(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(5.0), // Radius for bottom-left corner
              bottomRight:
                  Radius.circular(5.0), // Radius for bottom-right corner
            ),
            child: Column(
              children: hintMessages
                  .map((m) => Column(
                        children: [
                          HintCard(m),
                          const Divider(
                            height: 5,
                            thickness: 5,
                            color: Colors.transparent,
                          ),
                        ],
                      ))
                  .toList(),
            ),
          ),
        ));
  }

  Widget HintCard(message) {
    return Material(
      color: Colors.transparent,
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: 52,
        padding: EdgeInsets.symmetric(horizontal: 19.0),
        decoration: BoxDecoration(
          color: Color.fromRGBO(50, 50, 50, 1),
          // Color.fromRGBO(45, 45, 45, 1)
          borderRadius: BorderRadius.circular(5.0),
        ),
        child: Align(
          alignment: Alignment.centerLeft,
          child: Row(
            children: [
              const FaIcon(
                FontAwesomeIcons.upLong, // Use a Font Awesome icon here
                size: 20.0,
                color: Colors.white,
              ),
              SizedBox(width: 18),
              Text(
                message,
                style: TextStyle(color: Colors.white, fontSize: 16),
                textAlign: TextAlign.start,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _addHintMessage(message) {
    if (hintMessages.length == 3) hintMessages.removeFirst();
    setState(() {
      hintMessages.add(message);
    });
    Future.delayed(Duration(seconds: 3), () {
      setState(() {
        hintMessages.remove(message);
      });
    });
  }

  Widget buildCompletedSection(tasks) {
    var completed = tasks.where((task) => task.isCompleted == true).toList();
    final state = Provider.of<MainState>(context);

    return ExpansionTile(
        title: const Text(
          'Completed',
          style: TextStyle(fontSize: 14, color: Colors.grey),
        ),
        initiallyExpanded: true,
        children: [
              ReorderableListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: completed.length,
                  onReorder: state.reorderTask,
                  itemBuilder: (context, index) {
                    return Flexible(
                      key: ValueKey(completed[index].id),
                      child: Column(
                        children: [
                          evaluatingTasks.contains(completed[index].id)
                              ? taskEvaluatingCard()
                              : taskCard(completed[index]),
                          const Divider(
                            // This creates a horizontal line between tasks
                            height: 5,
                            thickness: 5,
                            color: Colors.transparent,
                          ),
                        ],
                      ));
                  })
        ]
    );
  }

  // This function handles the display of the "Add a Task" button or the input field
  Widget buildAddTaskButtonOrInput() {
    return Padding(
        padding: const EdgeInsets.fromLTRB(16.0, 0, 16.0, 4.0),
        child: isAddingTask
            ? buildTaskInputField() // Show input field if the user clicked the "+ Add a Task" button
            : buildInputButton());
  }

  Widget buildInputButton() {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: () {
          setState(() {
            isAddingTask = true; // Switch to input field
          });
        },
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.symmetric(horizontal: 14),
          backgroundColor: Color.fromRGBO(45, 45, 45, 1),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
          ),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Icon(Icons.add),
            SizedBox(width: 11),
            Text("Add a Task"),
          ],
        ),
      ),
    );
  }

  // This widget builds the input field and add button for new task
  Widget buildTaskInputField() {
    final state = Provider.of<MainState>(context);

    return SizedBox(
      height: 50,
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: taskController,
              autofocus: true, // Automatically focus the input when it appears
              decoration: InputDecoration(
                hintText: "Enter task name",
                filled: true,
                fillColor: Color.fromRGBO(45, 45, 45, 1),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
              onTap: () {
                // Prevent hiding when tapping inside the input
              },
            ),
          ),
          IconButton(
            icon: Icon(Icons.check, color: Colors.blue),
            onPressed: () {
              setState(() {
                state.addTask(taskController.text);
                taskController.clear();
                isAddingTask = false; // Switch back to "+ Add a Task" button
              });
            },
          ),
        ],
      ),
    );
  }
}
