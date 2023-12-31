import 'dart:async';

import 'package:bridesandgrooms/model/user.dart';
import 'package:bridesandgrooms/providers/user.dart';
import 'package:bridesandgrooms/utils/images.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:provider/provider.dart';
import '../utils/components/custom_app_bar.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = '/home';
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    Provider.of<UserProvider>(context, listen: false).reset();
    Provider.of<UserProvider>(context, listen: false).getUserDetails();
    Provider.of<UserProvider>(context, listen: false).getImageFromHive();
    getData();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(
          preferredSize: Size.fromHeight(100), child: CustomAppBar()),
      body: RefreshIndicator(
        onRefresh: () {
          final provider = Provider.of<UserProvider>(context, listen: false);
          provider.reset();
          return provider.fetchFromFirestore();
        },
        child: Container(
            decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage(image_blur), fit: BoxFit.fill)),
            child: FutureBuilder(
              future: getData(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  return Consumer<UserProvider>(builder: (context, value, child) {
                      return value.firebaseList.isNotEmpty
                    ? HomeUserList(userList: value.firebaseList)
                    : const Center(
                        child: CircularProgressIndicator(),
                      );
                    });
                }
              },
            )),
      ),
    );
  }

  Future<void> getData() async {
    final provider = Provider.of<UserProvider>(context, listen: false);
    provider.fetchFromFirestore();
  }
}

class HomeUserList extends StatelessWidget {
  final List<UserModel> userList;
  const HomeUserList({Key? key, required this.userList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(5),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, crossAxisSpacing: 10.0, mainAxisSpacing: 10.0),
      itemCount: userList.length,
      itemBuilder: (context, index) {
        final user = userList[index];
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 5),
          //height: 250,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border:
                const Border.fromBorderSide(BorderSide(color: Colors.purple)),
          ),
          child: Column(
            children: [
              user.profileUrl != null
                  ? Image.network(
                      user.profileUrl!,
                      height: 100,
                      fit: BoxFit.contain,
                    )
                  : Image.asset(
                      image_dummy,
                      height: 100,
                      fit: BoxFit.fill,
                    ),
              Expanded(
                  child: Text(
                user.name ?? "",
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              )),
              Expanded(
                  child: Text(
                user.age.toString() ?? "",
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              )),
              Expanded(
                  child: Text(
                user.location ?? "",
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              )),
            ],
          ),
        );
      },
    );
  }
}
