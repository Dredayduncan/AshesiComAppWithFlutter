import 'package:ashesicom/views/landingPage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  return runApp(
      MaterialApp(
        home: LandingPage(),
        theme: ThemeData(
          fontFamily: "SF Pro",
          scaffoldBackgroundColor: const Color(0xFFD0BBC4)
        ),
      )
  );
}