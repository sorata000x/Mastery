import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:skillborn/main.dart';
import 'package:skillborn/main_state.dart';
import 'package:skillborn/services/auth.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:skillborn/services/firestore.dart';
import 'package:skillborn/services/models.dart';
import 'package:uuid/uuid.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = AuthService();
    final state = Provider.of<MainState>(context, listen: false);

    Future<void> initializeDefaultTasks() async {
      List<Task> defaultTasks = [
        Task(
          id: Uuid().v4(),
          list: 'inbox',
          title: "Buy or create skills that you like",
          note:
              "Buy or create skills through Explore Skills in the Skills page and start your journey towards mastery.",
          skillExps: [],
          karma: 100,
          index: 0,
          isCompleted: false,
        ),
        Task(
          id: Uuid().v4(),
          list: 'inbox',
          title: "Make a plan for today",
          note:
              "Taking a few minutes to plan for the day to boost productivity, reduces stress, and stay focused on what matters most.",
          skillExps: [],
          karma: 100,
          index: 1,
          isCompleted: false,
        ),
        Task(
          id: Uuid().v4(),
          list: 'inbox',
          title: "Do one thing that scares you",
          note:
              "Do something scary to build courage and resilience by pushing beyond your comfort zone.",
          karma: 100,
          index: 2,
          isCompleted: false,
        ),
        Task(
          id: Uuid().v4(),
          list: 'inbox',
          title: "Write down three things you are grateful for today",
          note:
              "Cultivates a positive mindset and improves mental resilience by focusing on what's good in life.",
          karma: 100,
          index: 3,
          isCompleted: false,
        ),
      ];
      state.setTasks(defaultTasks);
    }

    Future<void> welcomeMessage() async {
      state.addMessage('assistant',
          "Welcome to Mastery, the todo app that turns the tasks you completed into progress towards skill mastery.");
      state.setOptions([Option(text: 'Tutorial', function: 'startTutorial')]);
    }

    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            const FlutterLogo(
              size: 150,
            ),
            LoginButton(
              text: 'Sign in with Google',
              icon: FontAwesomeIcons.google,
              color: Colors.blue,
              loginMethod: () async {
                final user = await authService.googleLogin();
                if (user == null) return;
                await authService.initializeUserData(user, () async {
                  initializeDefaultTasks();
                  welcomeMessage();
                  state.setKarma(1000);
                });
              },
            ),
            FutureBuilder(
              future: SignInWithApple.isAvailable(),
              builder: (context, snapshot) {
                if (snapshot.data == true) {
                  return SignInWithAppleButton(
                    onPressed: () async {
                      final user = await authService.signInWithApple();
                      if (user != null) {
                        await authService.initializeUserData(user, () {
                          initializeDefaultTasks();
                          welcomeMessage();
                          state.setKarma(1000);
                        });
                      }
                    },
                  );
                } else {
                  return Container();
                }
              },
            ),
            Flexible(
              child: LoginButton(
                icon: FontAwesomeIcons.userNinja,
                text: 'Continue as Guest',
                loginMethod: () async {
                  final user = await authService.anonLogin();
                  if (user != null) {
                    await authService.initializeUserData(user, () {
                      initializeDefaultTasks();
                      welcomeMessage();
                      state.setKarma(1000);
                    });
                  }
                },
                color: Colors.deepPurple,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class LoginButton extends StatelessWidget {
  final Color color;
  final IconData icon;
  final String text;
  final Future<void> Function() loginMethod;

  const LoginButton({
    super.key,
    required this.text,
    required this.icon,
    required this.color,
    required this.loginMethod,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      child: ElevatedButton.icon(
        icon: Icon(
          icon,
          color: Colors.white,
          size: 20,
        ),
        style: TextButton.styleFrom(
          padding: const EdgeInsets.all(24),
          backgroundColor: color,
        ),
        onPressed: () async {
          await loginMethod();
          WidgetsBinding.instance.addPostFrameCallback((_) {
            App.restartApp(context); // Restart the app after login
          });
        },
        label: Text(
          text,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
