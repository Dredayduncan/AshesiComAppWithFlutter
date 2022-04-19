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
  final String uid;

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
                  MaterialPageRoute(builder: (context) => ViewPost(authID: widget.authID, postID: widget.postID,))
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
    return Text(
      widget.text,
      overflow: TextOverflow.clip,
    );
  }

  Widget PostButtons(BuildContext context) {
    //Standard like button
    var favorite = FontAwesomeIcons.heart;
    var favColor = Colors.black45;

    // Standard repost button
    var repost = FontAwesomeIcons.retweet;
    var repostColor = Colors.black45;

    //Check if the user has liked this post
    if (widget.hasLiked){
      favorite = FontAwesomeIcons.solidHeart;
      favColor = const Color(0xFFCB6E74);
    }

    // Check if the user has reposted this post
    if (widget.hasRePosted){
      repostColor = const Color(0xFFCB6E74);
    }

    return Container(
      margin: const EdgeInsets.only(top: 10.0, right: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ViewPost(authID: widget.authID, postID: widget.postID,))
              );
            },
            child: PostIconButton(FontAwesomeIcons.comment, widget.comments, Colors.black45)
          ),
          GestureDetector(
            child: PostIconButton(
              repost,
              widget.reposts,
              repostColor
            ),
            onTap: () => widget.hasRePosted == true ? _db.unRePost(postID: widget.postID) : _onRepostPressed(context),
          ),
          GestureDetector(
            child: PostIconButton(
              favorite,
              widget.favorites,
              favColor
            ),
            onTap: () => widget.hasLiked == true ? _db.unlike(postID: widget.postID) : _db.like(postID: widget.postID),
          ),
          PostIconButton(FontAwesomeIcons.share, '', Colors.black45),
        ],
      ),
    );
  }

  Widget PostIconButton(IconData icon, String text, iconColor) {
    return Row(
      children: [
        Icon(
          text == "" ? null : icon,
          size: 16.0,
          color: iconColor,
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
            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}