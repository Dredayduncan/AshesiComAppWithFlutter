import 'dart:io';

import 'package:ashesicom/common_widgets/postActions.dart';
import 'package:ashesicom/common_widgets/rippleButton.dart';
import 'package:ashesicom/services/database.dart';
import 'package:ashesicom/views/profile.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../views/viewPost.dart';

class Post extends StatefulWidget {
  final String avatar;
  final String username;
  final String name;
  final String timeAgo;
  final String text;
  final String comments;
  final String reposts;
  final String favorites;
  final String? media;
  final String authID;
  final String postID;
  bool hasRePosted;
  bool hasLiked;
  final String uid;
  final String location;

  Post(
      {Key? key,
        required this.postID,
        required this.authID,
        required this.uid,
        required this.avatar,
        required this.username,
        required this.name,
        required this.timeAgo,
        required this.text,
        this.media,
        required this.location,
        required this.comments,
        required this.reposts,
        required this.favorites,
        this.hasLiked = false,
        this.hasRePosted = false
      })
      : super(key: key);

  @override
  State<Post> createState() => _PostState();
}

class _PostState extends State<Post> {
  late Database _db;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _db = Database(authID: widget.authID);
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFD0BBC4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          PostAvatar(context),
          PostBody(context),
        ],
      ),
    );
  }

  Widget PostAvatar(context) {
    return RippleButton(
      onPressed: () {
        Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Profile(authID: widget.authID, uid: widget.uid,))
        );
      },
      borderRadius: BorderRadius.circular(28),
      child: Container(
        margin: const EdgeInsets.all(10.0),
        child: CircleAvatar(
          backgroundImage: widget.avatar == ""
              ? const AssetImage("assets/images/AshLogo.jpg")
              :Image.file(
            File(widget.avatar),
            fit: BoxFit.cover,
          ).image
        ),
      ),
    );
  }

  Widget PostBody(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          PostHeader(),
          GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ViewPost(
                    authID: widget.authID,
                    postID: widget.postID,
                    comments: widget.comments,
                    reposts: widget.reposts,
                    favorites: widget.favorites,
                    hasLiked: widget.hasLiked,
                    hasRePosted: widget.hasRePosted,
                  )
                  )
              );
            },
            child: PostText()
          ),
          widget.media != null && widget.media != "" ? Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              alignment: Alignment.center,
              child: Image.file(File(widget.media!), fit: BoxFit.cover,)
            ),
          ) : const SizedBox.shrink(),
          // PostButtons(context),
          PostActions(
            context: context,
            postID: widget.postID,
            authID: widget.authID,
            comments: widget.comments,
            reposts: widget.reposts,
            favorites: widget.favorites,
            hasRePosted: widget.hasRePosted,
            hasLiked: widget.hasLiked,
          )
        ],
      ),
    );
  }

  Widget PostHeader() {
    return Row(
      children: [
        Container(
          margin: const EdgeInsets.only(right: 5.0),
          child: Text(
            widget.name,
            style: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Text(
          '@${widget.username} · ${widget.timeAgo}',
          style: const TextStyle(
            color: Color(0xFF808083),
          ),
        ),
        // const Spacer(),
        // IconButton(
        //   icon: Icon(
        //     FontAwesomeIcons.angleDown,
        //     size: 14.0,
        //     color: Colors.grey,
        //   ),
        //   onPressed: () {},
        // ),
      ],
    );
  }

  Widget PostText() {
    return Row(
      children: [
        Text(
          widget.text,
          overflow: TextOverflow.clip,
        ),
        Text(
          ' - ${widget.location}',
          style: TextStyle(
            fontSize: 10,
            color: const Color(0xFF808083)
          ),
        )
      ],
    );
  }
}