import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:skillcraft/api/api.dart';
import 'package:skillcraft/services/firestore.dart';
import 'package:skillcraft/services/models.dart';
import 'package:skillcraft/shared/shared.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

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
    return FutureBuilder(
        future: FirestoreService().getTasks(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
          return const LoadingScreen();
          } else if (snapshot.hasError) {
            return Center(
              child: ErrorMessage(message: snapshot.error.toString()),
            );
          } else if (snapshot.hasData) {
            var tasks = snapshot.data;

            return GestureDetector(
              onTap: () {
                if (isAddingTask) {
                  // Hide input field if tapped outside the input area
                  setState(() {
                    isAddingTask = false;
                  });
                }
              },
              child: Scaffold(
                appBar: AppBar(
                  title: Text("To Do"),
                  actions: [
                    IconButton(
                      icon: Icon(Icons.person_add),
                      onPressed: () {
                        // Add action for the button
                      },
                    ),
                  ],
                ),
                body: Column(
                  children: [
                    Expanded(
                      // Add Expanded here to let the ListView take up the remaining space
                      child: ListView(
                        padding: EdgeInsets.all(16),
                        children: [
                          buildToDoSection(tasks),
                          SizedBox(height: 20),
                          buildCompletedSection(tasks),
                        ],
                      ),
                    ),
                    buildAddTaskButtonOrInput(), // Display add task button or input field at the bottom
                  ],
                ),
                bottomNavigationBar: const BottomNavBar(),
              ),
            );
          } else {
            return Text('No task');
          }
        });
  }

  Widget buildToDoSection(tasks) {
    var todos = tasks.where((task) => !task.isCompleted);
    return Column(
      children: todos.map<Widget>((task) {
        int index = tasks.indexOf(task);
        return Column(
          children: [
            evaluatingTasks.contains(task.id)
                ? taskEvaluatingCard()
                : taskCard(task),
            const Divider(
              // This creates a horizontal line between tasks
              height: 5,
              thickness: 5,
              color: Colors.transparent,
            ),
          ],
        );
      }).toList(),
    );
  }

  Widget taskCard(task) {
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
                        FirestoreService().deleteTaskFromFirestore(task.id);
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
            Transform.scale(
              scale: 1.2,
              child: Checkbox(
                value: task.isCompleted,
                shape: const CircleBorder(),
                onChanged: (bool? value) {
                  if (value == true) {
                    setState(() {
                      evaluatingTasks.add(task.id);
                    });
                    var messages = getTaskCompletionMessages(
                        FirestoreService().getSkills(), task.title);
                    var response = callChatGPT(messages, functions);
                    _parseAssistantResponse(response, task);
                  } else {
                    // Directly toggle tasks of no need to wait for response
                    setState(() {
                      FirestoreService().toggleTask(task);
                    });
                  }
                },
              ),
            ),
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

  Widget taskEvaluatingCard() {
    return Container(
      decoration: BoxDecoration(
        color: Color.fromRGBO(45, 45, 45, 1), // Background color
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

  void _parseAssistantResponse(Future<Set?> futureResponse, Task task) async {
    var response = await futureResponse;
    setState(() {
      FirestoreService().toggleTask(task);
      evaluatingTasks.remove(task.id);
    });
    if (response == null) return;
    for (var item in response) {
      _addHintMessage(item);
      // Add a delay of 0.2 seconds
      await Future.delayed(Duration(milliseconds: 500));
    }
  }

  Queue<String> hintMessages = Queue();

  void initState() {
    super.initState();
    // Show overlay as soon as the screen is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showOverlay(context);
    });
  }

  // This method creates the overlay entry
  OverlayEntry _createOverlayEntry(BuildContext context) {
    return OverlayEntry(
      builder: (context) => Positioned(
          bottom: 140,
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: hintMessages.map((m) => HintCard(m)).toList(),
          )),
    );
  }

  void _updateOverlay() {
    // Remove the current overlay if it's present
    _overlayEntry?.remove();

    // Create a new overlay entry with the updated hintMessages
    _overlayEntry = _createOverlayEntry(context);

    // Insert the updated overlay
    Overlay.of(context)?.insert(_overlayEntry!);
  }

  Widget HintCard(text) {
    return Material(
      color: Colors.transparent,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 16.0),
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.grey,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          text,
          style: TextStyle(color: Colors.white, fontSize: 16),
          textAlign: TextAlign.start,
        ),
      ),
    );
  }

  OverlayEntry? _overlayEntry;

  // Method to show the hint box
  void _showOverlay(BuildContext context) {
    _overlayEntry = _createOverlayEntry(context);
    Overlay.of(context).insert(_overlayEntry!);
  }

  void _addHintMessage(message) {
    if (hintMessages.length == 3) hintMessages.removeFirst();
    setState(() {
      hintMessages.add(message);
      _updateOverlay();
    });
    Future.delayed(Duration(seconds: 6), () {
      setState(() {
        hintMessages.remove(message);
        _updateOverlay();
      });
    });
  }

  Widget buildCompletedSection(tasks) {
    return ExpansionTile(
      title: const Text(
        'Completed',
        style: TextStyle(fontSize: 14, color: Colors.grey),
      ),
      initiallyExpanded: true,
      children:
          tasks.where((task) => task.isCompleted == true).map<Widget>((task) {
        return Column(
          children: [
            taskCard(task),
            const Divider(
              // This creates a horizontal line between tasks
              height: 5,
              thickness: 5,
              color: Colors.transparent,
            ),
          ],
        );
      }).toList(),
    );
  }

  // This function handles the display of the "Add a Task" button or the input field
  Widget buildAddTaskButtonOrInput() {
    return Padding(
        padding: const EdgeInsets.all(16.0),
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
          backgroundColor: Color.fromRGBO(45, 45, 45, 1),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6),
          ),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Icon(Icons.add),
            SizedBox(width: 10),
            Text("Add a Task"),
          ],
        ),
      ),
    );
  }

  // This widget builds the input field and add button for new task
  Widget buildTaskInputField() {
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
                FirestoreService().addTaskToFirestore(
                    taskController.text); // Add the new task
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
