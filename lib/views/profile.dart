import 'dart:io';

import 'package:ashesicom/services/database.dart';
import 'package:ashesicom/views/editProfile.dart';
import 'package:flutter/material.dart';
import '../services/auth.dart';

class Profile extends StatefulWidget {
  final String uid;
  final String authID;

  const Profile({Key? key, required this.authID, required this.uid}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> with TickerProviderStateMixin {
  late TabController _tabController;
  late Database db;
  int following = 0;
  int followers = 0;
  late String displayName;
  late String bio;
  late String avi;
  late String banner;
  late String username;
  late List posts;
  late List rePosts;
  late List likedPosts;
  late List postsWithMedia;
  late bool isFollowing;

  Widget _currentPage = const Scaffold(
    body: Center(
      child: CircularProgressIndicator(
        color: Color(0xFFAF3A42),
      ),
    ),
  );


  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    db = Database(authID: widget.authID);
    getProfileData();
  }

  Future<void> getProfileData() async {
    following = await db.getUserFollowingNumber(uid: widget.uid);
    followers = await db.getUserFollowerNumber(uid: widget.uid);
    Map<String, dynamic>? userInfo = await db.getUserInfo(uid: widget.uid);
    posts = await db.getUserPosts(uid: widget.uid);
    rePosts = await db.getUserReposts(uid: widget.uid);
    likedPosts = await db.getUserLikedPosts(uid: widget.uid);
    postsWithMedia = await db.getUserPostsWithMedia(uid: widget.uid);

    // Check if the user is following this account
    isFollowing = await db.isFollowing(currentUserID: widget.authID, otherUserID: widget.uid);


    setState(() {
      displayName = userInfo!['displayName'];
      bio = userInfo['bio'];
      avi = userInfo['avi'];
      banner = userInfo['banner'];
      username = userInfo['username'];
      _currentPage = _buildContent();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: _currentPage
    );
  }

  Widget _buildContent(){
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          toolbarHeight: 100,
          flexibleSpace: Image(
            image: banner == ""
            ? const AssetImage("assets/images/ashHead.jpeg")
            : Image.file(
              File(banner),
              fit: BoxFit.cover,
            ).image,
          ),
          automaticallyImplyLeading: false,
          leading: widget.authID != widget.uid
            ? Padding(
            padding: const EdgeInsets.only(bottom: 60.0),
            child: IconButton(
              icon: const CircleAvatar(
                  backgroundColor: Color(0xFFAF3A42),
                  radius: 15,
                  child: Padding(
                    padding: EdgeInsets.only(left: 8.0),
                    child: Icon(
                      Icons.arrow_back_ios,
                      size: 18,
                    ),
                  )),
              onPressed: () {
                setState(() {
                  Navigator.of(context).pop();
                });
              },
            ),
          )
          : null,
        ),
        floatingActionButton: Container(
          height: 80,
          child: FittedBox(
            child: FloatingActionButton(
              backgroundColor: const Color(0xFFD0BBC4),
              elevation: 0,
              onPressed: (){},
              child: CircleAvatar(
                radius: 25,
                backgroundImage: avi == ""
                  ? const AssetImage("assets/images/AshLogo.jpg")
                  :Image.file(
                    File(avi),
                    fit: BoxFit.cover,
                  ).image,
              ),
            ),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Align(
                    alignment: Alignment.topLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 40.0, left: 20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            displayName,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 22
                            ),
                          ),
                          Text(
                            "@$username",
                            style: const TextStyle(
                                color: Color(0xFF808083),
                                fontSize: 16
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  Align(
                    alignment: Alignment.topRight,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: widget.authID == widget.uid ? ElevatedButton(
                        child: const Text(
                          "Edit Profile",
                          style: TextStyle(
                              color: Color(0xFFAF3A42)
                          ),
                        ),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => EditProfile(
                                authID: widget.authID,
                                displayName: displayName,
                                bio: bio,
                                avi: avi,
                                banner: banner,
                              ))
                          );
                        },
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                              const Color(0xFFD0BBC4)
                          ),
                          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18.0),
                                  side: const BorderSide(color: Color(0xFFAF3A42)
                                  )
                              )
                          ),
                        ),
                      ) : followButton(),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20.0, top: 8.0),
              child: Text(
                  bio
                // "Digital Goodies Team - Web & Mobile UI/UX development; Graphics; Illustrations",
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20.0, top: 8.0),
              child: Row(
                children: const [
                  Icon(
                    Icons.calendar_today_outlined,
                    size: 15,
                    color: Color(0xFF808083),
                  ),
                  SizedBox(width: 3,),
                  Text(
                    "Joined September 2018",
                    style: TextStyle(
                        color: Color(0xFF808083)
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20.0, top: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        following.toString(),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 3.0,),
                      const Text(
                        "Following",
                        style: TextStyle(
                            color: Color(0xFF808083)
                        ),
                      )
                    ],
                  ),
                  const SizedBox(width: 5,),
                  Row(
                    children: [
                      Text(
                        followers.toString(),
                        style: const TextStyle(
                            fontWeight: FontWeight.bold
                        ),
                      ),
                      const SizedBox(width: 3.0,),
                      const Text(
                        "Followers",
                        style: TextStyle(
                            color: Color(0xFF808083)
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    TabBar(
                      controller: _tabController,
                      indicatorColor: const Color(0xFFAF3A42),
                      labelColor: const Color(0xFFAF3A42),
                      unselectedLabelColor: const Color(0xFF808083),
                      tabs: const [
                        Tab(
                          child: Text(
                            "Post",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 10
                            ),
                          ),

                        ),
                        Tab(
                          child: Text(
                            "Reposts",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 10
                            ),
                          ),
                        ),
                        Tab(
                          child: Text(
                            "Media",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 10
                            ),
                          ),
                        ),
                        Tab(
                          child: Text(
                            "Likes",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 10
                            ),
                          ),
                        )
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        height: MediaQuery.of(context).size.height - 403.2,
                        width: MediaQuery.of(context).size.width -2,
                        child: TabBarView(
                            controller: _tabController,
                            children: [
                              posts.isNotEmpty
                                ? generatePosts()
                                : const Center(child: Text("No Posts")
                              ),
                              rePosts.isNotEmpty
                                ? generateRePosts()
                                : const Center(child: Text("No Reposts")
                              ),
                              postsWithMedia.isNotEmpty
                                  ? generatePostsWithMedia()
                                  : const Center(child: Text("No Posts With Media")
                              ),
                              likedPosts.isNotEmpty
                                  ? generateLikedPosts()
                                  : const Center(child: Text("No Liked Posts")
                              ),
                            ]
                        ),
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        )
    );
  }

  //Get the user's posts
  Widget generatePosts(){
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

  //Get the user's reposts
  Widget generateRePosts(){
    return Container(
      child: ListView.separated(
        itemBuilder: (BuildContext context, int index) {
          return rePosts[index];
        },
        separatorBuilder: (BuildContext context, int index) => const Divider(
          height: 0,
        ),
        itemCount: rePosts.length,
      ),
    );
  }

  // Get the posts the user has liked
  Widget generateLikedPosts(){
    return Container(
      child: ListView.separated(
        itemBuilder: (BuildContext context, int index) {
          return likedPosts[index];
        },
        separatorBuilder: (BuildContext context, int index) => const Divider(
          height: 0,
        ),
        itemCount: likedPosts.length,
      ),
    );
  }

  // Get the user's posts which contain media
  Widget generatePostsWithMedia(){
    return Container(
      child: ListView.separated(
        itemBuilder: (BuildContext context, int index) {
          return postsWithMedia[index];
        },
        separatorBuilder: (BuildContext context, int index) => const Divider(
          height: 0,
        ),
        itemCount: postsWithMedia.length,
      ),
    );
  }

  Widget followButton() {
    if (isFollowing == true){
      return ElevatedButton(
        child: const Text(
          "Following",
          style: TextStyle(
              color: Color(0xFFAF3A42)
          ),
        ),
        onPressed: () {
          db.unfollow(uid: widget.uid);
        },
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(
              const Color(0xFFD0BBC4)
          ),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18.0),
                  side: const BorderSide(color: Color(0xFFAF3A42)
                  )
              )
          ),
        ),
      );
    }
    else {
      return ElevatedButton(
        child: const Text(
          "Follow",
          style: TextStyle(
              color: Colors.white
          ),
        ),
        onPressed: () {
          db.follow(uid: widget.uid);
        },
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(
              const Color(0xFFAF3A42)
          ),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18.0),
                  // side: const BorderSide(color: Color(0xFFAF3A42)
                  // )
              )
          ),
        ),
      );
    }
  }
}
