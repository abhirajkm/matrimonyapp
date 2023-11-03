import 'package:bridesandgrooms/providers/user.dart';
import 'package:bridesandgrooms/screens/home.dart';
import 'package:bridesandgrooms/utils/components/customButton.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:provider/provider.dart';

import '../interface/user.dart';
import '../model/user.dart';
import '../utils/components/custom_app_bar.dart';
import '../utils/images.dart';

class SearchScreen extends StatefulWidget {
  static const routeName = "/search";
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  String? selectedLocation;
  String? maxweight;
  String? maxheight;

  @override
  void initState() {
    super.initState();
  }

  bool _loading = false;

  @override
  Widget build(BuildContext context) {
    final userList = Hive.box<UserModel>('userdb');
    return Scaffold(
      appBar: const PreferredSize(
          preferredSize: Size.fromHeight(60),
          child: CustomAppBar(
            title: "Search Partner",
            isTrailingVisible: false,
          )),
      body: Container(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  heightDropDown(),
                  weightDropDown(),
                  cityDropDown(),
                  const SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: SizedBox(
                      width: 100,
                      child: Button(
                        height: 40,
                        title: "Search",
                        buttonStyle: const TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                            fontWeight: FontWeight.w800),
                        loading: _loading,
                        onPressed: () async {

                          Provider.of<UserProvider>(context, listen: false)
                              .searchFilter(double.parse(maxheight!),
                                  double.parse(maxweight!), selectedLocation!);
                        },
                        radius: 5,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            if (maxweight != null &&
                maxheight != null &&
                selectedLocation != null)
              Expanded(
                child: Consumer<UserProvider>(
                  builder: (context, value, child) => GridView.builder(
                    padding: const EdgeInsets.all(5),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 10.0,
                            mainAxisSpacing:10.0,
                            ),
                    itemCount: value.filteredUsers.length,
                    itemBuilder: (context, index) {
                      final user = value.filteredUsers[index];
                      // print("user name ${user!.name! + user.age.toString() + user.location!}");
                      return Container(
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: const Border.fromBorderSide(
                              BorderSide(color: Colors.purple)),
                        ),
                        child: Column(
                          children: [
                            user.profileUrl!=null?
                                Image.network(user.profileUrl!,height: 100,fit: BoxFit.contain,):
                            Image.asset(
                              image_logbg,
                              height: 100,
                              fit: BoxFit.fill,
                            ),
                            Expanded(
                                child: Text(
                              user.name ?? "",
                              style: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w600),
                            )),
                            Expanded(
                                child: Text(
                             "Age :${user.age}" ?? "",
                              style: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w600),
                            )),
                            Expanded(
                                child: Text(
                              user.location ?? "",
                              style: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w600),
                            )),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              )
          ],
        ),
      ),
    );
  }

  Row heightDropDown() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text("Height Range upto (in cm):  "),
        DropdownButton(
            hint: const Text("Height "),
            value: maxheight != null ? maxheight : null,
            icon: const Icon(Icons.arrow_drop_down),
            iconSize: 24,
            elevation: 16,
            style: const TextStyle(color: Colors.deepPurple),
            underline: Container(
              height: 2,
              color: Colors.black54,
            ),
            onChanged: (newValue) {
              setState(() {
                maxheight = newValue;
              });
            },
            items: heightList.map((f) {
              return DropdownMenuItem(value: f, child: Text(f));
            }).toList()),
      ],
    );
  }

  Row weightDropDown() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text("Weight range upto:  "),
        DropdownButton(
            hint: const Text("Weight "),
            value: maxweight != null ? maxweight : null,
            icon: const Icon(Icons.arrow_drop_down),
            iconSize: 24,
            elevation: 16,
            style: const TextStyle(color: Colors.deepPurple),
            underline: Container(
              height: 2,
              color: Colors.black54,
            ),
            onChanged: (newValue) {
              setState(() {
                maxweight = newValue;
              });
            },
            items: weightList.map((f) {
              return DropdownMenuItem(value: f, child: Text(f));
            }).toList()),
      ],
    );
  }

  Row cityDropDown() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text("Choose city :  "),
        DropdownButton(
            hint: const Text("City "),
            value: selectedLocation != null ? selectedLocation : null,
            icon: const Icon(Icons.arrow_drop_down),
            iconSize: 24,
            elevation: 16,
            style: const TextStyle(color: Colors.deepPurple),
            underline: Container(
              height: 2,
              color: Colors.black54,
            ),
            onChanged: (newValue) {
              setState(() {
                selectedLocation = newValue;
              });
            },
            items: locationList.map((f) {
              return DropdownMenuItem(value: f, child: Text(f));
            }).toList()),
      ],
    );
  }
}

class CustomDropDown extends StatefulWidget {
  final List<String> dropDownList;
  final String selectedItem;
  final String title;
  final void Function(String?) onItemSelected;
  const CustomDropDown(
      {Key? key,
      required this.dropDownList,
      required this.selectedItem,
      required this.onItemSelected,
      required this.title})
      : super(key: key);

  @override
  State<CustomDropDown> createState() => _CustomDropDownState();
}

class _CustomDropDownState extends State<CustomDropDown> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(widget.title),
        DropdownButton(
            hint: Text(widget.title),
            value: widget.selectedItem != null ? widget.selectedItem : null,
            icon: const Icon(Icons.arrow_drop_down),
            iconSize: 24,
            elevation: 16,
            style: const TextStyle(color: Colors.deepPurple),
            underline: Container(
              height: 2,
              color: Colors.black54,
            ),
            onChanged: (String? newValue) {
              widget.onItemSelected(newValue);
            },
            items: widget.dropDownList.map((f) {
              return DropdownMenuItem(value: f, child: Text(f));
            }).toList()),
      ],
    );
  }
}
