import 'package:flutter/material.dart';

// Import the firebase_core plugin
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:skillborn/assistant/assistant.dart';
import 'package:skillborn/login/login.dart';
import 'package:skillborn/main_state.dart';
import 'package:skillborn/profile/profile.dart';
import 'package:skillborn/shared/shared.dart';
import 'package:skillborn/skills/skills.dart';
import 'package:skillborn/theme.dart';
import 'package:skillborn/task/task.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// Main entry point of the app
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const App());
}

// Main App StatefulWidget to initialize Firebase and hold state
class App extends StatefulWidget {
  const App({super.key});

  static void restartApp(BuildContext context) {
    final _AppState? state =
        context.findAncestorStateOfType<_AppState>();
    state?.restartApp();
  }

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();
  Key key = UniqueKey();

  void restartApp() {
    setState(() {
      key = UniqueKey(); // Assign a new key to force widget rebuild
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      key: key,
      future: _initialization,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Center(child: Text('Error initializing Firebase'));
        }
        if (snapshot.connectionState == ConnectionState.done) {
          return MultiProvider(
            providers: [
              ChangeNotifierProvider(create: (context) => MainState()),
            ],
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
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: const Scaffold(
          body: LoginScreen(),
        ),
        theme: appTheme,
      );
    }

    return MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
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
      return const AssistantScreen();
    } else if (page == 1) {
      return const TaskScreen();
    } else if (page == 2) {
      return const SkillsScreen();
    } else if (page == 3) {
      return ProfileScreen();
    }

    return Center(child: Text("ERROR: Page number $page not found."));
  }
}
