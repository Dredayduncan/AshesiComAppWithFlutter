import 'package:ashesicom/views/screenManager.dart';
import 'package:ashesicom/views/welcomeScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../services/auth.dart';

class LandingPage extends StatefulWidget {

  LandingPage({Key? key}) : super(key: key);

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  final Auth auth = Auth();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
        stream: auth.authStateChanges(),
        builder: (context, snapshot){
          if (snapshot.connectionState == ConnectionState.active) {
          final user = snapshot.data;

          //Check if the user has signed in
          if (user == null) {
            //Display the signIn page if the user has not logged in
            return const WelcomeScreen();
          }

          return ScreenManager(auth: auth);
          }

          //Display a loading UI while the data is loading
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
      }
    );

  }
}
