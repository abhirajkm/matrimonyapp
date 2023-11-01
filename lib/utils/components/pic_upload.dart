
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class ProfilePicUploadWidget extends StatefulWidget {
  const ProfilePicUploadWidget({Key? key}) : super(key: key);

  @override
  _ProfilePicUploadWidgetState createState() => _ProfilePicUploadWidgetState();
}

class _ProfilePicUploadWidgetState extends State<ProfilePicUploadWidget> {
  double screenHeight = 0;
  double screenWidth = 0;
  String profilePicLink = "";
  final ImagePicker _picker = ImagePicker();


  Future imgFromGallery() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    final uid = FirebaseAuth.instance.currentUser!.uid;
    Reference ref = FirebaseStorage.instance
        .ref().child("profilepic$uid.jpg");

    await ref.putFile(File(pickedFile!.path));

    ref.getDownloadURL().then((value) async {
      setState(() {
        profilePicLink = value;
      });
    });


  }

  Future imgFromCamera() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.camera);
    final uid = FirebaseAuth.instance.currentUser!.uid;
    Reference ref = FirebaseStorage.instance
        .ref().child("profilepic$uid.jpg");

    await ref.putFile(File(pickedFile!.path));

    ref.getDownloadURL().then((value) async {
      setState(() {
        profilePicLink = value;
      });
    });

  }
  void pickUploadProfilePic() async {
    final image = await ImagePicker().pickImage(
      source: ImageSource.camera,
      maxHeight: 512,
      maxWidth: 512,
      imageQuality: 90,
    );

    final uid = FirebaseAuth.instance.currentUser!.uid;
    Reference ref = FirebaseStorage.instance
        .ref().child("profilepic$uid.jpg");

    await ref.putFile(File(image!.path));

    ref.getDownloadURL().then((value) async {
      setState(() {
        profilePicLink = value;
      });
    });
  }


  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            _showPicker(context);
          },
          child: Container(
            margin: const EdgeInsets.only(top: 80, bottom: 24),
            height: 120,
            width: 120,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.purple,
            ),
            child: Center(
              child: profilePicLink == "" ? const Icon(
                Icons.person,
                color: Colors.white,
                size: 80,
              ) : ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.network(profilePicLink),
              ),
            ),
          ),
        ),

      ],
    );
  }
  void _showPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Wrap(
              children: <Widget>[
                ListTile(
                    leading: const Icon(Icons.photo_library),
                    title: const Text('Gallery'),
                    onTap: () {
                      imgFromGallery();
                      Navigator.of(context).pop();
                    }),
                ListTile(
                  leading: const Icon(Icons.photo_camera),
                  title: const Text('Camera'),
                  onTap: () {
                    imgFromCamera();
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          );
        });
  }
}