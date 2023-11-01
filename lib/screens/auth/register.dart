import 'package:bridesandgrooms/screens/home.dart';
import 'package:bridesandgrooms/utils/images.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';

import '../../model/user.dart';
import '../../utils/components/customButton.dart';
import '../../utils/components/textInput.dart';
import '../profile.dart';
import 'login.dart';

/*class RegisterScreen extends StatefulWidget {
  static const routeName = "/registerScreen";

  const RegisterScreen({Key? key}) : super(key: key);

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  late TextEditingController _email;
  late TextEditingController _password;
  late TextEditingController _name;
  late TextEditingController _mobile;
  final formKey = GlobalKey<FormState>();
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  DatabaseReference dbRef = FirebaseDatabase.instance.ref().child("Users");

  @override
  void initState() {
    super.initState();

    _email = TextEditingController();
    _password = TextEditingController();
    _name = TextEditingController();
    _mobile = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.purple.withOpacity(.6),
      appBar: AppBar(
        title: Center(
          child: Text(
            "Register ",
            style: Theme.of(context).textTheme.headline6!.copyWith(
                color: Colors.white,
                fontSize: 25,
                fontWeight: FontWeight.w800,
                letterSpacing: 2.5),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage(image_bg1), fit: BoxFit.fill)),
          child: Column(
            children: [
              Container(
                height: MediaQuery.of(context).size.height / 3,
                decoration: const BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage(image_logbg), fit: BoxFit.fitHeight)),
              ),
              Container(
                // margin: EdgeInsets.only(left: 20, right: 20),
                alignment: Alignment.center,
                color: Colors.purpleAccent.withOpacity(0.2),
                child: Padding(
                  padding: const EdgeInsets.all(25),
                  child: Form(
                    key: formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        FormFieldText(
                          title: "Enter Email",
                          hintText: "abc@xyz.com",
                          controller: _email,
                        ),
                        FormFieldText(
                          title: "Enter Name",
                          hintText: "",
                          controller: _name,
                        ),
                        FormFieldText(
                          title: "Enter Mobile",
                          hintText: "+91",
                          controller: _mobile,
                        ),
                        FormFieldText(
                          title: "Enter Password",
                          hintText: "*******",
                          controller: _password,
                          obscureText: true,
                        ),
                        const Text(
                          "Gender",
                          style: TextStyle(
                              fontWeight: FontWeight.w900,
                              fontSize: 25,
                              letterSpacing: 2.1,
                              wordSpacing: 1.5,
                              color: Colors.white),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Row(
                          children: <Widget>[
                            addRadioButton(0, 'Bride'),
                            addRadioButton(1, 'Groom'),
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        AuthButton(
                          title: "Register",
                          onPressed: () async {
                            final form = formKey.currentState!;
                            if (form.validate()) {
                              registerWithEmail();
                            }
                          },
                        ),
                        const SizedBox(
                          height: 25,
                        ),
                        AuthButton(
                            title: "Login Here",
                            onPressed: () => Navigator.pushNamed(
                                context, UserLoginScreen.routeName)),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 20.0,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void registerWithEmail() {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;
    firebaseAuth
        .createUserWithEmailAndPassword(
            email: _email.text, password: _password.text)
        .then((value) async {
          User? user = _auth.currentUser;
          String uid = user!.uid;
          await _firestore.collection('users').doc(uid).set({
            'name': _name.text,
            'email': _email.text,
            'gender': selectedGender,
            'mobile': _mobile.text,
          });
        })
        .whenComplete(
            () => Navigator.pushNamed(context, ProfileScreen.routeName))
        .catchError((err) {
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
              color: Colors.white, fontWeight: FontWeight.w500, fontSize: 20),
        )
      ],
    );
  }
}*/

/*class AuthButton extends StatefulWidget {
  final String title;
  final void Function()? onPressed;
  const AuthButton({
    Key? key,
    required this.title,
    required this.onPressed,
  }) : super(key: key);

  @override
  _AuthButtonState createState() => _AuthButtonState();
}

class _AuthButtonState extends State<AuthButton> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 44,
      child: ElevatedButton(
        onPressed: widget.onPressed,
        style: ButtonStyle(
            padding: MaterialStateProperty.all<EdgeInsets>(
                const EdgeInsets.symmetric(horizontal: 15, vertical: 10)),
            backgroundColor:
                MaterialStatePropertyAll<Color>(Colors.black.withOpacity(.4))),
        child: Text(widget.title,
            style: const TextStyle(
                fontSize: 18,
                color: Colors.white,
                fontWeight: FontWeight.w700)),
      ),
    );
  }
}*/

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
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

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
                  )
                  //ImgProvider(url: icon_city_store,height:26,width:110,)
                  ),
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
        .then((value)  {
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
        })
        .catchError((err) {
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