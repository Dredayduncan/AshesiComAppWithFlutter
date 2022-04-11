import 'package:ashesicom/common_widgets/customSearchBar.dart';
import 'package:ashesicom/widgetGenerators/posts.dart';
import 'package:flutter/material.dart';
import '../services/auth.dart';

class Messages extends StatelessWidget {
  final Auth auth;
  final TextEditingController controller = TextEditingController();

  Messages({Key? key, required this.auth}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:  messageList()//Column(
      //   children: [
      //     Padding(
      //       padding: const EdgeInsets.all(8.0),
      //       child: CustomSearchBar(
      //           controller: controller,
      //           hint: "Search Messages"
      //       ),
      //     ),
      //     messageList()
      //   ],
      // ),
    );
  }

  Widget messageList() {
    return Container(
      child: ListView.separated(
        itemBuilder: (BuildContext context, int index) {
          return messages[index];
        },
        separatorBuilder: (BuildContext context, int index) => Divider(
          height: 0,
        ),
        itemCount: messages.length,
      ),
    );
  }
}
