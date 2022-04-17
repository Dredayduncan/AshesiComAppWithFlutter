import 'package:firebase_database/firebase_database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../common_widgets/post.dart';

class Database {
  final String authID;

  Database({required this.authID});

  // Get the user's timeline
  Future<List> getFeed() async {
    return [];
  }

  // Get a list of people the user is following
  Future<List<dynamic>?> getListOfFollowing({uid}) async {
    // Get the data from the database
    QuerySnapshot<Map<String, dynamic>> query = await FirebaseFirestore.instance
        .collection("Follow")
        .get();

    var totalFollowing = [];

    // Get the following data
    var following = query.docs.map((data) => data.data());

    // Loop through the data to count the number of people the user is following
    for (var element in following) {

      if (element["following"] != null && element["following"].id == uid) {
        // Increment total if found
        totalFollowing.add(element["following"].id);
      }
    }

    return totalFollowing;
  }

  // USER FUNCTIONS

  // Make a post
  
  // follow a given user
  
  // Retweet a given post
  
  // Like a given post
  
  // Comment on a given post

  // Check if user is following another user
  // Future<bool> isFollowing({currentUserID, otherUserID}) async {
  //
  // }

  // Get user's messages

  // Get user's info
  Future<Map<String, dynamic>?> getUserInfo({uid}) async {
    // Get the data from the database
    DocumentSnapshot<Map<String, dynamic>> query = await FirebaseFirestore.instance
        .collection("Users")
        .doc(uid)
        .get();

    // Get the user's data
    var data = query.data();

    return data;
  }
  
  // Get the user's following number
  Future<int> getUserFollowingNumber({uid}) async {
    // Get the data from the database
    QuerySnapshot<Map<String, dynamic>> query = await FirebaseFirestore.instance
      .collection("Follow")
      .get();

    int totalFollowing = 0;

    // Get the following data
    var following = query.docs.map((data) => data.data());

    // Loop through the data to count the number of people the user is following
    for (var element in following) {

      if (element["following"] != null && element["following"].id == uid) {
        // Increment total if found
        totalFollowing += 1;
      }
    }

    return totalFollowing;
  }
  
  // Get the user's follower number
  Future<int> getUserFollowerNumber({uid}) async {
    // Get the data from the database
    QuerySnapshot<Map<String, dynamic>> query = await FirebaseFirestore.instance
        .collection("Follow")
        .get();

    int totalFollowers = 0;

    // Get the following data
    var following = query.docs.map((data) => data.data());

    // Loop through the data to count the number of people the user is following
    for (var element in following) {

      if (element["followed"] != null && element["followed"].id == uid) {
        // Increment total if found
        totalFollowers += 1;
      }
    }

    return totalFollowers;
  }
  
  // Get the user's posts
  Future<List> getUserPosts({uid}) async {
    // Get the data from the database
    QuerySnapshot<Map<String, dynamic>> query = await FirebaseFirestore.instance
        .collection("Posts")
        .get();

    // get the user
    Map<String, dynamic>? userInfo = await getUserInfo(uid: uid);

    // Get the user's posts
    var posts = query.docs.map((data) => data.data());

    final allPosts = [];

    // Loop through the data to count the number of people the user is following
    for (var post in posts) {
      if (post["poster"].id == uid) {

        // Get the number of comments, likes and reposts on the post
        int comments = await getNumberOfComments(postID :post["postID"]);
        int likes = await getNumberOfLikes(postID :post["postID"]);
        int reposts = await getNumberOfRePosts(postID :post["postID"]);

        // Add to posts if found
        allPosts.add(
          Post(
            authID: authID,
            avatar: 'https://pbs.twimg.com/profile_images/1187814172307800064/MhnwJbxw_400x400.jpg',
            username: uid,
            name: userInfo!['displayName'],
            timeAgo: post['timePosted'],
            text: post['text'],
            comments: comments.toString(),
            reposts: reposts.toString(),
            favorites: likes.toString(),
          )
        );
      }
    }

    return allPosts;
  }

