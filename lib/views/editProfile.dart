import 'package:ashesicom/common_widgets/profileTextField.dart';
import 'package:flutter/material.dart';

class EditProfile extends StatefulWidget {

  const EditProfile({Key? key}) : super(key: key);

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {

  late TextEditingController _name = TextEditingController();
  late TextEditingController _bio = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    _name.text = "Dre Day";
    _bio.text = "Digital Goodies Team - Web & Mobile UI/UX development; Graphics; Illustrations";
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
                  child: const Image(
                    image: AssetImage("assets/images/profile.jpeg"),
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
                          child: const CircleAvatar(
                            radius: 25,
                            backgroundImage: AssetImage("assets/images/profile.jpeg"),
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
