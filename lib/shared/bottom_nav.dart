import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:skillborn/main_state.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
            state.page == 0
                ? FontAwesomeIcons.solidCircleCheck // Filled icon
                : FontAwesomeIcons.circleCheck, // Lined icon
            size: 20,
          ),
          label: AppLocalizations.of(context)!.todos,
        ),
        BottomNavigationBarItem(
          icon: Icon(
            state.page == 1
                ? FontAwesomeIcons.bolt // Filled icon
                : FontAwesomeIcons.bolt, // Lined icon
            size: 20,
          ),
          label: AppLocalizations.of(context)!.skills,
        ),
        BottomNavigationBarItem(
          icon: Icon(
            state.page == 2
                ? FontAwesomeIcons.solidCircleUser // Filled icon
                : FontAwesomeIcons.circleUser, // Lined icon
            size: 20,
          ),
          label: AppLocalizations.of(context)!.profile,
        ),
      ],
      selectedItemColor: Colors.white,
      unselectedItemColor: Colors.grey,
      selectedLabelStyle: const TextStyle(fontSize: 12),
      unselectedLabelStyle: const TextStyle(fontSize: 12),
      onTap: (int idx) {
        state.page = idx;  // Update the page in MainState using the setter
      },
    );
  }
}

