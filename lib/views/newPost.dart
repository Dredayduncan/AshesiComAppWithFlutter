import 'dart:io';
import 'package:ashesicom/common_widgets/imageBottomSheet.dart';
import 'package:ashesicom/services/database.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:status_alert/status_alert.dart';

class NewPost extends StatefulWidget {
  final String authID;
  final String image;

  NewPost({Key? key,  required this.authID, required this.image}) : super(key: key,);

  @override
  State<NewPost> createState() => _NewPostState();
}

class _NewPostState extends State<NewPost> {
  //diplay picture
  var _image;
  late Database db;
  TextEditingController _text = TextEditingController();

  @override
  void initState() {
    super.initState();
    db = Database(authID: widget.authID,);
  }

  Future getImage() async {
    openImagePicker(context, (file) {

      setState(() {
        _image = file;
      });

    });
    // XFile? pickedImage = await ImagePicker().pickImage(source: ImageSource.gallery);
    //
    // if (pickedImage != null){
    //
    //   setState(() {
    //     File file = File(pickedImage.path);
    //     _image = file;
    //   });
    //
    // }
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
                onPressed: () {

                  db.post(
                    poster: widget.authID,
                    text: _text.text,
                    image: _image != null ? _image.path : ""
                  ).then((value) {
                    if (value == true){

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: const Text('Your post was successful.'),
                          action: SnackBarAction(
                            label: 'Dismiss',
                            onPressed: () {
                              ScaffoldMessenger.of(context).hideCurrentSnackBar();
                            },
                          ),
                        ),
                      );
                      // StatusAlert.show(
                      //   context,
                      //   backgroundColor: const Color(0xFFCB6E74),
                      //   duration: const Duration(seconds: 2),
                      //   title: 'Success',
                      //   subtitle: 'Your post was successful.',
                      //   configuration: const IconConfiguration(icon: Icons.done),
                      // );
                    }
                    else{
                      // StatusAlert.show(
                      //   context,
                      //   backgroundColor: const Color(0xFFCB6E74),
                      //   duration: const Duration(seconds: 2),
                      //   title: 'Error',
                      //   subtitle: 'Your post was unsuccessful.',
                      //   configuration: const IconConfiguration(icon: Icons.error_outline),
                      // );

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: const Text('Your post was unsuccessful.'),
                          action: SnackBarAction(
                            label: 'Dismiss',
                            onPressed: () {
                              ScaffoldMessenger.of(context).hideCurrentSnackBar();
                            },
                          ),
                        ),
                      );
                    }

                    Navigator.of(context).pop();
                  });
                },
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
                    image: widget.image == ""
                        ? DecorationImage(
                        image: Image.asset(
                          "assets/images/AshLogo.jpg",
                        ).image
                    )
                        : DecorationImage(image:
                    Image.file(
                      File(widget.image),
                      fit: BoxFit.fill,
                    ).image
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10,),
              Flexible(
                child: TextField(
                  controller: _text,
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: "What's going on?"
                  ),
                ),
              ),
            ],
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                alignment: Alignment.center,
                child: _image != null
                    ? Image.file(_image!, fit: BoxFit.cover,)
                    : const Text(""),
              ),
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
