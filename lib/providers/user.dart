import 'package:bridesandgrooms/model/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:hive_flutter/hive_flutter.dart';

class UserProvider with ChangeNotifier {
  List<UserModel> filteredUsers = [];

  Future<List<UserModel>> getUsersFromFirestore() async {
    final fireStoreData = await FirebaseFirestore.instance.collection('users').get();
    final userList = fireStoreData.docs.map((doc) {
      final userData = doc.data();
      return UserModel(
          name: userData['name'],
          email: userData['email'],
          gender: userData['gender'],
          mobile: userData['mobile'],
          location: userData['location'],
          age: userData['age']);
    }).toList();
    notifyListeners();
    return userList;
  }

  Future<void> addUsersToHiveBox(List<UserModel> userList) async {
    final box = await Hive.openBox<UserModel>('userdb');
    box.clear();
    box.addAll(userList);
    await box.close();
    notifyListeners();
  }

  Future<void> searchFilter(double maxHeight,double maxWeight,String searchLocation)async{
    final userBox = Hive.box<UserModel>('userdb');
     filteredUsers = userBox.values.where((user) {
      return (user.gender != user.gender) &&
          (user.height != null && user.height! <= maxHeight) &&
          (user.weight != null && double.parse(user.weight!) <= maxWeight) &&
          user.location! == searchLocation;
    }).toList();
    //notifyListeners();

  }
  
}
