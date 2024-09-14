import 'package:flutter/material.dart';
import 'package:skillcraft/login/login.dart';
import 'package:skillcraft/services/auth.dart';
import 'package:skillcraft/todo/todo.dart';

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
            return const ToDoScreen();
          } else {
            return const LoginScreen();
          }
        });
  }
}
