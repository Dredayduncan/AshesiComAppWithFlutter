import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String labeledText;
  final String hintText;
  final TextEditingController controller;
  final bool isPassword;
  final String? Function(String?)? validator;
  final bool isContact;

  const CustomTextField({
    Key? key,
    this.validator,
    required this.labeledText,
    required this.controller,
    required this.hintText,
    this.isContact = false,
    this.isPassword = false
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      child: Center(
          child: SizedBox(
            // width: textFieldWidth,
            child: TextFormField(
              keyboardType: isContact == true
                ? TextInputType.number
                : null,
              maxLength: isContact == true
                  ? 10
                  : null,
              validator: validator,
              obscureText: isPassword,
              controller: controller,
              decoration: InputDecoration(
                labelText: labeledText,
                labelStyle: const TextStyle(
                  fontWeight: FontWeight.w300,
                  color: Color(0xFFBFBFBF),
                  fontSize: 20,
                ),
                hintText: hintText,
                hintStyle: const TextStyle(
                  fontFamily: "Avenir",
                  fontWeight: FontWeight.bold,
                  fontSize: 19,
                  color: Colors.black
                ),
                enabledBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.transparent),
                ),
                focusedBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFFAF3a42)),
                ),
                floatingLabelBehavior: FloatingLabelBehavior.always,
                contentPadding: const EdgeInsets.symmetric(vertical: 8),
              ),
            ),
          )
      ),
    );
  }
}
