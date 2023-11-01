import 'package:bridesandgrooms/screens/auth/register.dart';
import 'package:bridesandgrooms/screens/home.dart';
import 'package:bridesandgrooms/utils/images.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:hive_flutter/adapters.dart';

import '../../model/user.dart';
import '../../utils/components/customButton.dart';
import '../../utils/components/textInput.dart';


class UserLoginScreen extends StatefulWidget {
  static const routeName = "/loginpage";
  const UserLoginScreen({Key? key}) : super(key: key);

  @override
  _UserLoginScreenState createState() => _UserLoginScreenState();
}

class _UserLoginScreenState extends State<UserLoginScreen> {
  final _formKey = GlobalKey<FormState>();
  bool loggedIn = false;
  late TextEditingController _email;
  late TextEditingController _password;

  FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();

    _email = TextEditingController();
    _password = TextEditingController();
  }

  bool _loading = false;
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        child: Container(
          decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage(image_blur), fit: BoxFit.fill)),
          height: height,
          width: width,
          child: Column(
            children: [
              SizedBox(
                  height: height / 2.5,
                  child: Image.asset(
                    image_logbg,
                    height: 26,
                    fit: BoxFit.fill,
                  )),
              Expanded(
                child: Container(
                  margin: EdgeInsets.only(left: 20, right: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const SizedBox(height: 10,),
                      const Text(
                          "Welcome....\nLogin To Find Your\nPartner",
                          style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.w600)),
                      const SizedBox(height: 15),
                      Form(
                          key: _formKey,
                          autovalidateMode: loggedIn
                              ? AutovalidateMode.onUserInteraction
                              : AutovalidateMode.disabled,
                          child: Column(
                            children: [
                              AuthTextInput(
                                controller: _email,
                                validator: EmailValidator(errorText: 'enter a valid email address'),
                                hintText: "Enter Email",
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              AuthTextInput(
                                controller: _password,
                                obscureText: true,
                                validator: MultiValidator([
                                  RequiredValidator(
                                      errorText:"Required"
                                      ),
                                ]),
                                hintText: "Enter Password",
                              ),
                            ],
                          )),
                      const SizedBox(
                        height: 15,
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 15.0),
                child: Container(
                  margin: const EdgeInsets.only(left: 20, right: 20),
                  child: Button(


                    title: "Login",
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
                        await loginUser();
                        setState(() {
                          _loading = false;
                        });
                      }
                      setState(() {
                        loggedIn = true;
                      });
                    },
                    radius: 5,
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Don't have an account?",
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  InkWell(
                      onTap: () {
                        Navigator.pushNamed(context, UserRegisterScreen.routeName);
                      },
                      child: const Text("Register Here",
                          style: TextStyle(
                              color: Colors.green,
                              fontSize: 14,
                              decoration: TextDecoration.underline,
                              fontWeight: FontWeight.w700))),
                ],
              ),
              const SizedBox(
                height: 20,
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> loginUser() async {
    try {
     // final provider=Provider.of<UserProvider>(context,listen:false);
      final user = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _email.text, password: _password.text

      ).then((value) async{

        await Hive.openBox<UserModel>('userdb');
        await Hive.box<UserModel>('userdb');
        Navigator.pushNamed(context, HomeScreen.routeName);});

    } catch (e) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text("Error"),
              content: Text(e.toString()),
              actions: [
                TextButton(
                    child: const Text("Register Now"),
                    onPressed: () => Navigator.pop(context)),
              ],
            );
          });
      print('Login error: $e');
    }
  }
}
