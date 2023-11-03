import 'package:bridesandgrooms/screens/home.dart';
import 'package:bridesandgrooms/utils/components/customButton.dart';
import 'package:bridesandgrooms/utils/components/pic_upload.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:provider/provider.dart';
import 'dart:io';
import '../providers/user.dart';
import '../utils/components/custom_app_bar.dart';
import '../utils/components/form_field.dart';
import 'auth/register.dart';

class ProfileScreen extends StatefulWidget {
  static const routeName = "/profile";
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late TextEditingController _name;
  late TextEditingController _age;
  late TextEditingController _email;
  late TextEditingController _dob;
  late TextEditingController _mobile;
  late TextEditingController _location;
  late TextEditingController _height;
  late TextEditingController _weight;
  String? selectedGender;
  String? url;
  final newKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldMessengerState> _scaffoldKey =
      GlobalKey<ScaffoldMessengerState>();

  @override
  void initState() {
    super.initState();
    _name = TextEditingController();
    _age = TextEditingController();
    _email = TextEditingController();
    _dob = TextEditingController();
    _mobile = TextEditingController();
    _location = TextEditingController();
    _height = TextEditingController();
    _weight = TextEditingController();
    final user = FirebaseAuth.instance.currentUser;
    if (user!.uid != null) {
      getUserDetails(user.uid).then((value) {
        if(value!=null){
          Provider.of<UserProvider>(context,listen:false).setProfileImage(url!);
        }
      });
      print(user);
    }
  }

  Future<Map<String, dynamic>?> getUserDetails(String uid) async {
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;
    DocumentSnapshot doc = await _firestore.collection('users').doc(uid).get();
    if (doc.exists) {
      final Map<String, dynamic> user = doc.data() as Map<String, dynamic>;
      _name.text = user['name'] ;
      _email.text = user["email"];
      _age.text = user["age"] ?? "";
      _height.text = user["height"] ?? "";
      _weight.text = user["weight"] ?? "";
      _dob.text = user["dob"] ?? "";
      _mobile.text = user["mobile"] ?? "";
      _location.text = user["location"] ?? "";
      selectedGender = user["gender"];
      url=user["profileUrl"];


      print("user name = ${user["name"]}");
      print("user email = ${user["email"]}");
      print("user gender = ${user["gender"]}");
      print("user mobile = ${user["mobile"]}");
      print("user profile= ${user["profile"]}");
    } else {
      return null;
    }
    return null;
  }
  String? selectedHeight;
  String? selectedWeight;
  String? selectedLocation;

  bool isEditable = false;
  File? _imageFile;
  int selectedId = 1;
  bool _loading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(
          preferredSize: Size.fromHeight(80),
          child: CustomAppBar(
            title: "MY PROFILE",
            bgColor: Colors.white,
            isTrailingVisible: false,
          )),
      body: ListView(
        children: [
          const SizedBox(height: 50),
          const Align(
              alignment: Alignment.center,
              child: ProfilePicUploadWidget()),
          const SizedBox(height: 50),
          Form(
            key: newKey,
            child: Column(
              children: [
                const SizedBox(height: 30),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Personal Information",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w400),
                      ),
                      isEditable
                          ? InkWell(
                              onTap: () {
                                if (newKey.currentState!.validate()) {
                                  editProfile();
                                  setState(() {
                                    isEditable = false;
                                  });
                                }
                              },
                              child: const Text(
                                "Save",
                                style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: 0.1,
                                    fontSize: 14,
                                    color: Colors.green),
                              ),
                            )
                          : InkWell(
                              onTap: () {
                                setState(() {
                                  isEditable = true;
                                });
                              },
                              child: const Text(
                                "Edit",
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 0.3,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 25,
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  color: Colors.white,
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 21,
                      ),
                      FormTextField(
                          controller: _name,
                          titleHint: "Name",
                          enabled: isEditable ? true : false,
                          hint: "Enter Your Name",
                          formatter: MaskTextInputFormatter()),
                      FormTextField(
                          controller: _age,
                          titleHint: "Enter Age",
                          enabled: isEditable ? true : false,
                          hint: "Enter Your Age",
                          formatter: MaskTextInputFormatter()),
                      FormTextField(
                          controller: _height,
                          titleHint: "Height",
                          enabled: isEditable ? true : false,
                          hint: "Enter your Height",
                          formatter: MaskTextInputFormatter()),

                      FormTextField(
                          controller: _weight,
                          titleHint: "Weight",
                          enabled: isEditable ? true : false,
                          hint: "Enter Your Weight",
                          formatter: MaskTextInputFormatter()),
                      FormTextField(
                          controller: _dob,
                          titleHint: "Date of Birth",
                          enabled: isEditable ? true : false,
                          hint: "DD-MM-YYYY",
                          formatter: MaskTextInputFormatter(mask: "##-##-####"),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return null;
                            }
                            final components = value.split("-");
                            if (components.length == 3) {
                              final day = int.tryParse(components[0]);
                              final month = int.tryParse(components[1]);
                              final year = int.tryParse(components[2]);
                              if (day != null &&
                                  month != null &&
                                  year != null) {
                                final date = DateTime(year, month, day);
                                if (date.year == year &&
                                    date.month == month &&
                                    date.day == day) {
                                  return null;
                                }
                              }
                            }
                            return "DD-MM-YYYY";
                          }),
                      const Text("Select Bride/Groom",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          )),
                      const SizedBox(
                        height: 5.0,
                      ),
                      Row(
                        children: <Widget>[
                          addRadioButton(0, 'Bride'),
                          addRadioButton(1, 'Groom'),
                        ],
                      ),
                      const SizedBox(
                        height: 25,
                      ),
                      const Text(
                        "Contact Information",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      FormTextField(
                          controller: _email,
                          titleHint: "Email",
                          enabled: false,
                          hint: "Enter your Email",
                          formatter: MaskTextInputFormatter()),
                      FormTextField(
                          controller: _mobile,
                          titleHint: "Phone",
                          enabled:isEditable ? true : false,
                          hint: "Enter Mobile number",
                          validator: (value) {
                            if (!isPhone(value!)) {
                              return "Enter valid mobile number";
                            }
                            return null;
                          },
                          formatter: MaskTextInputFormatter()),
                      FormTextField(
                        controller: _location,
                        titleHint: "Location",
                        enabled: isEditable ? true : false,
                        hint: "Enter Location",
                        formatter: MaskTextInputFormatter(),
                      ),
                      const SizedBox(
                        height: 25,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 50.0),
                  child: Button(
                    title: "Save",
                    buttonStyle: const TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.w800),
                    loading: _loading,
                    onPressed: () async {
                      if (newKey.currentState!.validate()) {

                        await editProfile();
                        setState(() {
                            isEditable = false; });
                      }
                    },
                    radius: 5,
                  ),
                ),
                const SizedBox(height: 50,)
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> editProfile() async {
    try {
      final FirebaseAuth _auth = FirebaseAuth.instance;
      final FirebaseFirestore _firestore = FirebaseFirestore.instance;
      User? user = _auth.currentUser;
      String uid = user!.uid;

      await _firestore.collection('users').doc(uid).set({
        'name': _name.text,
        'email': _email.text,
        'gender': selectedGender,
        'mobile': _mobile.text,
        'age': _age.text,
        'height': _height.text,
        'weight': _weight.text,
        'dob': _dob.text,
        'location': _location.text,
      });
    } catch (err) {
      _scaffoldKey.currentState?.showSnackBar(SnackBar(
          content: Text(err.toString()), duration: const Duration(seconds: 3)));
    }
  }

