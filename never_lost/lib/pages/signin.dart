import 'package:flutter/material.dart';
import 'package:never_lost/auth/auth.dart';
import 'package:never_lost/auth/database.dart';
import 'package:never_lost/components/color.dart';
import 'package:never_lost/components/signInButton.dart';

class SignIn extends StatefulWidget {
  const SignIn({Key? key}) : super(key: key);

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: backgroundColor1,
      body: SizedBox(
        height: height,
        width: width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const SizedBox(
              height: 64,
            ),
            const Text(
              'Never Lost',
              style: TextStyle(
                  fontSize: 40,
                  color: themeColor1,
                  fontWeight: FontWeight.bold),
            ),
            Column(
              children: [
                Image.asset(
                  'assets/background1.png',
                  width: width / 1.5,
                ),
                const Padding(
                  padding: EdgeInsets.fromLTRB(8, 8, 8, 0),
                  child: Text(
                    'Share live location with',
                    style: TextStyle(
                        fontSize: 18,
                        color: themeColor1,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                const Text(
                  'your friends',
                  style: TextStyle(
                      fontSize: 18,
                      color: themeColor1,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
            FutureBuilder(
              future: AuthMethods.initializeFirebase(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return const Text('Error Initialising');
                } else if (snapshot.connectionState == ConnectionState.done) {
                  return const SignInButton();
                }
                return const CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation(Colors.orange),
                );
              },
            ),
            const SizedBox(
              height: 64,
            )
          ],
        ),
      ),
    );
  }
}
