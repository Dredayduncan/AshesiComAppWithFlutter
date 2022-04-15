import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class NewPost extends StatefulWidget {
  NewPost({Key? key}) : super(key: key);

  @override
  State<NewPost> createState() => _NewPostState();
}

class _NewPostState extends State<NewPost> {
  //diplay picture
  var _dp;

  Future getImage() async {
    XFile? pickedImage = await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedImage != null){

      setState(() {
        File file = File(pickedImage.path);
        _dp = file;
      });

    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xFFD0BBC4),
          elevation: 0,
          automaticallyImplyLeading: false,
          title: TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text(
              "Cancel",
              style: TextStyle(
                fontSize: 16 ,
                color: Color(0xFFAF3A42)
              ),
            ),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: ElevatedButton(
                child: Text(
                  "Post",
                  style: TextStyle(
                      color: Colors.grey.shade400
                  ),
                ),
                onPressed: () {},
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(
                      const Color(0xFFAF3A42)
                  ),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                      )
                    )
                  ),
                ),
            ),
          ],
        ),
      body: Column(
        children: [
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.white, width: 1),
                    borderRadius: BorderRadius.circular(28),
                    image: const DecorationImage(
                        image: NetworkImage(
                          "https://images.unsplash.com/photo-1547721064-da6cfb341d50",
                        ),
                        fit: BoxFit.cover),
                  ),
                ),
              ),
              const SizedBox(width: 10,),
              const Flexible(
                child: TextField(
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: "What's going on?"
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              alignment: Alignment.center,
              child: _dp != null
                  ? Image.file(_dp!, fit: BoxFit.cover,)
                  : const Text(""),
            ),
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(
              icon: const Icon(
                Icons.camera_alt_outlined,
                color: Color(0xFFAF3A42),
                size: 40.0,
              ),
              onPressed: (){
                getImage().then((value) {
                  setState(() {});
                });
              }
            ),
          )

        ],
      )
    );
  }
}
