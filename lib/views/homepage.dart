import 'package:ashesicom/services/database.dart';
import 'package:ashesicom/views/newPost.dart';
import 'package:flutter/material.dart';
import '../services/auth.dart';


class HomePage extends StatefulWidget {
  final Auth auth;

  const HomePage({Key? key, required this.auth}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late List posts;
  late String userAviUser;
  late Database db;
  Widget _currentPage = const Scaffold(
    body: Center(
      child: CircularProgressIndicator(
        color: Color(0xFFAF3A42),
      ),
    ),
  );

  generatePosts() async {
    posts = await db.getFeed();
    Map<String, dynamic>? userInfo = await db.getUserInfo(uid: widget.auth.currentUser!.uid);
    userAviUser  = userInfo!['avi'];

    setState(() {
      _currentPage = _buildContent();
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    db = Database(authID: widget.auth.currentUser!.uid);
    generatePosts();

  }
  @override
  Widget build(BuildContext context) {
    return Center(
      child: _currentPage
    );
  }

  Widget _buildContent() {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFFAF3A42),
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => NewPost(image: userAviUser, authID: widget.auth.currentUser!.uid,))
          );
        },
      ),
      body: listOfPost(),
    );
  }

  Widget listOfPost() {
    return Container(
      child: ListView.separated(
        itemBuilder: (BuildContext context, int index) {
          return posts[index];
        },
        separatorBuilder: (BuildContext context, int index) => const Divider(
          height: 0,
        ),
        itemCount: posts.length,
      ),
    );
  }
}
