import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../services/database.dart';
import '../views/viewPost.dart';

class PostActions extends StatefulWidget {
  final BuildContext context;
  final bool hasLiked;
  final bool hasRePosted;
  final String authID;
  final String postID;
  final String comments;
  final String reposts;
  final String favorites;

  const PostActions({
    Key? key,
    required this.context,
    required this.postID,
    required this.authID,
    this.hasLiked = false,
    this.hasRePosted = false,
    required this.comments,
    required this.reposts,
    required this.favorites,
  }) : super(key: key);

  @override
  State<PostActions> createState() => _PostActionsState();
}

class _PostActionsState extends State<PostActions> {
  late Database _db;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _db = Database(authID: widget.authID);
  }

  @override
  Widget build(BuildContext context) {
    return PostButtons(context);
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
              child: PostIconButton(FontAwesomeIcons.comment, widget.comments, Colors.black45)
          ),
          GestureDetector(
            child: PostIconButton(
                repost,
                widget.reposts,
                repostColor
            ),
            onTap: () => widget.hasRePosted == true ? onUnRePost(repostColor) : _onRepostPressed(context, repostColor),
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

  // Undo the repost when post has already been reposted
  void onUnRePost(repostColor){

    setState(() {
      //Actively change the icon color
      repostColor = Colors.black45;

      // Remove the repost from the database
      _db.unRePost(postID: widget.postID);
    });

  }

  // Show pop up menu when the repost button is clicked
  void _onRepostPressed(BuildContext context, repostColor) {
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
