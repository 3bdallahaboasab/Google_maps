import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_maps/appLocal.dart';

import 'package:image_picker/image_picker.dart';

class UplaodImage extends StatefulWidget {
  const UplaodImage({super.key});

  @override
  State<UplaodImage> createState() => _UplaodImageState();
}

class _UplaodImageState extends State<UplaodImage> {
  final ImagePicker picker = ImagePicker();
  File? _file;
  File? _file2;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Center(
                  child: ElevatedButton(
                    onPressed: () async {
                      uploadImageFromCamera();
                    },
                    child: const Text("Upload photo from camera"),
                  ),
                ),
                _file2 == null
                    ? Text("${getLang(context, "text1")}")
                    : Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Image.file(
                            _file2!,
                            fit: BoxFit.cover,
                            height: 300,
                          ),
                        ),
                      ),
                SizedBox(
                  height: 20,
                ),
                Center(
                  child: ElevatedButton(
                    onPressed: () async {
                      uploadImageFromGallery();
                    },
                    child: const Text("Upload photo from Gallery"),
                  ),
                ),
                _file == null
                    ? Text("there is no photo")
                    : ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Image.file(
                          _file!,
                          height: 300,
                          fit: BoxFit.cover,
                        )),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future uploadImageFromGallery() async {
    final myFileFromGallery =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    setState(() {
      _file = File(myFileFromGallery!.path);
    });

    print(_file!.path.split("/").last);
  }

  Future uploadImageFromCamera() async {
    final myFileFromCamera =
        await ImagePicker().pickImage(source: ImageSource.camera);

    setState(() {
      _file2 = File(myFileFromCamera!.path);
    });
    print(_file2);
  }
}
