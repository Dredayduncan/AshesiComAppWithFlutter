import 'package:flutter/material.dart';

class CustomText extends StatelessWidget {
  String? msg;
  TextStyle? style;
  TextAlign textAlign;
  int? maxLines;
  bool softwrap;
  TextOverflow overflow;


  CustomText({Key? key,
    String? this.msg,
    TextStyle? this.style,
    TextAlign this.textAlign = TextAlign.justify,
    TextOverflow this.overflow = TextOverflow.visible,
    bool this.softwrap = true,
    int? this.maxLines,}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    if (msg == null) {
      return const SizedBox(
        height: 0,
        width: 0,
      );
    } else {
      // if (style != null) {
      //   var fontSize =
      //       style?.fontSize ?? Theme.of(context).textTheme.bodyText1!.fontSize;
      //   style = style?.copyWith(
      //     fontSize: fontSize! - (context.size!.width <= 375 ? 2 : 0),
      //   );
      // }
      return Text(
        msg!,
        style: style,
        textAlign: textAlign,
        overflow: overflow,
        softWrap: softwrap,
        key: key,
        maxLines: maxLines,
      );
    }
  }
}
