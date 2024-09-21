import 'package:flutter/material.dart';
import 'package:skillborn/login/login.dart';
import 'package:skillborn/services/auth.dart';
import 'package:skillborn/task/task.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: AuthService().userStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Text('loading');
          } else if (snapshot.hasError) {
            return const Center(
              child: Text('error'),
            );
          } else if (snapshot.hasData) {
            return const TaskScreen();
          } else {
            return const LoginScreen();
          }
        });
  }
}
