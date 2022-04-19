import 'dart:io';

import 'package:flutter/material.dart';

import '../services/database.dart';

class ViewPost extends StatefulWidget {
  final String postID;
  final String authID;

  const ViewPost({Key? key, required this.authID, required this.postID}) : super(key: key);

  @override
  State<ViewPost> createState() => _ViewPostState();
}

class _ViewPostState extends State<ViewPost> {
  TextEditingController _replyController = TextEditingController();
  late Database _db;
  late Map<String, dynamic>? postInfo;
  late Map<String, dynamic>? posterInfo;

  Widget _currentPage = const Scaffold(
    body: Center(
      child: CircularProgressIndicator(
        color: Color(0xFFAF3A42),
      ),
    ),
  );

  Future<void> getPostDetails () async {
    postInfo = await _db.getOnePost(postID: widget.postID);
    posterInfo = await _db.getUserInfo(uid: postInfo!['poster'].id);

    setState(() {
      _currentPage = _buildContent();
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _db = Database(authID: widget.authID);
    getPostDetails();
  }

  // var _image;
  @override
  Widget build(BuildContext context) {
    return _currentPage;
  }

  Widget _buildContent() {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Post",
          style: TextStyle(
              color: Colors.black
          ),
        ),
        iconTheme: const IconThemeData(
            color: Color(0xFFAF3A42)
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: const Color(0xFFD0BBC4),
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      margin: const EdgeInsets.all(10.0),
                      child: const CircleAvatar(
                        backgroundImage: AssetImage("assets/images/profile.jpeg"),
                      ),
                    ),
                    Column(
                      children: [
                        Text(
                          posterInfo!['displayName'],
                          style: const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '@${posterInfo!["username"]}',
                          style: const TextStyle(
                            color: Color(0xFF808083),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    '${postInfo!["text"]}',
                    style: const TextStyle(
                        fontSize: 20
                    ),
                  ),
                ),
                const SizedBox(width: 5.0,),
                postInfo!['image'] != null && postInfo!['image'] != "" ? Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                      alignment: Alignment.center,
                      child: Image.file(File(postInfo!['image']), fit: BoxFit.cover,)
                  ),
                ) : const SizedBox.shrink(),
              ],
            ),
          ),
        ),
      ),
      bottomSheet: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const CircleAvatar(
              radius: 15,
              backgroundImage: AssetImage("assets/images/profile.jpeg"),
            ),
            const SizedBox(width: 5.0,),
            Expanded(
                child: Container(
                  height: 30,
                  child: TextField(
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    cursorColor: const Color(0xFFAF3A42),
                    controller: _replyController,
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.transparent),
                        borderRadius: BorderRadius.circular(25.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.transparent),
                        borderRadius: BorderRadius.circular(25.0),
                      ),
                      filled: true,
                      contentPadding: const EdgeInsets.all(5),
                      hintStyle: const TextStyle(color: Color(0xFF808083)),
                      hintText: "Post your reply",
                      fillColor: Colors.white,
                    ),
                  ),
                )
            ),
          ],
        ),
      ),
    );
  }
}
