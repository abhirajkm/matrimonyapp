import 'package:bridesandgrooms/providers/user.dart';
import 'package:bridesandgrooms/screens/auth/login.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import '../images.dart';

class AppBackButton extends StatelessWidget {
  final String title;
  const AppBackButton({
    Key? key, required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoSliverNavigationBar(

      largeTitle: Padding(
        padding: const EdgeInsets.only(left: 4.0),
        child: Text(
          title,
        ),
      ),
      
      leading: InkWell(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: SvgPicture.asset(icon_back_button)),
      trailing: InkWell(
        onTap: ()async{
          FirebaseAuth authService = FirebaseAuth.instance;
          await authService.signOut();
          Navigator.pushReplacementNamed(context, UserLoginScreen.routeName);

        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: const [
            Text("LOGOUT",style: TextStyle(fontWeight: FontWeight.w800),),
            Icon(Icons.logout_rounded,size: 25,),
            SizedBox(width: 10,)
          ],
        ),
      ),
      border: const Border(bottom: BorderSide.none),
      transitionBetweenRoutes: false,
      padding:
      const EdgeInsetsDirectional.only(end: 8.0, top: 4.0, bottom: 8.0, start: 20.0),
    );
  }
}
