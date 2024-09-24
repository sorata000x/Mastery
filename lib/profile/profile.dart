import 'package:flutter/material.dart';
import 'package:skillborn/services/auth.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(AppLocalizations.of(context)!.profile),
        ),
        body: ElevatedButton(
          onPressed: () async {
            await AuthService().signOut();
          },
          child: Text(AppLocalizations.of(context)!.sign_out),
        ));
  }
}
