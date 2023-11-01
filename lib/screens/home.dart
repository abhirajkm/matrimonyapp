import 'dart:async';

import 'package:bridesandgrooms/model/user.dart';
import 'package:bridesandgrooms/providers/user.dart';
import 'package:bridesandgrooms/screens/profile.dart';
import 'package:bridesandgrooms/screens/search.dart';
import 'package:bridesandgrooms/utils/images.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:provider/provider.dart';
import 'auth/login.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = '/home';
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    Hive.openBox<UserModel>('userdb');
    Hive.box<UserModel>('userdb');
    getData();

    print("object ${Hive.box<UserModel>('userdb').length}");
    super.initState();
  }

  getData() {
    Hive.openBox<UserModel>('userdb');
    final db = Hive.box<UserModel>('userdb');

    if (db.isEmpty) {
      final provider = Provider.of<UserProvider>(context, listen: false);
      provider.getUsersFromFirestore();
    }
  }

  @override
  Widget build(BuildContext context) {
    final userList = Hive.box<UserModel>('userdb');
    return Scaffold(
      appBar: const PreferredSize(
          preferredSize: Size.fromHeight(100), child: CustomAppBar()),
      body: Container(
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage(image_blur), fit: BoxFit.fill)),
        child: FutureBuilder(
          future: Hive.openBox<UserModel>('userdb'),
          builder: (ctx, AsyncSnapshot snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasError) {
                return Center(
                  child: Text(
                    '${snapshot.error} occurred',
                    style: const TextStyle(fontSize: 18),
                  ),
                );

              } else if (snapshot.hasData) {

                final data = Hive.box<UserModel>('userdb');
                return RefreshIndicator(
                  onRefresh:()=> Hive.openBox<UserModel>('userdb'),
                  child: GridView.builder(
                    padding: const EdgeInsets.all(5),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 10.0,
                        mainAxisSpacing: 10.0),
                    itemCount: data.length,
                    itemBuilder: (context, index) {
                      final user = data.getAt(index);
                      return Container(
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        //height: 250,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: const Border.fromBorderSide(
                              BorderSide(color: Colors.purple)),
                        ),
                        child: Column(
                          children: [
                            Image.asset(
                              image_logbg,
                              height: 120,
                              fit: BoxFit.fill,
                            ),
                            Expanded(
                                child: Text(
                              user?.name ?? "",
                              style: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w600),
                            )),
                            Expanded(
                                child: Text(
                              user?.age.toString() ?? "",
                              style: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w600),
                            )),
                            Expanded(
                                child: Text(
                              user?.location ?? "",
                              style: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w600),
                            )),
                          ],
                        ),
                      );
                    },
                  ),
                );
              }
            }
            return const Center(
              child: CircularProgressIndicator(),
            );

          },

        ),

      ),
    );
  }
}

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
