import 'package:ashesicom/views/homepage.dart';
import 'package:ashesicom/views/welcomeScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../services/auth.dart';
import '../services/rt_database.dart';
import 'login.dart';

class LandingPage extends StatelessWidget {
  final Auth auth = Auth();
  final RTDatabase db = RTDatabase();

  LandingPage({Key? key}) : super(key: key);

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


          return HomePage(auth: auth);
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
