import 'package:ashesicom/common_widgets/rippleButton.dart';
import 'package:ashesicom/common_widgets/titleText.dart';
import 'package:ashesicom/views/profile.dart';
import 'package:ashesicom/common_widgets/rippleButton.dart';
import 'package:flutter/material.dart';

import '../views/chatPage.dart';
import 'customText.dart';

class Message extends StatelessWidget {
  final Map<String, dynamic>? recipient;
  String? lastMessage;
  final String authID;
  final String chatID;

  Message({
    Key? key,
    required this.chatID,
    required this.recipient,
    required this.authID
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFD0BBC4),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 10),
        onTap: () {
          // final chatState = Provider.of<ChatState>(context, listen: false);
          // final searchState = Provider.of<SearchState>(context, listen: false);
          // chatState.setChatUser = model;
          // if (searchState.userlist!.any((x) => x.userId == model.userId)) {
          //   chatState.setChatUser = searchState.userlist!
          //       .where((x) => x.userId == model.userId)
          //       .first;
          // }
          Navigator.push(
            context, MaterialPageRoute(builder: (context) => const ChatPage())
          );
        },
        leading: RippleButton(
          onPressed: () {
            Navigator.push(
                context, MaterialPageRoute(
                builder: (context) => Profile(authID: authID, uid: "dreday",))
            );
          },
          borderRadius: BorderRadius.circular(28),
          child: Container(
            height: 56,
            width: 56,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.white, width: 2),
              borderRadius: BorderRadius.circular(28),
              image: const DecorationImage(
                  image: NetworkImage(
                    "https://images.unsplash.com/photo-1547721064-da6cfb341d50",
                  ),
                  fit: BoxFit.cover),
            ),
          ),
        ),
        title: const TitleText(
          "NA",
          fontSize: 16,
          fontWeight: FontWeight.w800,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: CustomText(
          // msg: getLastMessage(lastMessage?.message) ?? '@${model.displayName}',
          msg: lastMessage ?? 'Display name',
          style: const TextStyle(color: Colors.black54),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: lastMessage == null
            ? const SizedBox.shrink()
            : const Text( "Beans",
          // Utility.getChatTime(lastMessage.createdAt).toString(),
          style: TextStyle(
            color: Colors.black54,
            fontSize: 12,
          ),
        ),
      ),
    );
  }
}
