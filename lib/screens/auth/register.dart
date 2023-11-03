import 'package:bridesandgrooms/utils/images.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';

import '../../utils/components/customButton.dart';
import '../../utils/components/textInput.dart';
import 'login.dart';

class UserRegisterScreen extends StatefulWidget {
  static const routeName = "/registerscreen";
  const UserRegisterScreen({Key? key}) : super(key: key);

  @override
  _UserRegisterScreenState createState() => _UserRegisterScreenState();
}

class _UserRegisterScreenState extends State<UserRegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  bool signedIn = false;
  late TextEditingController _email;
  late TextEditingController _password;
  late TextEditingController _name;
  late TextEditingController _mobile;
  final formKey = GlobalKey<FormState>();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    _email = TextEditingController();
    _password = TextEditingController();
    _name = TextEditingController();
    _mobile = TextEditingController();
  }

  bool value = false;
  bool _loading = false;
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        body: Container(
          decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage(image_blur), fit: BoxFit.fill)),
          height: height,
          width: width,
          child: ListView(
            children: [
              SizedBox(
                  height: height / 2.5,
                  child: Image.asset(
                    image_logbg,
                    height: 26,
                    fit: BoxFit.fill,
                  )),
              const SizedBox(
                height: 10,
              ),
              Column(
                children: [
                  Container(
                    margin: const EdgeInsets.only(left: 20, right: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const Text("Registration",
                            style: TextStyle(
                                fontSize: 26,
                                color: Colors.black,
                                fontWeight: FontWeight.w600)),
                        const SizedBox(height: 15),
                        Form(
                            autovalidateMode: signedIn
                                ? AutovalidateMode.onUserInteraction
                                : AutovalidateMode.disabled,
                            key: _formKey,
                            child: Column(
                              children: [
                                AuthTextInput(
                                  validator: MultiValidator([
                                    RequiredValidator(errorText: "Required"),
                                  ]),
                                  hintText: "Enter Email",
                                  controller: _email,
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                AuthTextInput(
                                  validator: MultiValidator([
                                    RequiredValidator(errorText: "Required"),
                                  ]),
                                  hintText: "Enter Name",
                                  controller: _name,
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                AuthTextInput(
                                  validator: (value) {
                                    if (!isPhone(value!)) {
                                      return "Enter valid mobile number";
                                    }
                                    return null;
                                  },
                                  hintText: "Enter Mobile",
                                  controller: _mobile,
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                AuthTextInput(
                                  validator: MultiValidator([
                                    RequiredValidator(errorText: "Required"),
                                  ]),
                                  hintText: "Enter password",
                                  controller: _password,
                                  obscureText: true,
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                              ],
                            )),
                        const SizedBox(
                          height: 5,
                        ),
                        const Text(
                          "  Gender",
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 15,
                          ),
                        ),
                        Row(
                          children: <Widget>[
                            addRadioButton(0, 'Bride'),
                            addRadioButton(1, 'Groom'),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 15.0),
                child: Container(
                  margin: const EdgeInsets.only(left: 20, right: 20),
                  child: Button(
                    radius: 5,
                    title: "Register",
                    buttonStyle: const TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.w800),
                    loading: _loading,
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        setState(() {
                          _loading = true;
                        });
                        await register();
                        setState(() {
                          _loading = false;
                        });
                      }
                      setState(() {
                        signedIn = true;
                      });
                    },
                    color: Colors.purple,
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Existing user ?",
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  InkWell(
                      onTap: () {
                        Navigator.pushReplacementNamed(
                            context, UserLoginScreen.routeName);
                      },
                      child: const Text("Login",
                          style: TextStyle(
                              color: Colors.green,
                              fontSize: 14,
                              decoration: TextDecoration.underline,
                              fontWeight: FontWeight.w700))),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }

  List gender = [
    "Bride",
    "Groom",
  ];
  String? selectedGender;
  Row addRadioButton(int value, String title) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Radio(
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
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
          style: const TextStyle(fontWeight: FontWeight.w400, fontSize: 13),
        )
      ],
    );
  }

  Future<void> register() async {
    await _auth
        .createUserWithEmailAndPassword(
            email: _email.text, password: _password.text)
        .then((value) {
      final FirebaseAuth _auth = FirebaseAuth.instance;
      final FirebaseFirestore _firestore = FirebaseFirestore.instance;
      User? user = _auth.currentUser;
      String uid = user!.uid;
      _firestore.collection('users').doc(uid).set({
        'name': _name.text,
        'email': _email.text,
        'gender': selectedGender,
        'mobile': _mobile.text,
      });

      print("user name = ${_name}");
      print("user email = ${_email.text}");
      print("user gender = ${selectedGender}");
      print("user mobile = ${_mobile}");
      Navigator.pushNamed(context, UserLoginScreen.routeName);
    }).catchError((err) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text("Error"),
              content: Text(err.message),
              actions: [
                TextButton(
                  child: const Text("Ok"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                )
              ],
            );
          });
    });
  }
}

bool isPhone(String input) =>
    RegExp(r'^[\+]?[(]?[0-9]{3}[)]?[-\s\.]?[0-9]{3}[-\s\.]?[0-9]{4,6}$')
        .hasMatch(input);
