import 'package:bridesandgrooms/model/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';

class UserProvider with ChangeNotifier {
  List<UserModel> filteredUsers = [];
  List<UserModel> homeList = [];
  Box<UserModel> data = Hive.box<UserModel>('userdb');
  String imageUrl = "";

  void setProfileImage(String url) {
    imageUrl = url;
    // notifyListeners();
  }

  Future<List<UserModel>> getUsersFromFirestore() async {
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
    addUsersToHiveBox(userList);
    notifyListeners();
    return userList;
  }

  Future<Box<UserModel>> addUsersToHiveBox(List<UserModel> userList) async {
    final box = Hive.box<UserModel>('userdb');
    if (box.isNotEmpty) {
      box.clear();
    } else {
      data.clear();
      data.addAll(userList);
    }

    notifyListeners();
    return data;
  }

  Future<void> fetchData() async {
    if (homeList.isNotEmpty) {
      homeList.clear();
    }
    homeList.addAll(data.values);

    //notifyListeners();
  }

  Future<List<UserModel>> searchFilter(
      double maxHeight, double maxWeight, String searchLocation) async {
    final userBox = Hive.box<UserModel>('userdb');
    final data = userBox.values.where((user) {
      if (kDebugMode) {
        print(user.height);
      }
      return (user.height != null && double.parse(user.height!) <= maxHeight) &&
          (user.weight != null && double.parse(user.weight!) <= maxWeight) &&
          user.location! == searchLocation;
    }).toList();
    filteredUsers.addAll(data);
    notifyListeners();
    return filteredUsers;
  }
}