  // Get the user's posts with media
  Future<List> getUserPostsWithMedia({uid}) async {
    // Get the data from the database
    QuerySnapshot<Map<String, dynamic>> query = await FirebaseFirestore.instance
        .collection("Posts")
        .get();

    // get the user
    Map<String, dynamic>? userInfo = await getUserInfo(uid: uid);

    // Get the user's posts
    var posts = query.docs.map((data) => data.data());

    final allPostsWithMedia = [];

    // Loop through the data to count the number of people the user is following
    for (var post in posts) {
      if (post["poster"].id == uid && post['image'] != "") {

        // Get the number of comments, likes and reposts on the post
        int comments = await getNumberOfComments(postID :post["postID"]);
        int likes = await getNumberOfLikes(postID :post["postID"]);
        int reposts = await getNumberOfRePosts(postID :post["postID"]);

        // Increment total if found
        allPostsWithMedia.add(
            Post(
              authID: authID,
              avatar: 'https://pbs.twimg.com/profile_images/1187814172307800064/MhnwJbxw_400x400.jpg',
              username: uid,
              name: userInfo!['displayName'],
              timeAgo: post['timePosted'],
              text: post['text'],
              comments: comments.toString(),
              reposts: reposts.toString(),
              favorites: likes.toString(),
            )
        );
      }
    }

    return allPostsWithMedia;
  }

  // Get a single post
  Future<Map<String, dynamic>?> getOnePost({postID}) async {
    // Get the data from the database
    DocumentSnapshot<Map<String, dynamic>> query = await FirebaseFirestore.instance
        .collection("Posts")
        .doc(postID)
        .get();

    // Get the post details
    var post = query.data();

    return post;
  }
  
  // Get the user's reposts
  Future<List> getUserReposts({uid}) async {
    // Get the data from the database
    QuerySnapshot<Map<String, dynamic>> query = await FirebaseFirestore.instance
        .collection("Reposts")
        .get();

    // Get the user's posts
    var posts = query.docs.map((data) => data.data());

    final allReposts = [];

    // Loop through the data to count the number of people the user is following
    for (var post in posts) {
      if (post["rePoster"].id == uid) {

        // Get the post details
        Map<String, dynamic>? item = await getOnePost(postID: post["postID"]);

        //Get poster details
        Map<String, dynamic>? posterInfo = await getUserInfo(uid: item!['username']);

        // Get the number of comments, likes and reposts on the post
        int comments = await getNumberOfComments(postID :post["postID"]);
        int likes = await getNumberOfLikes(postID :post["postID"]);
        int reposts = await getNumberOfRePosts(postID :post["postID"]);


        // Increment total if found
        allReposts.add(
            Post(
              authID: authID,
              avatar: 'https://pbs.twimg.com/profile_images/1187814172307800064/MhnwJbxw_400x400.jpg',
              username: item['username'],
              name: posterInfo!['displayName'],
              timeAgo: item['timePosted'],
              text: item['text'],
              comments: comments.toString(),
              reposts: reposts.toString(),
              favorites: likes.toString(),
            )
        );
      }
    }

    return allReposts;
  }
  
  // Get the posts a user has liked
  Future<List> getUserLikedPosts({uid}) async {
    // Get the data from the database
    QuerySnapshot<Map<String, dynamic>> query = await FirebaseFirestore.instance
        .collection("Likes")
        .get();

    // Get the user's posts
    var posts = query.docs.map((data) => data.data());

    final allLikes = [];

    // Loop through the data to count the number of people the user is following
    for (var post in posts) {
      if (post["liker"].id == uid) {

        // Get the post details
        Map<String, dynamic>? item = await getOnePost(postID: post["postID"]);

        //Get poster details
        Map<String, dynamic>? posterInfo = await getUserInfo(uid: item!['username']);

        // Get the number of comments, likes and reposts on the post
        int comments = await getNumberOfComments(postID :post["postID"]);
        int likes = await getNumberOfLikes(postID :post["postID"]);
        int reposts = await getNumberOfRePosts(postID :post["postID"]);


        // Increment total if found
        allLikes.add(
            Post(
              authID: authID,
              avatar: 'https://pbs.twimg.com/profile_images/1187814172307800064/MhnwJbxw_400x400.jpg',
              username: item['username'],
              name: posterInfo!['displayName'],
              timeAgo: item['timePosted'],
              text: item['text'],
              comments: comments.toString(),
              reposts: reposts.toString(),
              favorites: likes.toString(),
            )
        );
      }
    }

    return allLikes;
  }

