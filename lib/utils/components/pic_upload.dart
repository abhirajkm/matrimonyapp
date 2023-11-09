
import 'package:bridesandgrooms/model/user.dart';
import 'package:bridesandgrooms/providers/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import 'package:provider/provider.dart';

class ProfilePicUploadWidget extends StatefulWidget {
  const ProfilePicUploadWidget({Key? key,}) : super(key: key);

  @override
  _ProfilePicUploadWidgetState createState() => _ProfilePicUploadWidgetState();
}

class _ProfilePicUploadWidgetState extends State<ProfilePicUploadWidget> {
  double screenHeight = 0;
  double screenWidth = 0;
  final ImagePicker _picker = ImagePicker();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;



  Future imgFromGallery() async {
    final pickedFile = await _picker.pickImage(
        imageQuality: 50,
        source: ImageSource.gallery);
    final uid = FirebaseAuth.instance.currentUser!.uid;
    Reference ref = FirebaseStorage.instance
        .ref().child("profilepic$uid.jpg");

    await ref.putFile(File(pickedFile!.path));

    ref.getDownloadURL().then((value) async {
      Provider.of<UserProvider>(context,listen:false).setProfileImage(value);
      await _firestore.collection("users").doc(uid).update({
        "profileUrl" : value
      });

    });



  }

  Future imgFromCamera() async {
    final pickedFile = await _picker.pickImage(
        source: ImageSource.camera,
       imageQuality: 50
    );
    final uid = FirebaseAuth.instance.currentUser!.uid;
    Reference ref = FirebaseStorage.instance
        .ref().child("profilepic$uid.jpg");

    await ref.putFile(File(pickedFile!.path));

    ref.getDownloadURL().then((value) async {
      Provider.of<UserProvider>(context,listen:false).setProfileImage(value);
      await _firestore.collection("users").doc(uid).update({
        "profileUrl" : value
      });
    });

  }




@override
  void initState() {
  final uid = FirebaseAuth.instance.currentUser!.uid;
  final provider = Provider.of<UserProvider>(context,listen:false);
  provider.resetImage();
    getUserDetails(uid).then((value) {

    });
    super.initState();
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
              color: Colors.purple.withOpacity(.5),
            ),
            child:
            Consumer<UserProvider>(
              builder: (context,user,child) {

                return Center(
                  child: user.imageUrl.isEmpty ? const Icon(
                    Icons.person,
                    color: Colors.white,
                    size: 80,
                  ) : ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.network(user.imageUrl,fit: BoxFit.fill,),
                  ),
                );
              }
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
  Future<Map<String, dynamic>?> getUserDetails(String uid) async {
    final provider = Provider.of<UserProvider>(context,listen:false);
    DocumentSnapshot doc = await _firestore.collection('users').doc(uid).get();
    if (doc.exists) {

      final Map<String, dynamic> user = doc.data() as Map<String, dynamic>;
      final url = user['profileUrl'] ;
      final profileImageUrl = url;

      final userBox = await Hive.openBox<UserModel>('userdb');
      final currentUser = userBox.get('currentUser');

      if (currentUser != null) {
        final updatedUser = UserModel(
          profileUrl: profileImageUrl,
        );
        userBox.put('currentUser', updatedUser);
      }
      provider.setProfileImage(url);


      print("user name = ${user["name"]}");
      print("user email = ${user["email"]}");
      print("user gender = ${user["gender"]}");
      print("user mobile = ${user["mobile"]}");
      print("user profile= ${user["profileUrl"]}");

    }
    else {
      return null;
    }
    return null;
  }

  Future<String?> getImageFromHive() async {
    final userBox = await Hive.openBox<UserModel>('userdb');
    final currentUser = userBox.get('currentUser');
    if (currentUser!=null) {
      return currentUser.profileUrl;
    }
    return null;
  }
}