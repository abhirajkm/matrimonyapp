import 'package:bridesandgrooms/providers/index.dart';
import 'package:bridesandgrooms/routes.dart';
import 'package:bridesandgrooms/screens/auth/login.dart';
import 'package:bridesandgrooms/screens/home.dart';
import 'package:bridesandgrooms/utils/theme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;
    return MultiProvider(
      providers: ProviderTree.get(context),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: "Bride  & Groom",
        theme: appTheme,
        home: user == null ?
        const UserLoginScreen() :
        const HomeScreen(),
        routes: AppRoutes.get(context),
      ),
    );
  }
}
