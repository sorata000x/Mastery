import 'package:skillcraft/profile/profile.dart';
import 'package:skillcraft/skills/skills.dart';
import 'package:skillcraft/todo/todo.dart';
import 'package:skillcraft/home/home.dart';
import 'package:skillcraft/login/login.dart';

var appRoutes = {
  '/': (context) => const HomeScreen(),
  '/login': (context) => const LoginScreen(),
  '/todo': (context) => const ToDoScreen(),
  '/skills': (context) => const SkillsScreen(),
  '/profile': (context) => const ProfileScreen(),
};