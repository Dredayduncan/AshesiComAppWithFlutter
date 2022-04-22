import 'dart:io';

import 'package:ashesicom/common_widgets/profileTextField.dart';
import 'package:flutter/material.dart';

class EditProfile extends StatefulWidget {
  final String displayName;
  final String bio;
  final String avi;
  final String banner;


  const EditProfile({
    Key? key,
    required this.displayName,
    required this.bio,
    required this.avi,
    required this.banner,
  }) : super(key: key);

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {

  TextEditingController _name = TextEditingController();
  TextEditingController _bio = TextEditingController();

  // Get avi and banner images
  late File avi;
  late File banner;


  @override
  void initState() {
    // TODO: implement initState
    _name.text = widget.displayName;
    _bio.text = widget.bio;
    avi = File(widget.avi);
    banner = File(widget.banner);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xFFD0BBC4),
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text(
                  "Cancel",
                  style: TextStyle(
                    color: Color(0xFFCB6E74),
                    fontSize: 16
                  ),
                )
            ),
            const Text(
              "Edit Profile",
              style: TextStyle(
                color: Color(0xFFAF3A42),
                fontWeight: FontWeight.bold

              )
            ),
            TextButton(
                onPressed: () {},
                child: const Text(
                  "Save",
                  style: TextStyle(
                      color: Color(0xFFCB6E74),
                      fontSize: 16
                  )
                )
            ),
          ],
        ),
      ),
      body: Column(
          children: [
            //  Banner
            Stack(
              children: [
                Container(
                  height: 120,
                  width:  MediaQuery.of(context).size.width,
                  child: Image.file(
                    banner,
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  top: 80.0,
                  child: Container(
                    height: 80,
                    child: Container(
                      child: FittedBox(
                        child: FloatingActionButton(
                          backgroundColor: const Color(0xFFD0BBC4),
                          elevation: 0,
                          onPressed: (){},
                          child: CircleAvatar(
                            radius: 25,
                            backgroundImage: Image.file(
                              avi,
                              fit: BoxFit.cover,
                            ).image,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ]
            ),
            CustomProfileTextField(
              label: "Name",
              controller: _name
            ),
            CustomProfileTextField(
                label: "Bio",
                controller: _bio
            )
          ],
        ),
    );
  }
}
