import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skillborn/main_state.dart';
import 'package:skillborn/services/models.dart';

class TaskDrawer extends StatelessWidget {
  const TaskDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<MainState>(context);
    return Drawer(
      child: Padding(
        padding: EdgeInsets.fromLTRB(10, 50, 10, 10),
        child: Column(children: [
          Card(
            shape: RoundedRectangleBorder(
              borderRadius:
                  BorderRadius.circular(10.0), // Set border radius here
            ),
            clipBehavior: Clip.antiAlias,
            child: ListTile(
              key: ValueKey('inbox'),
              title: Text(
                'Inbox',
                style: TextStyle(
                  color: Colors.white
                ),  
              ),
              selectedTileColor: Theme.of(context).colorScheme.tertiary,
              selected: state.selectedList?.id == 'inbox',
              onTap: () {
                state.setSelectedList(
                    TaskList(id: 'inbox', index: -1, title: 'Inbox'));
                state.listTitleController.text = 'Inbox';
                Navigator.pop(context);
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "List",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
            ),
          ),
          Expanded(
            child: ReorderableListView.builder(
                shrinkWrap: true,
                itemCount: state.lists.length,
                onReorder: (oldIndex, newIndex) {
                  if (newIndex > oldIndex) {
                    newIndex -= 1;
                  }
                  state.reorderList(
                      state.lists[oldIndex].index, state.lists[newIndex].index);
                },
                itemBuilder: (context, index) {
                  return Card(
                    key: ValueKey(state.lists[index].id),
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(10.0), // Set border radius here
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: ListTile(
                      selected: state.selectedList?.id == state.lists[index].id,
                      selectedTileColor: Theme.of(context).colorScheme.tertiary,
                      title: Text(
                        state.lists[index].title == ''
                            ? 'Untitled'
                            : state.lists[index].title,
                        style: TextStyle(
                          color: Colors.white
                        ),  
                      ),
                      onTap: () {
                        state.setSelectedList(state.lists[index]);
                        state.listTitleController.text =
                            state.lists[index].title;
                        Navigator.pop(context);
                      },
                    ),
                  );
                }),
          ),
          ListTile(
            leading: Icon(Icons.add),
            title: Text('New List'),
            onTap: () {
              state.addList();
            },
          ),
        ]),
      ),
    );
  }
}
