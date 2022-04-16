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
    // return Scaffold(
    //   appBar: AppBar(
    //     elevation: 0,
    //     backgroundColor: const Color(0xFFD0BBC4),
    //     automaticallyImplyLeading: false,
    //     title: Row(
    //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //       children: [
    //         TextButton(
    //             onPressed: () {
    //               Navigator.of(context).pop();
    //             },
    //             child: const Text(
    //               "Cancel",
    //               style: TextStyle(
    //                 color: Color(0xFFCB6E74),
    //                 fontSize: 16
    //               ),
    //             )
    //         ),
    //         const Text(
    //           "Edit Profile",
    //           style: TextStyle(
    //             color: Color(0xFFAF3A42),
    //             fontWeight: FontWeight.bold
    //
    //           )
    //         ),
    //         TextButton(
    //             onPressed: () {},
    //             child: const Text(
    //               "Save",
    //               style: TextStyle(
    //                   color: Color(0xFFCB6E74),
    //                   fontSize: 16
    //               )
    //             )
    //         ),
    //       ],
    //     ),
    //   ),
    //   body: Column(
    //       children: [
    //         //  Banner
    //         Stack(
    //           children: [
    //             Container(
    //               height: 120,
    //               width:  MediaQuery.of(context).size.width,
    //               child: const Image(
    //                 image: AssetImage("assets/images/profile.jpeg"),
    //                 fit: BoxFit.cover,
    //               ),
    //             ),
    //             Positioned(
    //               top: 80.0,
    //               child: Container(
    //                 height: 80,
    //                 child: Container(
    //                   child: FittedBox(
    //                     child: FloatingActionButton(
    //                       backgroundColor: const Color(0xFFD0BBC4),
    //                       elevation: 0,
    //                       onPressed: (){},
    //                       child: const CircleAvatar(
    //                         radius: 25,
    //                         backgroundImage: AssetImage("assets/images/profile.jpeg"),
    //                       ),
    //                     ),
    //                   ),
    //                 ),
    //               ),
    //             ),
    //           ]
    //         ),
    //         CustomProfileTextField(
    //           label: "Name",
    //           controller: _name
    //         ),
    //         CustomProfileTextField(
    //             label: "Bio",
    //             controller: _bio
    //         )
    //       ],
    //     ),
    // );
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
      body: ListView(
        physics: const BouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics()),
        children: [
          GestureDetector(
            onTap: () {},
            child: Stack(
              children: [
                Container(
                  height: 150,
                  decoration: const BoxDecoration(
                    color: Color(0xFFD0BBC4),
                    image: //_coverImage == null && widget.user.coverImage.isEmpty
                      //   ? null
                      //   : DecorationImage(
                      // fit: BoxFit.cover,
                      // image: displayCoverImage(),
                    DecorationImage(
                      image: AssetImage("assets/images/profile.jpeg"),
                      fit: BoxFit.cover
                    ),
                  ),
                ),
                Container(
                  height: 150,
                  color: Colors.black54,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(
                        Icons.camera_alt,
                        size: 70,
                        color: Colors.white,
                      ),
                      Text(
                        'Change Cover Photo',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
          Container(
            transform: Matrix4.translationValues(0, -40, 0),
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    GestureDetector(
                      onTap: () {},
                      child: Stack(
                        children: [
                          const CircleAvatar(
                            radius: 45,
                            backgroundImage: AssetImage("assets/images/profile.jpeg")//displayProfileImage(),
                          ),
                          CircleAvatar(
                            radius: 45,
                            backgroundColor: Colors.black54,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: const [
                                Icon(
                                  Icons.camera_alt,
                                  size: 30,
                                  color: Colors.white,
                                ),
                                Text(
                                  'Change Profile Photo',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
                Form(
                    // key: _formKey,
                    child: Column(
                      children: [
                        CustomProfileTextField(
                          label: "Name",
                          controller: _name
                        ),
                        CustomProfileTextField(
                            label: "Bio",
                            controller: _bio
                        ),
                        const SizedBox(height: 30),
                        // SizedBox(height: 30),
                        // _isLoading
                        //     ? CircularProgressIndicator(
                        //   valueColor:
                        //   AlwaysStoppedAnimation(const Color(0xFFD0BBC4)),
                        // )
                        //     : SizedBox.shrink()
                      ],
                    )),
              ],
            ),
          )
        ],
      ),
    );
  }
}
