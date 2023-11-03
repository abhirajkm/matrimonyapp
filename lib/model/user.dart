import 'package:hive_flutter/adapters.dart';
part 'user.g.dart';

@HiveType(typeId: 1)
class UserModel {
  @HiveField(0)
  String? name;
  @HiveField(1)
  String? profileUrl;
  @HiveField(2)
  String? mobile;
  @HiveField(3)
  String? age;
  @HiveField(4)
  String? height;
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
      this.profileUrl});


}
