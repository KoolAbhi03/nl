import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:never_lost/auth/auth.dart';
import 'package:never_lost/pages/splashscreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await AuthMethods.initializeFirebase();
  runApp(const MaterialApp(
    home: SplashScreen(),
  ));
}
