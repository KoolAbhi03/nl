// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:never_lost/auth/auth.dart';
import 'package:never_lost/auth/database.dart';
import 'package:never_lost/auth/hive.dart';
import 'package:never_lost/pages/dashboard.dart';
import 'package:never_lost/pages/signin.dart';

class SignInButton extends StatelessWidget {
  const SignInButton({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: MaterialButton(
        onPressed: () async {
          await AuthMethods().signInWithGoogle();

          await AuthMethods().getCurrentUser().then((user) async {
            await DatabaseMethods()
                .createUserDatabase(user.displayName, user.email, user.uid,
                    user.photoURL, user.phoneNumber)
                .then((value) async {
              await HiveDB().updateUserData(value).then((v) {
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => const Home()),
                    (route) => false);
              });
            });
          });
        },
        child: const Text(
          'GetStarted with Google',
          style: TextStyle(
              color: Color(0xff57CC99),
              fontSize: 24,
              fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
