import 'dart:isolate';

import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background/flutter_background.dart';
import 'package:login/providers/google_sign_in.dart';
import 'package:login/providers/nearby_connections.dart';
import 'package:login/screens/contact_tracing.dart';
import 'package:login/screens/google_maps.dart';
import 'package:login/screens/home_screen.dart';
import 'package:login/screens/instruction_manual.dart';
import 'package:login/screens/quarantine_guidelines_screen.dart';
import 'package:login/screens/registration_screen.dart';
import 'package:nearby_connections/nearby_connections.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/global_variables.dart' as globals;

Future<void> main() async {
  //Initialize Packages and APIs for the application
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  const androidConfig = FlutterBackgroundAndroidConfig(
    notificationTitle: "ElbiTrace Contact Tracing",
    notificationText: "Contact Tracing is still active in the background",
    notificationImportance: AndroidNotificationImportance.Default,
    notificationIcon: AndroidResource(
        name: 'background_icon',
        defType: 'drawable'), // Default is ic_launcher from folder mipmap
  );
  bool success =
      await FlutterBackground.initialize(androidConfig: androidConfig);
  if (success) {
    await FlutterBackground.enableBackgroundExecution();
  }
  // Obtain shared preferences.
  final prefs = await SharedPreferences.getInstance();
  // Save an boolean value to 'repeat' key.
  globals.isFirstLogin = prefs.getBool('isFirstLogin');

  FirebaseAuth.instance.authStateChanges().listen((user) {
    if (user != null) {
      startNearbyDetection(user);
    }
  });
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => GoogleSignInProvider(),
      child: MaterialApp(
          title: 'ElbiTrace',
          theme: ThemeData(
              primaryColor: Colors.purple, primarySwatch: Colors.lightBlue),
          home: HomeScreen(),
          routes: {
            "Home": ((context) => HomeScreen()),
            "Map": (context) => MapSample(),
            "Tracing": (context) => const ContactTracingScreen(),
            "Registration": (context) => RegistrationScreen(),
            "Guidelines": (context) => GuidelinesScreen(),
            "Manual": (context) => InstructionManual()
          }),
    );
  }
}
