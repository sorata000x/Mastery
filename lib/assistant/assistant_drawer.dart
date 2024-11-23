import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skillborn/main_state.dart';

class AssistantDrawer extends StatelessWidget {
  const AssistantDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<MainState>(context);
    print("state.conversations.length: ${state.conversations.length}");
    return Drawer(
      child: Padding(
        padding: EdgeInsets.only(top: 50),
        child: Column(
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
                fillColor: Theme.of(context).colorScheme.tertiary, // Set your desired background color
                hintStyle: TextStyle(
                  color: const Color.fromARGB(255, 140, 140, 140),
                ),
                border: OutlineInputBorder(
                  borderRadius:
                      BorderRadius.circular(8), // Optional: rounded corners
                  borderSide: BorderSide.none, // Optional: no border
                ),
                contentPadding: EdgeInsets.symmetric(
                    horizontal: 16, vertical: 12), // Adjust padding if needed
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.symmetric(vertical: 10),
                shrinkWrap: true,
                itemCount: state.conversations.length,
                itemBuilder: (context, index) {
                  return Card(
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(10.0), // Set border radius here
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: ListTile(
                      key: ValueKey(state.conversations[index].id),
                      selectedTileColor: Theme.of(context).colorScheme.tertiary,
                      selected: state.currentConversation?.id == state.conversations[index].id,
                      title: Text(
                        state.conversations[index].title,
                        overflow: TextOverflow.fade,
                        softWrap: false,
                      ),
                      onTap: () {
                        state.currentConversation = state.conversations[index];
                        Navigator.pop(context);
                      },
                    ),
                  );
                }),
            )
          ],
        ),
      ),
    );
  }
}
