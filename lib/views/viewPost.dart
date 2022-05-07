import 'dart:io';

import 'package:ashesicom/common_widgets/postActions.dart';
import 'package:flutter/material.dart';

import '../services/database.dart';

class ViewPost extends StatefulWidget {
  final String postID;
  final String authID;
  final bool hasLiked;
  final bool hasRePosted;
  final String comments;
  final String reposts;
  final String favorites;

  const ViewPost({
    Key? key,
    required this.authID,
    required this.postID,
    this.hasLiked = false,
    this.hasRePosted = false,
    required this.comments,
    required this.reposts,
    required this.favorites,

  }) : super(key: key);

  @override
  State<ViewPost> createState() => _ViewPostState();
}

class _ViewPostState extends State<ViewPost> {
  TextEditingController _replyController = TextEditingController();
  late Database _db;
  late Map<String, dynamic>? postInfo;
  late Map<String, dynamic>? posterInfo;
  late Map<String, dynamic>? userInfo;
  late List comments;

  Widget _currentPage = const Scaffold(
    body: Center(
      child: CircularProgressIndicator(
        color: Color(0xFFAF3A42),
      ),
    ),
  );

  Future<void> getPostDetails() async {
    postInfo = await _db.getOnePost(postID: widget.postID);
    posterInfo = await _db.getUserInfo(uid: postInfo!['poster'].id);
    userInfo = await _db.getUserInfo(uid: widget.authID);
    comments = await _db.getPostComments(postID: widget.postID);

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
      body: SingleChildScrollView(
        child: Column(
          children: [
            postBody(),
            listOfComments()
          ],
        ),
      ),
      bottomSheet: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 15,
              backgroundImage: userInfo!['avi'] == ""
                  ? const AssetImage("assets/images/AshLogo.jpg")
                  :Image.file(
                File(userInfo!['avi']),
                fit: BoxFit.cover,
              ).image,
            ),
            const SizedBox(width: 5.0,),
            Expanded(
                child: Container(
                  height: 30,
                  child: TextField(
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    textInputAction: TextInputAction.send,
                    onSubmitted: (value) {
                      _db.comment(
                        poster: widget.authID,
                        text: value,
                        mainPostID: postInfo!['postID']
                      ).then((value) {
                        if (value){
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: const Text('Your comment has been sent!'),
                              action: SnackBarAction(
                                label: 'Dismiss',
                                onPressed: () {
                                  ScaffoldMessenger.of(context).hideCurrentSnackBar();
                                },
                              ),
                            ),
                          );

                          setState(() {
                            _replyController.clear();
                            getPostDetails();
                          });
                        }
                        else{
                          return ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: const Text('Your comment could not be sent!'),
                              action: SnackBarAction(
                                label: 'Dismiss',
                                onPressed: () {
                                  ScaffoldMessenger.of(context).hideCurrentSnackBar();
                                },
                              ),
                            ),
                          );
                        }
                      });
                    },
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

  Widget postBody(){
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                margin: const EdgeInsets.all(10.0),
                child: CircleAvatar(
                  backgroundImage: posterInfo!['avi'] == ""
                      ? const AssetImage("assets/images/AshLogo.jpg")
                      :Image.file(
                    File(posterInfo!['avi']),
                    fit: BoxFit.cover,
                  ).image,
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
                height: 300,
                alignment: Alignment.center,
                child: Image.file(File(postInfo!['image']), fit: BoxFit.cover,)
            ),
          ) : const SizedBox.shrink(),
          const SizedBox(width: 5.0,),
          Padding(
            padding: const EdgeInsets.only(left: 40.0),
            child: PostActions(
              context: context,
              postID: widget.postID,
              authID: widget.authID,
              comments: widget.comments,
              reposts: widget.reposts,
              favorites: widget.favorites,
              hasLiked: widget.hasLiked,
              hasRePosted: widget.hasRePosted,
            ),
          ),
        ],
      ),
    );
  }

  Widget listOfComments() {
    return comments.isEmpty ? Container() : Container(
      child: ListView.separated(
        shrinkWrap: true,
        itemBuilder: (BuildContext context, int index) {
          return comments[index];
        },
        separatorBuilder: (BuildContext context, int index) => const Divider(
          height: 0,
        ),
        itemCount: comments.length,
      ),
    );
  }
}