  List gender = [
    "Bride",
    "Groom",
  ];
  Row addRadioButton(int value, String title) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Radio(
          activeColor: Theme.of(context).primaryColor,
          value: gender[value],
          groupValue: selectedGender,
          onChanged: (value) {
            setState(() {
              print(value);
              selectedGender = value;
            });
          },
        ),
        Text(
          title,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        )
      ],
    );
  }
}

/*
class ProfileImage extends StatefulWidget {
  const ProfileImage({Key? key}) : super(key: key);

  @override
  State<ProfileImage> createState() => _ProfileImageState();
}

class _ProfileImageState extends State<ProfileImage> {
  File? _imageFile;
  final ImagePicker _picker = ImagePicker();

  bottomSheetGallery() {
    return Container(
      height: 200,
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Column(
        children: [
          Text("Choose profile picture",
              style: Theme.of(context)
                  .textTheme
                  .headline4
                  ?.copyWith(fontWeight: FontWeight.w400)),
          const SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton.icon(
                onPressed: () {
                  getImageFromCamera();
                },
                icon: const Icon(Icons.camera),
                label: const Text("Camera"),
              ),
              TextButton.icon(
                onPressed: () {
                  getImageFromGallery();
                },
                icon: const Icon(Icons.image),
                label: const Text("Gallery"),
              ),
            ],
          )
        ],
      ),
    );
  }

  Future getImageFromGallery() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _imageFile = File(pickedFile.path);
      }
    });
  }

  Future<void> getImageFromCamera() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.camera);

    setState(() {
      if (pickedFile != null) {
        _imageFile = File(pickedFile.path);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Consumer<UserProvider>(builder: (context, value, child) {
        final currentUser = value.currentUser[0];
        return value.currentUser.isEmpty
            ? CircleAvatar(
                radius: 48,
              )
            : Stack(
                children: [
                  _imageFile == null
                      ? (currentUser.profilePic != null
                          ? CircleAvatar(
                              radius: 48,
                              backgroundColor: Colors.purple.withOpacity(0.3),
                              backgroundImage:
                                  NetworkImage(currentUser.profilePic!),
                            )
                          : CircleAvatar(
                              radius: 48,
                              backgroundColor: Colors.purple.withOpacity(0.3),
                              child: SvgPicture.asset(icon_edit),
                            ))
                      : CircleAvatar(
                          radius: 48,
                          backgroundColor: Colors.purple.withOpacity(0.3),
                          backgroundImage: FileImage(File(_imageFile!.path)),
                        ),
                  Positioned(
                    top: 64.0,
                    left: 64.0,
                    child: CircleAvatar(
                      radius: 16,
                      backgroundColor: Colors.purple,
                      child: InkWell(
                        child: SvgPicture.asset(icon_edit),
                        onTap: () {
                          showModalBottomSheet(
                              context: context,
                              builder: (builder) => bottomSheetGallery());
                        },
                      ),
                    ),
                  ),
                ],
              );
      }),
    );
  }
}
*/
