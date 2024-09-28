import 'package:flutter/material.dart';
import 'package:skillborn/services/auth.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:google_sign_in/google_sign_in.dart';

class ProfileScreen extends StatelessWidget {
  ProfileScreen({super.key});
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(AppLocalizations.of(context)!.profile),
        ),
        body: ElevatedButton(
          onPressed: () async {
            await AuthService().signOut();
            await _googleSignIn.signOut();
          },
          child: Text(AppLocalizations.of(context)!.sign_out),
        ));
  }
}
