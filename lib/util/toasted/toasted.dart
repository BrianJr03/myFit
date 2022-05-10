// Copyright 2022 The myFit Authors. All rights reserved.

import 'package:fluttertoast/fluttertoast.dart';

class Toasted {
  /// Shows a toast message to the user.
  static void showToast(String msg) {
    Fluttertoast.showToast(
        msg: msg, toastLength: Toast.LENGTH_LONG, gravity: ToastGravity.BOTTOM);
  }
}