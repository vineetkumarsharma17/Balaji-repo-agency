import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../constant.dart';

showSnackBar(msg, context) {
  Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: primaryColor,
      textColor: Colors.white,
      fontSize: 16.0);
  // return ScaffoldMessenger.of(context).showSnackBar(SnackBar(
  //   backgroundColor: primaryColor,
  //   elevation: 20,
  //   margin: EdgeInsets.symmetric(vertical: 40, horizontal: 20),
  //   content: Text(msg),
  //   behavior: SnackBarBehavior.floating,
  //   shape: RoundedRectangleBorder(
  //     borderRadius: BorderRadius.circular(200.0),
  //   ),
  //   duration: const Duration(milliseconds: 3000),
  // ));
}
