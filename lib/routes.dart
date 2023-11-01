
import 'package:bridesandgrooms/screens/auth/login.dart';
import 'package:bridesandgrooms/screens/auth/register.dart';
import 'package:bridesandgrooms/screens/home.dart';
import 'package:bridesandgrooms/screens/profile.dart';
import 'package:bridesandgrooms/screens/search.dart';
import 'package:flutter/material.dart';

class AppRoutes {
  static Map<String, Widget Function(BuildContext)> get(BuildContext context) {
    return {
      UserLoginScreen.routeName: (context) =>const UserLoginScreen(),
      UserRegisterScreen.routeName:(context)=> const UserRegisterScreen(),
      ProfileScreen.routeName:(context)=>const ProfileScreen(),
      HomeScreen.routeName:(context)=>const HomeScreen(),
     SearchScreen.routeName:(context)=>const SearchScreen()
    };
  }
}