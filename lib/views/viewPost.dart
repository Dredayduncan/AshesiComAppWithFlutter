import 'package:flutter/material.dart';

class ViewPost extends StatefulWidget {
  const ViewPost({Key? key}) : super(key: key);

  @override
  State<ViewPost> createState() => _ViewPostState();
}

class _ViewPostState extends State<ViewPost> {
  TextEditingController _replyController = TextEditingController();
  var _image;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Post",
          style: TextStyle(
            color: Colors.black
          ),
        ),
        iconTheme: const IconThemeData(
          color: Color(0xFFAF3A42)
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: const Color(0xFFD0BBC4),
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Row(
                  children: [
                    Container(
                      margin: const EdgeInsets.all(10.0),
                      child: const CircleAvatar(
                        backgroundImage: AssetImage("assets/images/profile.jpeg"),
                      ),
                    ),
                    Column(
                      children: const [
                      Text(
                      "Dre Day",
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '@beans',
                      style: TextStyle(
                        color: Color(0xFF808083),
                      ),
                    ),
                      ],
                    )
                  ],
                ),
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    "Quickly create a low-fi wireframe version of your web projects "
                    "with ready-to-use layouts of Scheme Constructor this is just to "
                    "test the scroll feature",
                    style: TextStyle(
                      fontSize: 20
                    ),
                  ),
                ),
                SizedBox(width: 5.0,),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    alignment: Alignment.center,
                    child: Image(
                      image: AssetImage("assets/images/profile.jpeg"),
                    )//_image != null
                        // ? Image.file(_image!, fit: BoxFit.cover,)
                        // : const Text(""),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomSheet: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const CircleAvatar(
              radius: 15,
              backgroundImage: AssetImage("assets/images/profile.jpeg"),
            ),
            const SizedBox(width: 5.0,),
            Expanded(
                child: Container(
                  height: 30,
                  child: TextField(
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    cursorColor: const Color(0xFFAF3A42),
                    controller: _replyController,
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
                      hintText: "Post your reply",
                      fillColor: Colors.white,
                    ),
                  ),
                )
            ),
          ],
        ),
      ),
    );
  }
}
