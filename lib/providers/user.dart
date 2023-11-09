import 'package:bridesandgrooms/model/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';

class UserProvider with ChangeNotifier {
  List<UserModel> filteredUsers = [];
  List<UserModel> firebaseList = [];
  Box<UserModel> data = Hive.box<UserModel>('userdb');
  String imageUrl = "";

  UserModel? localUser;

  void setProfileImage(String url) {
    imageUrl = url;
    notifyListeners();
  }
  void resetImage(){
    imageUrl="";
  }

  void reset() {
    firebaseList.clear();
  }

  Future<UserModel?> getUserDetails() async {
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;
    final user = FirebaseAuth.instance.currentUser;

    DocumentSnapshot doc =
        await _firestore.collection('users').doc(user?.uid).get();
    if (doc.exists) {
      final Map<String, dynamic> userData = doc.data() as Map<String, dynamic>;
      final user = UserModel(
          name: userData['name'],
          email: userData['email'],
          gender: userData['gender'],
          mobile: userData['mobile'],
          location: userData['location'],
          height: userData['height'],
          weight: userData['weight'],
          profileUrl: userData["profileUrl"],
          age: userData['age']);
      notifyListeners();
      return user;
    } else {
      return null;
    }

  }

  Future<void> getImageFromHive() async {

    final userBox = await Hive.openBox<UserModel>('userdb');
    final currentUser = userBox.get('currentUser');

    if (currentUser != null) {
      final updatedUser = UserModel(
        profileUrl: imageUrl,
      );
      userBox.put('currentUser', updatedUser);
    }
  }



  Future<List<UserModel>> fetchFromFirestore() async {
    final fireStoreData =
        await FirebaseFirestore.instance.collection('users').get();
    final userList = fireStoreData.docs.map((doc) {
      final userData = doc.data();
      return UserModel(
          name: userData['name'],
          email: userData['email'],
          gender: userData['gender'],
          mobile: userData['mobile'],
          location: userData['location'],
          height: userData['height'],
          weight: userData['weight'],
          profileUrl: userData["profileUrl"],
          age: userData['age']);
    }).toList();
    if (firebaseList.isEmpty) {
      firebaseList.addAll(userList);
    } else {
      firebaseList = [];
      firebaseList.clear();
    }
    notifyListeners();
    return firebaseList;
  }

  Future<List<UserModel>> searchFireFilter(
      double maxHeight, double maxWeight, String searchLocation) async {
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;
    final user = FirebaseAuth.instance.currentUser;
    DocumentSnapshot doc =
        await _firestore.collection('users').doc(user?.uid).get();
    final Map<String, dynamic> userData = doc.data() as Map<String, dynamic>;
    final data = firebaseList.where((user) {
      if (kDebugMode) {
        print(user.height);
      }
      return (user.height != null && double.parse(user.height!) <= maxHeight) &&
          (userData != null && user.gender != userData["gender"]) &&
          (user.weight != null && double.parse(user.weight!) <= maxWeight) &&
          user.location! == searchLocation;
    }).toList();
    filteredUsers.addAll(data);
    notifyListeners();
    return filteredUsers;
  }




  void resetSearch() {
    filteredUsers.clear();
    notifyListeners();
  }


}
