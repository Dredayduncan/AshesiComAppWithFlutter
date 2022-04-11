import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget {
  const CustomAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
        elevation: 0,
        toolbarHeight: 110,
        backgroundColor: const Color(0xFFAF3A42),
        title: Align(
          alignment:const Alignment(-1.5,0),
          child: Padding(
            padding: const EdgeInsets.only(top: 20),
            child:  Image.asset(
              "assets/images/ashesicom.png",
              height: 180,
              fit: BoxFit.cover,
            ),
          ),
        )
    );
  }
}
