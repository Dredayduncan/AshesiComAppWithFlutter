import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:ashesicom/common_widgets/message.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../common_widgets/post.dart';

class Database {
  final String authID;

  Database({required this.authID});

  // Get the user's timeline
  Future<List> getFeed() async {
    // List the user's posts and posts of the people the user follows
    List posts = await getUserPosts(uid: authID);

    //Get all the people the user is following
    return FirebaseFirestore.instance.collection("Follow").get().then((value) async {
      List<DocumentSnapshot> allDocs = value.docs;

      // get the posts of all the users being followed
      for (var element in allDocs) {
        Map<String, dynamic>? data = element.data() as Map<String, dynamic>?;

        if (data != null && data['following'].id == authID) {
          List userPosts = await getUserPosts(uid: data['followed'].id);
          posts.addAll(userPosts);
        }
      }

      return posts;
    });

  }

  // Get search results
  Future<List> getSearchResults({searchValue}) async {

    // // List the user's posts and posts of the people the user follows
    // List posts = await getUserPosts(uid: authID);

    //Get all the people the user is following
    return FirebaseFirestore.instance.collection("Posts").get().then((value) async {
      List<DocumentSnapshot> allDocs = value.docs;

      final allPosts = [];

      // get the posts of all the users being followed
      for (var element in allDocs) {
        Map<String, dynamic>? post = element.data() as Map<String, dynamic>?;

        if (post!['text'].toString().contains(searchValue)) {
          // get the user
          Map<String, dynamic>? userInfo = await getUserInfo(uid: post['poster'].id);

          // Get the number of comments, likes and reposts on the post
          int comments = await getNumberOfComments(postID :post["postID"].toString());
          int likes = await getNumberOfLikes(postID :post["postID"].toString());
          int reposts = await getNumberOfRePosts(postID :post["postID"].toString());
          bool liked = await hasLiked(postID: post["postID"]);
          bool rePosted = await hasRePost(postID: post["postID"]);


          // Add to posts if found
          allPosts.add(
              Post(
                postID: post["postID"].toString(),
                authID: authID,
                uid: post["poster"].id,
                avatar: userInfo!['avi'],
                username: userInfo['username'],
                name: userInfo['displayName'],
                timeAgo: timeago.format(post['timePosted'].toDate(), locale: 'en_short'),
                text: post['text'],
                media: post['image'],
                comments: comments.toString(),
                reposts: reposts.toString(),
                favorites: likes.toString(),
                hasLiked: liked,
                hasRePosted: rePosted,
              )
          );
        }
      }

      return allPosts;
    });

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
        totalFollowing.add(element["followed"].id);
      }
    }

    return totalFollowing;
  }

  // USER FUNCTIONS

  // Make a post
  Future<bool> post({poster, text, image}) async {
    // Get the data
    CollectionReference posts = FirebaseFirestore.instance.collection("Posts");

    int len = 0;
    await posts.get().then((value) => len = value.docs.length);

    return posts.doc(len.toString()).set({
      "postID": len,
      "poster": FirebaseFirestore.instance.collection('Users').doc(poster),
      "text": text,
      "image": image,
      "timePosted": DateTime.now()
    })
    .then((value) => true)
    .catchError((error) => false);
}
  
  // follow a given user
  Future<bool> follow({uid}) {
    //Get the data
    CollectionReference follows = FirebaseFirestore.instance.collection("Follow");

    return follows.add({
      "following": FirebaseFirestore.instance.collection('Users').doc(authID),
      "followed": FirebaseFirestore.instance.collection('Users').doc(uid),
    })
        .then((value) => true)
        .catchError((error) => false);
  }
  
  // Retweet a given post
  Future<bool> rePost({postID}) {
    //Get the data
    CollectionReference reposts = FirebaseFirestore.instance.collection("Reposts");

    return reposts.add({
      "postID": FirebaseFirestore.instance.collection('Posts').doc(postID),
      "rePoster": FirebaseFirestore.instance.collection('Users').doc(authID),
    })
        .then((value) => true)
        .catchError((error) => false);
  }

  // Remove the user's repost
  Future<bool> unRePost({postID}) async {
    //Get the document reference of the post
    late String docReference;

    //Get all the reposts
    await FirebaseFirestore.instance.collection("Reposts").get().then((value) {
      List<DocumentSnapshot> allDocs = value.docs;

      // get the document reference of the repost
      allDocs.forEach((element) {
        Map<String, dynamic>? data = element.data() as Map<String, dynamic>?;

        if (data!['rePoster'].id == authID && data["postID"].id == postID) {
          docReference = element.reference.id;
          return;
        }
      });

    });

    // Delete the repost
    return FirebaseFirestore.instance.collection("Reposts").doc(docReference).delete()
        .then((value) => true)
        .catchError((error) => false
    );

  }

  // Remove the user's like
  Future<bool> unlike({postID}) async {
    //Get the document reference of the post
    late String docReference;

    //Get all the reposts
    await FirebaseFirestore.instance.collection("Likes").get().then((value) {
      List<DocumentSnapshot> allDocs = value.docs;

      // get the document reference of the repost
      allDocs.forEach((element) {
        Map<String, dynamic>? data = element.data() as Map<String, dynamic>?;

        if (data!['liker'].id == authID && data["postID"].id == postID) {
          docReference = element.reference.id;
          return;
        }
      });

    });

    // Delete the repost
    return FirebaseFirestore.instance.collection("Likes").doc(docReference).delete()
        .then((value) => true)
        .catchError((error) => false
    );
  }

  // Unfollow another user
  Future<bool> unfollow({uid}) async{
    //Get the document reference of the post
    late String docReference;

    //Get all the follows
    await FirebaseFirestore.instance.collection("Follow").get().then((value) {
      List<DocumentSnapshot> allDocs = value.docs;

      // get the document reference of the follow
      allDocs.forEach((element) {
        Map<String, dynamic>? data = element.data() as Map<String, dynamic>?;

        if (data!['following'].id == authID && data["followed"].id == uid) {
          docReference = element.reference.id;
          return;
        }
      });

    });

    // Delete the repost
    return FirebaseFirestore.instance.collection("Follow").doc(docReference).delete()
        .then((value) => true)
        .catchError((error) => false
    );
  }

  // Like a given post
  Future<bool> like({postID}) {
    //Get the data
    CollectionReference likes = FirebaseFirestore.instance.collection("Likes");

    return likes.add({
      "postID": FirebaseFirestore.instance.collection('Posts').doc(postID),
      "liker": FirebaseFirestore.instance.collection('Users').doc(authID),
    })
        .then((value) => true)
        .catchError((error) => false);
  }

  // Comment on a given post

  // Check if user is following another user
  Future<bool> isFollowing({currentUserID, otherUserID}) async {
    // Get the data from the database
    QuerySnapshot<Map<String, dynamic>> query = await FirebaseFirestore.instance
        .collection("Follow")
        .get();

    // Get the following data
    var following = query.docs.map((data) => data.data());

    // Loop through the data to count the number of people the user is following
    for (var element in following) {

      if (
        element["following"] != null
        && element["following"].id == currentUserID
        && element['followed'].id == otherUserID
      ) {
        // return true if the current user follows the other user
        return true;
      }
    }

    return false;
  }

  // Get user's messages
  Future<List> getUserMessages({uid}) async {
    // Get the data from the database
    QuerySnapshot<Map<String, dynamic>> query = await FirebaseFirestore.instance
        .collection("Messages")
        .get();

    // Get the messages
    var messages = query.docs.map((data) => data.data());

    final allMessages = [];

    // Loop through the data to count the number of people the user is following
    for (var message in messages) {
      if (message["sender"].id == uid) {

        // Get the recipient's info
        Map<String, dynamic>? recipient = await getUserInfo(uid: message['recipient']);

        // Add to messages if found
        allMessages.add(
          Message(
            recipient: recipient,
            authID: authID,
            chatID: message['chatID'],
          )
        );
      }
    }

    return allMessages;
  }

  // Get user's chat

  // Check if the user has liked a post
  Future<bool> hasLiked({postID}) async {
    // Get the data from the database
    QuerySnapshot<Map<String, dynamic>> query = await FirebaseFirestore.instance
        .collection("Likes")
        .get();

    // Get the liked posts
    var likedPosts = query.docs.map((data) => data.data());

    for (var element in likedPosts){

      if (element['liker'].id == authID && element['postID'].id == postID.toString()){
        return true;
      }
    }

    return false;
  }

  // Check if the user has reposted a post
  Future<bool> hasRePost({postID}) async {
    // Get the data from the database
    QuerySnapshot<Map<String, dynamic>> query = await FirebaseFirestore.instance
        .collection("Reposts")
        .get();

    // Get the liked posts
    var reposts = query.docs.map((data) => data.data());

    for (var element in reposts){

      if (element['rePoster'].id == authID && element['postID'].id == postID.toString()){
        return true;
      }
    }

    return false;
  }

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
        int comments = await getNumberOfComments(postID :post["postID"].toString());
        int likes = await getNumberOfLikes(postID :post["postID"].toString());
        int reposts = await getNumberOfRePosts(postID :post["postID"].toString());
        bool liked = await hasLiked(postID: post["postID"]);
        bool rePosted = await hasRePost(postID: post["postID"]);


        // Add to posts if found
        allPosts.add(
          Post(
            postID: post["postID"].toString(),
            authID: authID,
            uid: post["poster"].id,
            avatar: userInfo!['avi'],
            username: userInfo['username'],
            name: userInfo['displayName'],
            timeAgo: timeago.format(post['timePosted'].toDate(), locale: 'en_short'),
            text: post['text'],
            media: post['image'],
            comments: comments.toString(),
            reposts: reposts.toString(),
            favorites: likes.toString(),
            hasLiked: liked,
            hasRePosted: rePosted,
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
        int comments = await getNumberOfComments(postID :post["postID"].toString());
        int likes = await getNumberOfLikes(postID :post["postID"].toString());
        int reposts = await getNumberOfRePosts(postID :post["postID"].toString());

        // Increment total if found
        allPostsWithMedia.add(
            Post(
              postID: post["postID"].toString(),
              authID: authID,
              uid: post["poster"].id,
              avatar: userInfo!['avi'],
              username: userInfo['username'],
              name: userInfo['displayName'],
              timeAgo:  timeago.format(post['timePosted'].toDate(), locale: 'en_short'),
              text: post['text'],
              media: post['image'],
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
        Map<String, dynamic>? item = await getOnePost(postID: post["postID"].id);

        //Get poster details
        Map<String, dynamic>? posterInfo = await getUserInfo(uid: item!['poster'].id);

        // Get the number of comments, likes and reposts on the post
        int comments = await getNumberOfComments(postID :post["postID"].id);
        int likes = await getNumberOfLikes(postID :post["postID"].id);
        int reposts = await getNumberOfRePosts(postID :post["postID"].id);


        // Increment total if found
        allReposts.add(
            Post(
              postID: post["postID"].toString(),
              authID: authID,
              uid: item["poster"].id,
              avatar: posterInfo!['avi'],
              username: posterInfo['username'],
              name: posterInfo['displayName'],
              timeAgo:  timeago.format(item['timePosted'].toDate(), locale: 'en_short'),
              text: item['text'],
              media: item['image'],
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
        Map<String, dynamic>? item = await getOnePost(postID: post["postID"].id);

        //Get poster details
        Map<String, dynamic>? posterInfo = await getUserInfo(uid: item!['poster'].id);

        // Get the number of comments, likes and reposts on the post
        int comments = await getNumberOfComments(postID :post["postID"].id);
        int likes = await getNumberOfLikes(postID :post["postID"].id);
        int reposts = await getNumberOfRePosts(postID :post["postID"].id);


        // Increment total if found
        allLikes.add(
            Post(
              postID: post["postID"].toString(),
              authID: authID,
              uid: item["poster"].id,
              avatar: posterInfo!['avi'],
              username: posterInfo['username'],
              name: posterInfo['displayName'],
              timeAgo:  timeago.format(item['timePosted'].toDate(), locale: 'en_short'),
              text: item['text'],
              media: item['image'],
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
        Map<String, dynamic>? item = await getOnePost(postID: post["commentPostID"].id);

        //Get poster details
        Map<String, dynamic>? posterInfo = await getUserInfo(uid: item!['poster'].id);

        // Get the number of comments, likes and reposts on the post
        int comments = await getNumberOfComments(postID :post["commentPostID"].id);
        int likes = await getNumberOfLikes(postID :post["commentPostID"].id);
        int reposts = await getNumberOfRePosts(postID :post["commentPostID"].id);


        // Increment total if found
        allComments.add(
            Post(
              postID: post["postID"].toString(),
              authID: authID,
              uid: item["poster"].id,
              avatar: posterInfo!['avi'],
              username: posterInfo['username'],
              name: posterInfo['displayName'],
              timeAgo:  timeago.format(item['timePosted'].toDate(), locale: 'en_short'),
              text: item['text'],
              media: item['image'],
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

    if (posts.isEmpty){
      return numComments;
    }

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

    if (posts.isEmpty){
      return numRePosts;
    }

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

    if (posts.isEmpty){
      return numLikes;
    }

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
  Future<void> userSignUp({uid, username, contact}) async {
    CollectionReference ref = FirebaseFirestore.instance.collection("Users");

    await ref.doc(uid).set({
      "username": username,
      "displayName": "",
      "bio": "",
      "avi": "",
      "banner": "",
      "contact": contact
    })
    .then((value) => true)
    .catchError((error) => false);

  }

  // Update a user's information when they save their profile
  Future<bool> userProfileUpdate({uid, displayName, bio, avi, banner}) async {
    CollectionReference ref = FirebaseFirestore.instance.collection("Users");

    return await ref.doc(uid).update({
      "displayName": displayName,
      "bio": bio,
      "avi": avi,
      "banner": banner,
    }).then((value) => true)
    .catchError((error) => false);
  }

}