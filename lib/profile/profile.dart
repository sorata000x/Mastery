import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skillborn/main_state.dart';
import 'package:skillborn/profile/profile_field.dart';
import 'package:skillborn/profile/user_rank.dart';
import 'package:skillborn/services/auth.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:google_sign_in/google_sign_in.dart';

class ProfileScreen extends StatelessWidget {
  ProfileScreen({super.key});
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<MainState>(context);
    return Scaffold(
        appBar: AppBar(
          title: Text(AppLocalizations.of(context)!.profile),
        ),
        body: Material(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                Icons.account_circle,
                size: 80,
              ),
              UserRank(),
              Container(
                padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Karma"),
                    Text(state.karma.toString(), style: TextStyle(fontSize: 24),),
                  ],
                ),
              ),
              ProfileField(label: "ID", value: state.user ?? ''),
              SizedBox(height: 20,),
              Padding(
                padding: const EdgeInsets.all(20),
                child: SizedBox(
                  width: double.infinity,
                  height: 46,
                  child: ElevatedButton(
                    onPressed: () async {
                      await AuthService().signOut();
                      await _googleSignIn.signOut();
                    },
                    child: Text(AppLocalizations.of(context)!.sign_out),
                    style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.all<Color>(Theme.of(context).colorScheme.primaryContainer),
                      shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6.0), // Set border radius
                        ),
                      ),
                      textStyle: WidgetStateProperty.all<TextStyle>(
                        TextStyle(fontSize: 17.0), // Set text size here
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        )
    );
  }
}
