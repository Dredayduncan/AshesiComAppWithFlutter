import 'dart:io';

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

  Post(
      {Key? key,
        required this.postID,
        required this.authID,
        required this.avatar,
        required this.username,
        required this.name,
        required this.timeAgo,
        required this.text,
        this.media,
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
    _db = Database(authID: "dreday");
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
            MaterialPageRoute(builder: (context) => Profile(authID: widget.authID, uid: widget.username,))
        );
      },
      borderRadius: BorderRadius.circular(28),
      child: Container(
        margin: const EdgeInsets.all(10.0),
        child: CircleAvatar(
          backgroundImage: NetworkImage(widget.avatar),
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
                  MaterialPageRoute(builder: (context) => const ViewPost())
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
          PostButtons(context),
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
            this.widget.name,
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
    return Text(
      widget.text,
      overflow: TextOverflow.clip,
    );
  }

  Widget PostButtons(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 10.0, right: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ViewPost())
              );
            },
            child: PostIconButton(FontAwesomeIcons.comment, widget.comments)
          ),
          GestureDetector(
            child: PostIconButton(
              FontAwesomeIcons.retweet,
              widget.reposts
            ),
            onTap: () => _onRepostPressed(context),
          ),
          GestureDetector(
            child: PostIconButton(
              FontAwesomeIcons.heart,
              widget.favorites
            ),
            onTap: () => _db.like(postID: widget.postID),
          ),
          PostIconButton(FontAwesomeIcons.share, ''),
        ],
      ),
    );
  }

  Widget PostIconButton(IconData icon, String text) {
    return Row(
      children: [
        Icon(
          text == "" ? null : icon,
          size: 16.0,
          color: Colors.black45,
        ),
        Container(
          margin: const EdgeInsets.all(6.0),
          child: Text(
            text,
            style: const TextStyle(
              color: Colors.black45,
              fontSize: 14.0,
            ),
          ),
        ),
      ],
    );
  }

  void _onRepostPressed(BuildContext context) {
    showModalBottomSheet(context: context, builder: (context){
      return Container(
        height: 100,
        color: const Color(0xFF737373),
        child: Container(
          child: _buildRepostModal(),
          decoration: const BoxDecoration(
              color: Color(0xFFD0BBC4),
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10.0),
                  topRight: Radius.circular(10.0)
              )
          ),
        ),

      );
    });
  }

  Column _buildRepostModal(){
    return Column(
      children: [
        ListTile(
          leading: const Icon(FontAwesomeIcons.retweet),
          title: const Text("Repost"),
          onTap: (){
            _db.rePost(postID: widget.postID);
          },
        ),
      ],
    );
  }
}