import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skillborn/main_state.dart';

class AssistantDrawer extends StatelessWidget {
  const AssistantDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<MainState>(context);
    return Drawer(
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
                    fillColor: const Color.fromARGB(
                        255, 40, 40, 40), // Set your desired background color
                    hintStyle: TextStyle(
                      color: const Color.fromARGB(255, 140, 140, 140),
                    ),
                    border: OutlineInputBorder(
                      borderRadius:
                          BorderRadius.circular(8), // Optional: rounded corners
                      borderSide: BorderSide.none, // Optional: no border
                    ),
                    contentPadding: EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12), // Adjust padding if needed
                  ),
                ),
                ListView.builder(
                    reverse: true,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: state.conversations.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        key: ValueKey(state.conversations[index].id),
                        title: Text(
                          state.conversations[index].title,
                        ),
                        onTap: () {
                          state.currentConversation = state.conversations[index];
                          Navigator.pop(context);
                        },
                      );
                    })
              ],
            ),
          ),
        ],
      ),
    );
  }
}
