import 'dart:io';
import 'package:ashesicom/common_widgets/rippleButton.dart';
import 'package:ashesicom/common_widgets/titleText.dart';
import 'package:ashesicom/views/profile.dart';
import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;
import '../views/chatPage.dart';
import 'customText.dart';

class Message extends StatelessWidget {

  String recipientID;
  Map<String, dynamic>? lastMessage;
  final String authID;
  final String? chatID;
  final String avatar;
  final String username;
  final String displayName;
  final String contact;

  Message({
    Key? key,
    this.chatID,
    required this.recipientID,
    required this.authID,
    required this.avatar,
    required this.username,
    required this.displayName,
    required this.contact,
    this.lastMessage
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFD0BBC4),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 10),
        onTap: () {

          Navigator.push(
            context, MaterialPageRoute(builder: (context) => ChatPage(
            authID: authID,
            displayName: displayName,
            userID: recipientID,
            contact: contact,
            chatID: chatID == null ? "" : chatID!,
          ))
          );
        },
        leading: RippleButton(
          onPressed: () {
            Navigator.push(
                context, MaterialPageRoute(
                builder: (context) => Profile(authID: authID, uid: recipientID,))
            );
          },
          borderRadius: BorderRadius.circular(28),
          child: Container(
            height: 56,
            width: 56,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.white, width: 2),
              borderRadius: BorderRadius.circular(28),
              image: avatar == ""
                ? DecorationImage(
                    image: Image.asset(
                      "assets/images/AshLogo.jpg",
                    ).image
                )
                : DecorationImage(image:
                  Image.file(
                    File(avatar),
                    fit: BoxFit.cover,).image
              ),
            ),
          ),
        ),
        title: Row(
          children: [
            TitleText(
              displayName,
              fontSize: 16,
              fontWeight: FontWeight.w800,
              overflow: TextOverflow.ellipsis,
            ),
            chatID == null ? const SizedBox.shrink() : Text(
              '@$username',
              style: const TextStyle(
                color: Color(0xFF808083),
              ),
            ),
          ],
        ),
        subtitle: chatID == null
            ? CustomText(
              msg: '@$username',
              style: const TextStyle(color: Colors.black54),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            )
            : CustomText(
              // msg: getLastMessage(lastMessage?.message) ?? '@${model.displayName}',
              msg: lastMessage!['chat'] ?? '',
              style: const TextStyle(color: Colors.black54),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
        ),
        trailing: lastMessage == null
            ? const SizedBox.shrink()
            : Text( timeago.format(lastMessage!['timeSent'].toDate(), locale: 'en_short'),
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
