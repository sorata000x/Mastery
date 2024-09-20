import 'package:flutter/material.dart';

// Import the firebase_core plugin
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:skillcraft/login/login.dart';
import 'package:skillcraft/main_state.dart';
import 'package:skillcraft/profile/profile.dart';
import 'package:skillcraft/shared/shared.dart';
import 'package:skillcraft/skills/skills.dart';
import 'package:skillcraft/theme.dart';
import 'package:skillcraft/task/task.dart';
import 'package:skillcraft/task/task_state.dart';

// Main entry point of the app
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const App());
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
            child: const MainContent(),
          );
        }

        return const Center(child: Text('Loading...'));
      },
    );
  }
}

class MainContent extends StatefulWidget {
  const MainContent({super.key});

  @override
  State<MainContent> createState() => _MainContentState();
}

class _MainContentState extends State<MainContent> {


  @override
  Widget build(BuildContext context) {
    final state = Provider.of<MainState>(context);
    if (state.user == null) {
      return MaterialApp(
        home: const Scaffold(
          body: LoginScreen(),
        ),
        theme: appTheme,
      );
    }

    return MaterialApp(
      home: const Scaffold(
        body: MainContentBody(), // MainContent now depends on MainState
        bottomNavigationBar:
            BottomNavBar(), // BottomNavBar depends on MainState
      ),
      theme: appTheme,
    );
  }
}

// MainContent widget that depends on MainState
class MainContentBody extends StatelessWidget {
  const MainContentBody({super.key});

  @override
  Widget build(BuildContext context) {
    var state = Provider.of<MainState>(context);
    var page = state.page;

    if (page == 0) {
      return ChangeNotifierProvider(
              create: (_) => TaskState(),
              child: const TaskScreen(),
            );
    } else if (page == 1) {
      return const SkillsScreen();
    } else if (page == 2) {
      return const ProfileScreen();
    }

    return Center(child: Text("ERROR: Page number $page not found."));
  }
}
