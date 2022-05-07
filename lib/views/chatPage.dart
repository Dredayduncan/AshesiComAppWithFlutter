import 'package:timeago/timeago.dart' as timeago;
import 'package:ashesicom/services/database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';

class ChatPage extends StatefulWidget {
  String chatID;
  final String contact;
  final String userID;
  final String displayName;
  final String authID;

  ChatPage({
    Key? key,
    required this.authID,
    required this.displayName,
    required this.userID,
    required this.chatID,
    required this.contact
  }) : super(key: key);

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {

  Future<bool?> _callNumber(String number) async{
    bool? res = await FlutterPhoneDirectCaller.callNumber(number);
    return res;
  }

  late Map<String, dynamic> userInfo;
  late Database _db;
  late List chats; // the chat log
  final TextEditingController _messageController = TextEditingController();

  Widget _currentPage = const Center(
    child: CircularProgressIndicator(
      color: Color(0xFFAF3A42),
    ),
  );

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _db = Database(authID: widget.authID);
    _buildContent();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Color(0xFFAF3A42)
        ),
        backgroundColor: const Color(0xFFD0BBC4),
        elevation: 0,
        title: Text(
          widget.displayName,
          style: const TextStyle(
            color: Color(0xFFD397A3)
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              // Call Nathaniel
              _callNumber(widget.contact).then((value) {
                if (value == false){
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('There was an error contacting ${widget.displayName}.'),
                      action: SnackBarAction(
                        label: 'Dismiss',
                        onPressed: () {
                          ScaffoldMessenger.of(context).hideCurrentSnackBar();
                        },
                      ),
                    ),
                  );
                }
              });
            },
            icon: const Icon(
              Icons.call,
              color: Color(0xFFAF3A42),
            )
          )
        ],
      ),
      body: _currentPage,
      bottomSheet: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          height: 30,
          child: TextField(
            keyboardType: TextInputType.multiline,
            maxLines: null,
            textInputAction: TextInputAction.send,
            onSubmitted: (value) {
              _db.sendChat(
                chatID: widget.chatID,
                recipientID: widget.userID,
                chat: value
              ).then((value) {
                if (value != null){
                  setState(() {
                    widget.chatID = value;
                    _messageController.clear();
                    _buildContent();
                  });
                }
                else{
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text('There was an error sending your message!'),
                      action: SnackBarAction(
                        label: 'Dismiss',
                        onPressed: () {
                          ScaffoldMessenger.of(context).hideCurrentSnackBar();
                        },
                      ),
                    ),
                  );
                }
              });
            },
            cursorColor: const Color(0xFFAF3A42),
            controller: _messageController,
            decoration: InputDecoration(
              enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.transparent),
                borderRadius: BorderRadius.circular(25.0),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.transparent),
                borderRadius: BorderRadius.circular(25.0),
              ),
              filled: true,
              contentPadding: const EdgeInsets.all(5),
              hintStyle: const TextStyle(color: Color(0xFF808083)),
              hintText: "Start a message",
              fillColor: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  _buildContent() async {
    chats = await _db.getChats(widget.chatID);

    setState(() {
      _currentPage = _chatScreenBody(chats);
    });
  }

  Widget _chatScreenBody(chats) {
    if (chats == null || chats.isEmpty) {
      return const Center(
        child: Text(
          'No message found',
          style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
        ),
      );
    }
    return ListView.builder(
      // controller: _controller,
      shrinkWrap: true,
      reverse: true,
      physics: const BouncingScrollPhysics(),
      itemCount: chats.length,
      itemBuilder: (context, index) => chatMessage(chats[index]),
    );
  }

  Widget chatMessage(Map<String, dynamic> message) {

    if (message['senderID'].id == widget.authID) {
      return _message(message, true);
    } else {
      return _message(message, false);
    }
  }

  Widget _message(Map<String, dynamic> chat, bool myMessage) {
    return Column(
      crossAxisAlignment:
      myMessage ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      mainAxisAlignment:
      myMessage ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: <Widget>[
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            const SizedBox(
              width: 15,
            ),
            myMessage
                ? const SizedBox()
                : CircleAvatar(
              backgroundColor: Colors.transparent,
              // backgroundImage: customAdvanceNetworkImage(userImage),
            ),
            Expanded(
              child: Container(
                alignment:
                myMessage ? Alignment.centerRight : Alignment.centerLeft,
                margin: EdgeInsets.only(
                  right: myMessage ? 10 : (MediaQuery.of(context).size.width / 4),
                  top: 20,
                  left: myMessage ? (MediaQuery.of(context).size.width / 4) : 10,
                ),
                child: Stack(
                  children: <Widget>[
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        borderRadius: getBorder(myMessage),
                        color: myMessage
                            ? const Color(0xFFD397A3)
                            : Colors.white,
                      ),
                      child: Text(
                        chat['chat'],
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                        ),
                        // urlStyle: TextStyle(
                        //   fontSize: 16,
                        //   // color: myMessage
                        //   //     ? TwitterColor.white
                        //   //     : TwitterColor.dodgetBlue,
                        //   decoration: TextDecoration.underline,
                        ),
                      ),
                    // ),
                  ],
                ),
              ),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(right: 10, left: 10),
          child: Text(
            timeago.format(chat['timeSent'].toDate(), locale: 'en_short'),
            style: Theme.of(context).textTheme.caption!.copyWith(fontSize: 12),
          ),
        )
      ],
    );
  }

  BorderRadius getBorder(bool myMessage) {
    return BorderRadius.only(
      topLeft: const Radius.circular(20),
      topRight: const Radius.circular(20),
      bottomRight:
      myMessage ? const Radius.circular(0) : const Radius.circular(20),
      bottomLeft:
      myMessage ? const Radius.circular(20) : const Radius.circular(0),
    );
  }
}
