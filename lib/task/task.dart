import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skillborn/main_state.dart';
import 'package:skillborn/task/system_messages/system_messages.dart';
import 'package:skillborn/task/task_section/task_section.dart';

class TaskScreen extends StatefulWidget {
  const TaskScreen({super.key});

  @override
  State<TaskScreen> createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> {
  @override
  Widget build(BuildContext context) {
    final state = Provider.of<MainState>(context);
    return GestureDetector(
        child: Stack(
      children: [
        Scaffold(
          appBar: AppBar(
              //actions: [
              //  IconButton(
              //    icon: const Icon(Icons.person_add),
              //    onPressed: () {
              //      // Add action for the button
              //    },
              //  ),
              //],
              ),
          drawer: Drawer(
            child: Column(
              children: [
                Expanded(
                  child: ListView(
                    padding: EdgeInsets.only(top: 30),
                    children: <Widget>[
                      // [EXAMPLE]
                      // ListTile(
                      //   leading: Icon(Icons.home),
                      //   title: Text('Home'),
                      //   onTap: () {
                      //     // Handle navigation or other actions here
                      //     Navigator.pop(context); // Close the drawer
                      //   },
                      // ),
                      TextField(
                        decoration: InputDecoration(
                          hintText: 'Search',
                          filled: true, // Enable filling the background
                          fillColor: const Color.fromARGB(255, 40, 40,
                              40), // Set your desired background color
                          hintStyle: TextStyle(
                            color: const Color.fromARGB(255, 140, 140, 140),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(
                                8), // Optional: rounded corners
                            borderSide: BorderSide.none, // Optional: no border
                          ),
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12), // Adjust padding if needed
                        ),
                      ),
                      ReorderableListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: state.lists.length,
                          onReorder: (oldIndex, newIndex) {
                            if (newIndex > oldIndex) {
                              newIndex -= 1;
                            }
                            state.reorderList(state.lists[oldIndex].index,
                                state.lists[newIndex].index);
                          },
                          itemBuilder: (context, index) {
                            return ListTile(
                              key: ValueKey(state.lists[index].id),
                              title: Text(
                                state.lists[index].title == ''
                                    ? 'Untitled'
                                    : state.lists[index].title,
                              ),
                              onTap: () {
                                state.setSelectedList(state.lists[index]);
                                state.listTitleController.text =
                                    state.lists[index].title;
                                Navigator.pop(context);
                              },
                            );
                          })
                    ],
                  ),
                ),
                ListTile(
                  leading: Icon(Icons.add),
                  title: Text('New List'),
                  onTap: () {
                    state.addList();
                  },
                ),
              ],
            ),
          ),
          body: TaskSection(),
        ),
        SystemMessages(),
      ],
    ));
  }
}
