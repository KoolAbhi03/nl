import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:never_lost/auth/auth.dart';
import 'package:never_lost/pages/splashscreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Hive.openBox('IMAGEBOXKEY');
  await AuthMethods.initializeFirebase();
  runApp(MaterialApp(
    home: const SplashScreen(),
  ));
}
