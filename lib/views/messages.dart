import 'package:flutter/material.dart';
import '../services/auth.dart';
import '../services/database.dart';
import 'newMessage.dart';

class Messages extends StatefulWidget {
  final Auth auth;

  Messages({Key? key, required this.auth}) : super(key: key);

  @override
  State<Messages> createState() => _MessagesState();
}

class _MessagesState extends State<Messages> {
  final TextEditingController controller = TextEditingController();
  late List _messages;
  late Database _db;
  late Widget _currentPage;

  // Create different states of the page

  // loading screen
  final Widget _loading = const Center(
    child: CircularProgressIndicator(
      color: Color(0xFFAF3A42),
    ),
  );

  // No results screen
  final Widget noResults = const Center(
    child: Text(
      "No Results",
      style: TextStyle(
        color: Color(0xFF808083)
      ),
    ),
  );

  // Constructor
  _MessagesState() {
    _currentPage = _loading;
  }

  // Get all current messages of the user
  generateMessages() async {
    _messages = await _db.getUserMessageList();

    setState(() {
      _currentPage = messageList();
    });

  }

  // Get the users related to the search the user made
  generateSearchResults({searchValue}) {

  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _db = Database(authID: widget.auth.currentUser!.uid);
    generateMessages();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFFAF3A42),
        child: const Icon(Icons.message),
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => NewMessage(authID: widget.auth.currentUser!.uid,))
          );
        },
      ),
      body: _currentPage
    );
  }

  // Display list of messages
  Widget messageList() {
    return _messages.isEmpty ? noResults : Container(
      child: ListView.separated(
        itemBuilder: (BuildContext context, int index) {
          return _messages[index];
        },
        separatorBuilder: (BuildContext context, int index) => Divider(
          height: 0,
        ),
        itemCount: _messages.length,
      ),
    );
  }
}
