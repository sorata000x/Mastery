import 'package:flutter/material.dart';

// Import the firebase_core plugin
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:skillcraft/main_state.dart';
import 'package:skillcraft/profile/profile.dart';
import 'package:skillcraft/routes.dart';
import 'package:skillcraft/shared/shared.dart';
import 'package:skillcraft/skills/skills.dart';
import 'package:skillcraft/theme.dart';
import 'package:skillcraft/services/auth.dart';
import 'package:skillcraft/todo/todo.dart';

// Main entry point of the app
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(App());
}

// Main App StatefulWidget to initialize Firebase and hold state
class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initialization,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Center(child: Text('Error initializing Firebase'));
        }

        if (snapshot.connectionState == ConnectionState.done) {
          return ChangeNotifierProvider<MainState>(
            create: (_) => MainState(),
            child: MaterialApp(
              home: Scaffold(
                body: MainContent(),  // MainContent now depends on MainState
                bottomNavigationBar: const BottomNavBar(), // BottomNavBar depends on MainState
              ),
              theme: appTheme,
            ),
          );
        }

        return const Center(child: Text('Loading...'));
      },
    );
  }
}

// MainContent widget that depends on MainState
class MainContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var state = Provider.of<MainState>(context);
    var page = state.page;

    if (page == 0) {
      return ToDoScreen();
    } else if (page == 1) {
      return SkillsScreen();
    } else if (page == 2) {
      return ProfileScreen();
    }

    return Center(child: Text("ERROR: Page number $page not found."));
  }
}