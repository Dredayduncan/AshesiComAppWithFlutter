import 'package:ashesicom/views/signup.dart';
import 'package:flutter/material.dart';

import 'login.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFAF3A42),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [

          Padding(
            padding: const EdgeInsets.only(top: 100.0),
            child: Stack(
              alignment: Alignment.bottomCenter,
              children: [
                Image.asset(
                  "assets/images/ashesicom.png",
                  fit: BoxFit.fill,
                ),
                const Text(
                  "AshesiCom",
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold
                  ),
                )
              ],
            ),
          ),
          Spacer(),
          Align(
            alignment: FractionalOffset.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 60.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => Login()));
                      },
                      child: const Text(
                        "Log In",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        fixedSize: const Size(170, 62),
                        primary: const Color(0xFFCB6E74),
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(18.0),
                          )
                        )
                      ),
                    ),
                  ),
                  const SizedBox(width: 15.0,),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => Signup()));
                      },
                      child: const Text(
                        "Sign Up",
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                          fixedSize: const Size(170, 62),
                          primary: const Color(0xFFD0BBC4),
                          shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(18.0),
                              )
                          )
                      ),
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
      );
    }
}
