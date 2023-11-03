import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';

import '../../model/user.dart';
import '../../screens/auth/login.dart';
import '../../screens/profile.dart';
import '../../screens/search.dart';
import '../images.dart';
class CustomAppBar extends StatelessWidget {
  final String title;
  final Color? bgColor;
  final bool isTrailingVisible;
  const CustomAppBar(
      {Key? key,
        this.title = "Find Your Partner",
        this.isTrailingVisible = true,
        this.bgColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(
            Icons.arrow_back,
            size: 30,
          )),
      flexibleSpace: Container(
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
              bottomRight: Radius.circular(25),
              bottomLeft: Radius.circular(25)),
          image: DecorationImage(
            image: AssetImage(image_appbar_bg),
            fit: BoxFit.fill,
          ),
        ),
      ),
      backgroundColor: bgColor ?? Colors.greenAccent.withOpacity(.6),
      title: Text(
        title,
        textAlign: TextAlign.center,
        style: const TextStyle(fontWeight: FontWeight.w800, letterSpacing: 2),
      ),
      elevation: 0,
      actions: isTrailingVisible
          ? [
        IconButton(
            onPressed: () {
              Navigator.pushNamed(context, SearchScreen.routeName);
            },
            icon: const Icon(
              Icons.search_sharp,
              size: 30,
            )),
        IconButton(
            onPressed: () {
              Navigator.pushNamed(context, ProfileScreen.routeName);
            },
            icon: const Icon(
              Icons.account_circle_rounded,
              color: Colors.white,
              size: 35,
            )),
        const SizedBox(
          width: 10,
        )
      ]
          : [
        // IconButton(onPressed: (){}, icon: Icon(Icons.logout_outlined,size: 15,)),
        InkWell(
            onTap: () => _logout(context),
            child: const Text(
              "Logout",
              style: TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.w800,
              ),
              textAlign: TextAlign.center,
            )),
        const SizedBox(
          width: 20,
        )
      ],
    );
  }

  _logout(BuildContext context) {
    final userList = Hive.box<UserModel>('userdb');

    userList.clear();

    userList.delete(userList.values);
    FirebaseAuth.instance.signOut();

    Navigator.of(context)
        .pushNamedAndRemoveUntil(UserLoginScreen.routeName, (route) => false)
        .then((value) async {
      await FirebaseAuth.instance.signOut();
    });
  }
}