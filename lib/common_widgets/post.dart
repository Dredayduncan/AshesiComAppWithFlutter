import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../views/viewPost.dart';

class Post extends StatelessWidget {
  final String avatar;
  final String username;
  final String name;
  final String timeAgo;
  final String text;
  final String comments;
  final String reposts;
  final String favorites;
  final String? media;

  const Post(
      {Key? key,
        required this.avatar,
        required this.username,
        required this.name,
        required this.timeAgo,
        required this.text,
        this.media,
        required this.comments,
        required this.reposts,
        required this.favorites})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFD0BBC4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          PostAvatar(),
          PostBody(context),
        ],
      ),
    );
  }

  Widget PostAvatar() {
    return Container(
      margin: const EdgeInsets.all(10.0),
      child: CircleAvatar(
        backgroundImage: NetworkImage(avatar),
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
            this.username,
            style: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Text(
          '@$name · $timeAgo',
          style: const TextStyle(
            color: Color(0xFF808083),
          ),
        ),
        const Spacer(),
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
      text,
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
            child: PostIconButton(FontAwesomeIcons.comment, comments)
          ),
          GestureDetector(
            child: PostIconButton(
              FontAwesomeIcons.retweet, 
              reposts
            ),
            onTap: () => _onRepostPressed(context),
          ),
          PostIconButton(FontAwesomeIcons.heart, favorites),
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
          // onPressed: (){},
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
          leading: Icon(FontAwesomeIcons.retweet),
          title: Text("Repost"),
          onTap: (){},
        ),
      ],
    );
  }


}