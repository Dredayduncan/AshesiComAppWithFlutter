import 'package:flutter/material.dart';

class CustomSubmitButton extends StatelessWidget {
  final String text;
  final Color color;
  final double borderRadius;
  final VoidCallback? onPressed;
  final double height;
  final Color textColor;

  const CustomSubmitButton({
    Key? key,
    required this.text,
    required this.onPressed,
    this.borderRadius = 16.0,
    this.height = 50.0,
    required this.color,
    required this.textColor
  })
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: ElevatedButton(
          child: Text(
            text,
            style: TextStyle(
                color: textColor,
                fontSize: 16.0
            ),
          ),
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
              fixedSize: const Size(360, 10),
              primary: color,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(borderRadius),
                  )
              )
          )
      ),
    );
  }
}