import 'dart:io';
import 'package:ashesicom/common_widgets/customSubmitButton.dart';
import 'package:ashesicom/common_widgets/profileTextField.dart';
import 'package:ashesicom/services/database.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:path/path.dart' as path;

import '../common_widgets/imageBottomSheet.dart';

class EditProfile extends StatefulWidget {
  final String displayName;
  final String bio;
  final String avi;
  final String banner;
  final String authID;


  const EditProfile({
    Key? key,
    required this.displayName,
    required this.bio,
    required this.avi,
    required this.banner,
    required this.authID
  }) : super(key: key);

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {

  TextEditingController _name = TextEditingController();
  TextEditingController _bio = TextEditingController();
  TextEditingController _contact = TextEditingController();
  late Database _db;

  // Get avi and banner images
  late File _avi;
  late File _banner;


  @override
  void initState() {
    // TODO: implement initState
    _name.text = widget.displayName;
    _bio.text = widget.bio;
    _avi = File(widget.avi);
    _banner = File(widget.banner);
    _db =  Database(authID: widget.authID);
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
                    fontSize: 12
                  ),
                )
            ),
            const Text(
              "Edit Profile",
              style: TextStyle(
                color: Color(0xFFAF3A42),
                fontWeight: FontWeight.bold,
                fontSize: 16

              )
            ),
            TextButton(
                onPressed: () {
                  // Update profile information
                  _db.userProfileUpdate(
                    uid: widget.authID,
                    displayName: _name.text,
                    bio: _bio.text,
                    contact: _contact.text,
                    avi: _avi.path,
                    banner: _banner.path
                  ).then((value) async {
                      bool aviUpload = await uploadAVIToCloud();
                      bool bannerUpload = await uploadBannerToCloud();
                      if (value == true && aviUpload == true && bannerUpload == true ){

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: const Text('Profile has been updated!'),
                            action: SnackBarAction(
                              label: 'Dismiss',
                              onPressed: () {
                                ScaffoldMessenger.of(context).removeCurrentSnackBar();
                              },
                            ),
                          ),
                        );

                        Navigator.of(context).pop();
                      }
                      else {
                       return ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: const Text('Profile could not be updated!'),
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
                child: const Text(
                  "Save",
                  style: TextStyle(
                      color: Color(0xFFCB6E74),
                      fontSize: 12
                  )
                )
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 180,
                child: Stack(
                  children: [
                    _bannerImage(),

                    //avi
                    Align(
                      alignment: Alignment.bottomLeft,
                      child: _aviImage(),
                    )
                  ],
                ),
              ),
              //  Banner
              CustomProfileTextField(
                label: "Name",
                controller: _name
              ),
              CustomProfileTextField(
                  label: "Contact",
                  controller: _contact,
                  isContact: true,
              ),
              CustomProfileTextField(
                  label: "Bio",
                  controller: _bio
              )
            ],
          ),
      ),
    );
  }

  // AVI section
  Widget _aviImage() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 0),
      height: 90,
      width: 90,
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFFAF3A42), width: 5),
        shape: BoxShape.circle,
        image: _banner.path == ""
            ? DecorationImage(
              image: Image.asset(
                "assets/images/AshLogo.jpg",
              ).image
            )
            : DecorationImage(image:
              Image.file(
                _avi,
                fit: BoxFit.cover,
              ).image
            ),
      ),
      child: CircleAvatar(
        radius: 40,
        backgroundImage: _avi.path == ""
            ? Image.asset(
              "assets/images/AshLogo.jpg",
            ).image
            : Image.file(
            _avi,
            fit: BoxFit.cover,
            ).image,
        child: Container(
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.black38,
          ),
          child: Center(
            child: IconButton(
              onPressed: uploadAVI,
              icon: const Icon(Icons.camera_alt, color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }

  // banner section
  Widget _bannerImage(){
    return Container(
      height: 180,
      decoration: BoxDecoration(
        image: _banner.path == ""
        ? DecorationImage(
            image: Image.asset(
              "assets/images/AshLogo.jpg",
            ).image
          )
        : DecorationImage(image: 
            Image.file(
              _banner,
              fit: BoxFit.fill,
            ).image
          )
      ),
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.black45,
        ),
        child: Stack(
          children: [
            _banner.path != ""
                ? Image.file(
                _banner,)
                // fit: BoxFit.fill, width: MediaQuery.of(context).size.width)
                : Image.asset(
                    "assets/images/AshLogo.jpg",
                    fit: BoxFit.fill,
            ),
            Center(
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: Colors.black38),
                child: IconButton(
                  onPressed: uploadBanner,
                  icon: const Icon(Icons.camera_alt, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  //upload an image for the avi
  void uploadAVI() {
    openImagePicker(context, (file) {
      setState(() {
        _avi = file;
      });
    });
  }

  // upload an image for the banner
  void uploadBanner() {
    openImagePicker(context, (file) {
      setState(() {
        _banner = file;
      });
    });
  }

  //Upload avi to cloud
  Future<bool> uploadAVIToCloud() async {
    if (_avi.path == ""){
      return true;
    }

    final fileName = path.basename(_avi.path);
    final destination = "${widget.authID}/avi/$fileName";

    try {
      final ref = firebase_storage.FirebaseStorage.instance.ref(destination);
      await ref.putFile(_avi);
      return true;

    }catch(e){
      return false;
    }

  }

  //upload banner to cloud
  Future<bool> uploadBannerToCloud() async {
    if (_banner.path == ""){
      return true;
    }

    final fileName = path.basename(_banner.path);
    final destination = "${widget.authID}/banner/$fileName";

    try {
      final ref = firebase_storage.FirebaseStorage.instance.ref(destination);
      await ref.putFile(_banner);
      return true;

    }catch(e){
      return false;
    }
  }



}
