import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:skillcraft/skills/skills.dart';
import 'package:skillcraft/todo/todo.dart';

class BottomNavBar extends StatelessWidget {
  const BottomNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(
              FontAwesomeIcons.graduationCap,
              size: 20,
            ),
            label: 'Todos',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              FontAwesomeIcons.bolt,
              size: 20,
            ),
            label: 'Skills',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              FontAwesomeIcons.userCircle,
              size: 20,
            ),
            label: 'Profile',
          ),
        ],
        fixedColor: Colors.deepPurple[200],
        onTap: (int idx) {
          switch (idx) {
            case 0:
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ToDoScreen()),);
              break;
            case 1:
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => SkillsScreen()),);
              break;
            case 2:
              Navigator.pushNamed(context, '/profile');
              break;
          }
        }
      );
  }
}
