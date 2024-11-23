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
        child: Column(children: [
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0), // Set border radius here
            ),
            clipBehavior: Clip.antiAlias,
            child: ListTile(
              key: ValueKey('all'),
              title: Text('All'),
              selectedTileColor: const Color.fromARGB(255, 60, 60, 60),
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
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "Path",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
            ),
          ),
          Expanded(
            child: ReorderableListView.builder(
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
                  return Card(
                    key: ValueKey(state.paths[index].id),
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(10.0), // Set border radius here
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: ListTile(
                      selected: state.selectedPath.id == state.paths[index].id,
                      selectedTileColor: const Color.fromARGB(255, 60, 60, 60),
                      title: Text(
                        state.paths[index].title == ''
                            ? 'Untitled'
                            : state.paths[index].title,
                      ),
                      onTap: () {
                        state.setSelectedPath(state.paths[index]);
                        state.pathTitleController.text = state.paths[index].title;
                        Navigator.pop(context);
                      },
                    ),
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
