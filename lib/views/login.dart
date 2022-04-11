import 'package:ashesicom/common_widgets/customAppBar.dart';
import 'package:ashesicom/common_widgets/customFormTextField.dart';
import 'package:ashesicom/common_widgets/customSubmitButton.dart';
import 'package:ashesicom/views/forgotPassword.dart';
import 'package:ashesicom/views/screenManager.dart';
import 'package:ashesicom/views/signup.dart';
import 'package:flutter/material.dart';
import '../common_widgets/customAppBar.dart';
import '../services/auth.dart';

class Login extends StatelessWidget {
  final Auth auth = Auth();

  Login({Key? key}) : super(key: key);

  //Initialize textfield controllers
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: const Color(0xFFAF3A42),
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(130),
        child: CustomAppBar(),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(topRight: Radius.circular(20), topLeft: Radius.circular(20))
        ),
        child: Padding(
          padding: const EdgeInsets.only(left: 16.0, top: 80),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Log In",
                style: TextStyle(
                  fontFamily: "Avenir",
                  fontWeight: FontWeight.bold,
                  fontSize: 22
                ),
              ),
              const SizedBox(height: 20,),
              CustomTextField(
                hintText: "example@gmail.com",
                labeledText: "Email",
                controller: _emailController
              ),
              const SizedBox(height: 10,),
              CustomTextField(
                isPassword: true,
                hintText: "•••••••••••••",
                labeledText: "Password",
                controller: _passwordController
              ),
              const SizedBox(height: 40,),
              CustomSubmitButton(
                text: "Log In",
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => ScreenManager(auth: auth))
                  );
                },
                color: const Color(0xFFCB6E74),
                textColor: Colors.white,
              ),
              const SizedBox(height: 10,),
              Center(
                child: TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const ForgotPassword())
                    );
                  },
                  child: const Text(
                    "Forgot password?",
                    style: TextStyle(
                      fontFamily: "Avenir",
                      color: Color(0xFF808083),
                      fontSize: 15
                    ),
                  )
                ),
              ),
              const SizedBox(height: 80,),
              Center(
                child: TextButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => Signup())
                      );
                    },
                    child: const Text(
                      "Sign Up",
                      style: TextStyle(
                          fontFamily: "Avenir",
                          color: Color(0xFFFB9852),
                          fontSize: 16
                      ),
                    )
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
