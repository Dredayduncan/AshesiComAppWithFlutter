import 'package:ashesicom/common_widgets/customFormTextField.dart';
import 'package:ashesicom/common_widgets/customSubmitButton.dart';
import 'package:flutter/material.dart';
import '../common_widgets/customAppBar.dart';
import '../services/auth.dart';
import 'login.dart';

class Signup extends StatelessWidget {
  final Auth auth = Auth();

  Signup({Key? key}) : super(key: key);

  //Initialize textfield controllers
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _cpasswordController = TextEditingController();
  final TextEditingController _contactController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();

  //Instantiate form key
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: const Color(0xFFAF3A42),
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(130),
        child: CustomAppBar(),
      ),
      body: Form(
        key: _formKey,
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(topRight: Radius.circular(20), topLeft: Radius.circular(20))
          ),
          child: Padding(
            padding: const EdgeInsets.only(left: 16.0, top: 40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Sign Up",
                  style: TextStyle(
                      fontFamily: "Avenir",
                      fontWeight: FontWeight.bold,
                      fontSize: 22
                  ),
                ),
                const SizedBox(height: 20,),
                CustomTextField(
                  validator: (_nameController) {
                    if (_nameController!.isEmpty){
                      return "Please enter your username";
                    }

                    return null;
                  },
                  hintText: "Your username",
                  labeledText: "Username",
                  controller: _nameController
                ),
                CustomTextField(
                  validator: (_emailController) {
                    if (_emailController!.isEmpty){
                      return "Please enter your ashesi email";
                    }

                    return null;
                  },
                  hintText: "example@gmail.com",
                  labeledText: "Email",
                  controller: _emailController
                ),
                const SizedBox(height: 10,),
                CustomTextField(
                  validator: (_contactController) {
                    if (_contactController!.isEmpty){
                      return "Please enter your contact";
                    }

                    return null;
                  },
                  hintText: "+233231234564",
                  labeledText: "Contact",
                  controller: _contactController
                ),
                const SizedBox(height: 10,),
                CustomTextField(
                  validator: (_passwordController) {
                    if (_passwordController!.isEmpty){
                      return "Please enter your password";
                    }

                    return null;
                  },
                  isPassword: true,
                  hintText: "•••••••••••••",
                  labeledText: "Password",
                  controller: _passwordController
                ),
                const SizedBox(height: 10,),
                CustomTextField(
                  validator: (_cpasswordController) {
                    if (_cpasswordController!.isEmpty){
                      return "Please enter your password for confirmation";
                    }

                    return null;
                  },
                  isPassword: true,
                  hintText: "•••••••••••••",
                  labeledText: "Confirm Password",
                  controller: _cpasswordController
                ),
                const SizedBox(height: 30,),
                CustomSubmitButton(
                  text: "Sign Up",
                  onPressed: () {
                    if (!_formKey.currentState!.validate()){
                      return;
                    }
                    else{
                      auth.createUserWithEmailAndPassword(
                        email: _emailController.text,
                        password: _passwordController.text,
                        username: _nameController.text
                      ).then((value) {
                        if (value == null){
                          return false;
                        }
                        else{
                          return Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (context) => Login(auth: auth))
                          );
                        }
                      });
                    }
                  },
                  color: const Color(0xFFCB6E74),
                  textColor: Colors.white,
                ),
                const SizedBox(height: 20,),
                Center(
                  child: TextButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => Login())
                        );
                      },
                      child: const Text(
                        "Log In",
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
      ),
    );
  }
}
