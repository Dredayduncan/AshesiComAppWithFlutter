import 'package:flutter/material.dart';

class RippleButton extends StatelessWidget {
  final Widget child;
  final VoidCallback onPressed;
  final BorderRadius borderRadius;
  final Color? splashColor;

  const RippleButton({
    Key? key,
    required this.child,
    required this.onPressed,
    required this.borderRadius,
    this.splashColor}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        child,
        Positioned(
          left: 0,
          right: 0,
          top: 0,
          bottom: 0,
          child: TextButton(
              style: ButtonStyle(
                shape: MaterialStateProperty.all(
                    RoundedRectangleBorder(borderRadius: borderRadius)),
                foregroundColor: MaterialStateProperty.all(splashColor),
              ),
              onPressed: onPressed,
              child: Container()),
        )
      ],
    );
  }
}
