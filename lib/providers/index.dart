import 'package:bridesandgrooms/providers/user.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import 'app.dart';


class ProviderTree {
  static List<SingleChildWidget> get(BuildContext context) {
    return [
      ChangeNotifierProvider.value(value: AppProvider()),
      ChangeNotifierProvider.value(value: UserProvider()),
    ];
  }
}
