import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skillborn/main_state.dart';
import 'package:skillborn/services/auth.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<MainState>(context);
    return Scaffold(
        appBar: AppBar(
          title: const Text('Profile'),
        ),
        body: ElevatedButton(
          onPressed: () async {
            await AuthService().signOut();
          },
          child: const Text('signout'),
        ));
  }
}