  // FOR TWEETS
  //Get the comments under a post
  Future<List> getPostComments({postID}) async {
    // Get the data from the database
    QuerySnapshot<Map<String, dynamic>> query = await FirebaseFirestore.instance
        .collection("Comments")
        .get();

    // Get the user's posts
    var posts = query.docs.map((data) => data.data());

    final allComments = [];

    // Loop through the data to get the comments under the post
    for (var post in posts) {
      if (post["mainPostID"].id == postID) {

        // Get the post details
        Map<String, dynamic>? item = await getOnePost(postID: post["commentPostID"]);

        //Get poster details
        Map<String, dynamic>? posterInfo = await getUserInfo(uid: item!['username']);

        // Get the number of comments, likes and reposts on the post
        int comments = await getNumberOfComments(postID :post["commentPostID"]);
        int likes = await getNumberOfLikes(postID :post["commentPostID"]);
        int reposts = await getNumberOfRePosts(postID :post["commentPostID"]);


        // Increment total if found
        allComments.add(
            Post(
              authID: authID,
              avatar: 'https://pbs.twimg.com/profile_images/1187814172307800064/MhnwJbxw_400x400.jpg',
              username: item['username'],
              name: posterInfo!['displayName'],
              timeAgo: item['timePosted'],
              text: item['text'],
              comments: comments.toString(),
              reposts: reposts.toString(),
              favorites: likes.toString(),
            )
        );
      }
    }

    return allComments;
  }

  // Get the number comments on a post
  Future<int> getNumberOfComments({postID}) async {
    // Get the data from the database
    QuerySnapshot<Map<String, dynamic>> query = await FirebaseFirestore.instance
        .collection("Comments")
        .get();

    // Get the user's posts
    var posts = query.docs.map((data) => data.data());

    int numComments = 0;

    // Loop through the data to count the number of reposts
    for (var post in posts) {
      if (post["mainPostID"].id == postID) {
        numComments += 1;
      }
    }

    return numComments;
  }

  // Get the number of retweets on a post
  Future<int> getNumberOfRePosts({postID}) async {
    // Get the data from the database
    QuerySnapshot<Map<String, dynamic>> query = await FirebaseFirestore.instance
        .collection("Reposts")
        .get();

    // Get the user's posts
    var posts = query.docs.map((data) => data.data());

    int numRePosts = 0;

    // Loop through the data to count the number of reposts
    for (var post in posts) {
      if (post["postID"].id == postID) {
        numRePosts += 1;
      }
    }

    return numRePosts;
  }

  // Get the number of likes on a post
  Future<int> getNumberOfLikes({postID}) async {
    // Get the data from the database
    QuerySnapshot<Map<String, dynamic>> query = await FirebaseFirestore.instance
        .collection("Likes")
        .get();

    // Get the user's posts
    var posts = query.docs.map((data) => data.data());

    int numLikes = 0;

    // Loop through the data to count the number of likes on the post
    for (var post in posts) {
      if (post["postID"].id == postID) {
        numLikes += 1;
      }
    }

    return numLikes;
  }


  // PROFILE UPDATE
  //Insert a new user into the database
  Future<void> userSignUp({uid, displayName, contact, email, bio, banner, avi}) async {
    DatabaseReference ref = FirebaseDatabase.instance.ref("Users/$uid");

    await ref.set({
      "displayName": displayName,
      "email": email,
      "contact": contact,
      "height": "",
      "weight": "",
      "goal": "",
      "picture": ""
    });

  }

  // Update a user's information when they save their profile
  Future<void> userProfileUpdate({uid, displayName, bio, avi, banner}) async {
    DatabaseReference ref = FirebaseDatabase.instance.ref("Users/$uid");

    await ref.update({
      "displayName": displayName,
      "bio": bio,
      "avi": avi,
      "banner": banner,
    });
  }

}