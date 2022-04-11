import 'package:flutter/material.dart';

import '../common_widgets/customAppBar.dart';
import '../common_widgets/customFormTextField.dart';
import '../common_widgets/customSubmitButton.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({Key? key}) : super(key: key);

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {

  //Initialize textfield controllers
  final TextEditingController _emailController = TextEditingController();
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: const Color(0xFFAF3A42),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(100),
        child: AppBar(
            elevation: 0,
            toolbarHeight: 110,
            backgroundColor: const Color(0xFFAF3A42),
            title: const Text(
              "Forgot Password",
              style: TextStyle(
                fontFamily: "Avenir",
                fontSize: 18,
                color: Colors.white,
                fontWeight: FontWeight.bold
              ),
            ),
          centerTitle: true,
        )
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
                "Forgot Password",
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
              const SizedBox(height: 40,),
              CustomSubmitButton(
                text: "Submit",
                onPressed: () {},
                color: const Color(0xFFCB6E74),
                textColor: Colors.white,
              ),
              const SizedBox(height: 10,),
            ],
          ),
        ),
      ),
    );
  }
}
