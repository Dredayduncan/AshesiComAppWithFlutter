import "package:flutter/material.dart";

class CustomProfileTextField extends StatelessWidget {
  String label;
  String? value;
  bool? isContact = false;
  TextEditingController controller;

  CustomProfileTextField({
    Key? key,
    required this.label,
    required this.controller,
    this.isContact,
    this.value})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8.0, top: 15.0),
          child: Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.bold
            ),
          ),
        ),
        const SizedBox(width: 10.0,),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(right: 10.0, top: 15.0),
            child: TextField(
              maxLength: isContact == true
                  ? 10
                  : null,
              cursorColor: const Color(0xFFAF3A42),
              style: const TextStyle(
                color: Color(0xFFCB6E74),
              ),
              keyboardType: isContact == true
                  ? TextInputType.number
                  :TextInputType.multiline,
              maxLines: null,
              controller: controller,
              decoration: const InputDecoration(
                border: InputBorder.none,
              )
            ),
          ),
        )
      ],
    );
  }
}
