import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skillborn/main_state.dart';
import 'package:skillborn/services/models.dart';

class SkillsDrawer extends StatelessWidget {
  const SkillsDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<MainState>(context);
    return Drawer(
      child: Padding(
        padding: EdgeInsets.fromLTRB(10, 50, 10, 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
          Card(
            margin: EdgeInsets.zero,
            shape: RoundedRectangleBorder(
              borderRadius:
                  BorderRadius.circular(6.0), // Set border radius here
            ),
            clipBehavior: Clip.antiAlias,
            child: ListTile(
              key: ValueKey('all'),
              visualDensity: VisualDensity.compact,
              title: Text(
                'All',
                style: TextStyle(
                  color: Colors.white
                ),  
              ),
              selectedTileColor: Theme.of(context).colorScheme.tertiary,
              selected: state.selectedPath?.id == 'all',
              onTap: () {
                state.setSelectedPath(
                    SkillPath(id: 'all', index: -1, title: 'All'));
                state.pathTitleController.text = 'All';
                Navigator.pop(context);
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(4, 10, 20, 0),
            child: Text(
              "Path",
              style: TextStyle(
                fontSize: 18, 
                fontWeight: FontWeight.w500,
                color: const Color.fromARGB(255, 180, 180, 180),
                ),
            ),
          ),
          Expanded(
            child: ReorderableListView.builder(
              padding: EdgeInsets.zero,
                shrinkWrap: true,
                itemCount: state.paths.length,
                onReorder: (oldIndex, newIndex) {
                  if (newIndex > oldIndex) {
                    newIndex -= 1;
                  }
                  state.reorderPath(
                      state.paths[oldIndex].index, state.paths[newIndex].index);
                },
                itemBuilder: (context, index) {
                  return Column(
                    key: ValueKey(state.paths[index].id),
                    children: [
                      Card(
                        margin: EdgeInsets.zero,
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(6.0), // Set border radius here
                        ),
                        clipBehavior: Clip.antiAlias,
                        child: ListTile(
                          //contentPadding: EdgeInsets.zero,
                          visualDensity: VisualDensity.compact,
                          selected: state.selectedPath?.id == state.paths[index].id,
                          selectedTileColor: Theme.of(context).colorScheme.tertiary,
                          title: Text(
                            state.paths[index].title == ''
                                ? 'Untitled'
                                : state.paths[index].title,
                            style: TextStyle(
                              color: Colors.white
                            ),  
                          ),
                          onTap: () {
                            state.setSelectedPath(state.paths[index]);
                            state.pathTitleController.text =
                                state.paths[index].title;
                            Navigator.pop(context);
                          },
                        ),
                      ),
                      if (index != state.paths.length - 1)
                        SizedBox(height: 4),
                    ],
                  );
                }),
          ),
          ListTile(
            leading: Icon(Icons.add),
            title: Text('New Path'),
            onTap: () {
              state.addPath();
            },
          ),
        ]),
      ),
    );
  }
}
