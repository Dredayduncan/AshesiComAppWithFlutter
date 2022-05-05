import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import 'customSubmitButton.dart';

getImage(BuildContext context, ImageSource source,
    Function(File) onImageSelected) {
  ImagePicker().pickImage(source: source, imageQuality: 50).then((
      XFile? file,
      ) {

    onImageSelected(File(file!.path));
    Navigator.pop(context);
  });
}

openImagePicker(BuildContext context,  Function(File) onImageSelected) {
  showModalBottomSheet(
    context: context,
    builder: (BuildContext context) {
      return Container(
        height: 100,
        padding: const EdgeInsets.all(10),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              const Text(
                'Pick an image',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Row(
                children: <Widget>[
                  Expanded(
                    child: CustomSubmitButton(
                      text: "Use Camera",
                      textColor: Colors.white,
                      color: const Color(0xFFCB6E74),
                      borderRadius: 5,
                      onPressed: () {
                        getImage(context, ImageSource.camera, onImageSelected);
                      },
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: CustomSubmitButton(
                      text: "Use Gallery",
                      color: const Color(0xFFCB6E74),
                      textColor: Colors.white,
                      borderRadius: 5,
                      onPressed: () {
                        getImage(context, ImageSource.gallery, onImageSelected);
                      },
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      );
    },
  );
}


