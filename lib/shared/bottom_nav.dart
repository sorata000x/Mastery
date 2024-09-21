import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:skillborn/main_state.dart';

class BottomNavBar extends StatelessWidget {
  const BottomNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    // Access the MainState instance from the Provider
    final state = Provider.of<MainState>(context);  // Correct access to MainState

    return BottomNavigationBar(
      currentIndex: state.page,  // Use state.page
      items: [
        BottomNavigationBarItem(
          icon: Icon(
            state.page == 1
                ? FontAwesomeIcons.solidCircleCheck // Filled icon
                : FontAwesomeIcons.circleCheck, // Lined icon
            size: 20,
          ),
          label: 'Todos',
        ),
        BottomNavigationBarItem(
          icon: Icon(
            state.page == 2
                ? FontAwesomeIcons.bolt // Filled icon
                : FontAwesomeIcons.bolt, // Lined icon
            size: 20,
          ),
          label: 'Skills',
        ),
        BottomNavigationBarItem(
          icon: Icon(
            state.page == 3
                ? FontAwesomeIcons.userCircle // Filled icon
                : FontAwesomeIcons.userCircle, // Lined icon
            size: 20,
          ),
          label: 'Profile',
        ),
      ],
      selectedItemColor: Colors.white,
      unselectedItemColor: Colors.grey,
      onTap: (int idx) {
        state.page = idx;  // Update the page in MainState using the setter
      },
    );
  }
}

