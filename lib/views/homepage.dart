import 'package:flutter/material.dart';
import '../services/auth.dart';
import '../widgetGenerators/posts.dart';


class HomePage extends StatefulWidget {
  final Auth auth;

  const HomePage({Key? key, required this.auth}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFFAF3A42),
        child: const Icon(Icons.add),
        onPressed: () {},
      ),
      body: listOfPost()
    );
  }

  Widget listOfPost() {
    return Container(
      child: ListView.separated(
        itemBuilder: (BuildContext context, int index) {
          return posts[index];
        },
        separatorBuilder: (BuildContext context, int index) => Divider(
          height: 0,
        ),
        itemCount: posts.length,
      ),
    );
  }
}
