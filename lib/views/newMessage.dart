import 'package:ashesicom/services/database.dart';
import 'package:flutter/material.dart';

class NewMessage extends StatefulWidget {
  final String authID;

  const NewMessage({Key? key, required this.authID}) : super(key: key);

  @override
  State<NewMessage> createState() => _NewMessageState();
}

class _NewMessageState extends State<NewMessage> {
  TextEditingController controller = TextEditingController();
  Widget _currentPage = Container();
  late List _messages;
  late Database _db;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _db = Database(authID: widget.authID);
  }

  final Widget _loading = const Center(
    child: CircularProgressIndicator(
      color: Color(0xFFAF3A42),
    ),
  );

  generateResults(searchValue) async {
    _messages = await _db.getUsersToMessage(searchValue);

    if (_messages.isEmpty){
      setState(() {
        _currentPage = const Center(
          child: Text("No Results"),
        );
      });
    }
    else {
      setState(() {
        _currentPage = messageList();
      });
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFD0BBC4),
        elevation: 0,
        centerTitle: true,
        title: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            height: 30,
            child: TextField(
              textInputAction: TextInputAction.search,
              onSubmitted: (value) {
                setState(() {
                  _currentPage = _loading;

                  setState(() {
                    generateResults(value);
                  });

                });

              },
              controller: controller,
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
                  hintText: "Search for People to Message",
                  fillColor: const Color(0xFFD397A3),
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: controller.text.isEmpty ? null : IconButton(
                    color: const Color(0xFF808083),
                    onPressed: () {
                      controller.clear();
                      setState(() {});
                    },
                    icon: const Icon(Icons.clear),
                    iconSize: 20,
                    padding: const EdgeInsets.only(bottom: 1.0),
                  )
              ),
            ),
          ),
        ),
      ),
      body: _currentPage,
    );
  }

  // Display list of messages
  Widget messageList() {
    return Container(
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
