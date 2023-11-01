import 'package:hive_flutter/adapters.dart';
part 'user.g.dart';

@HiveType(typeId: 1)
class UserModel {
  @HiveField(0)
  String? name;
  @HiveField(1)
  String? profilePic;
  @HiveField(2)
  String? mobile;
  @HiveField(3)
  String? age;
  @HiveField(4)
  double? height;
  @HiveField(5)
  String? weight;
  @HiveField(6)
  String? gender;
  @HiveField(7)
  String? email;
  @HiveField(8)
  String? password;
  @HiveField(9)
  String? location;

  UserModel(
      {this.name,
      this.email,
      this.gender,
      this.mobile,
      this.age,
      this.location,
      this.weight,
      this.height,
      this.profilePic});

/*  UserModel.fromJson(Map<String, dynamic> json)
      : name = json["name"] ?? "",
        profilePic = json["profilePic"],
        mobile = json["mobile"],
        age = json["age"] ?? 0,
        height = json["height"] ?? 0.0,
        weight = json["weight"] ?? 0.0,
        gender = json["gender"] ?? " ",
        email = json["email"] ?? "",
        password = json["password"] ?? "",
        location = json["location"] ?? "";

  static List<UserModel> convertToList(List<dynamic> list) {
    return list.map((e) => UserModel.fromJson(e)).toList();
  }*/
}
