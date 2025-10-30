import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';

void showToast(String message, {bool success = false, bool warning = false}) async {
  await Fluttertoast.cancel(); // avoid overlapping toasts

  Color bgColor;

  if (warning) {
    bgColor = Colors.orange.shade600;
  } else if (success) {
    bgColor = Colors.green.shade600;
  } else {
    bgColor = Colors.red.shade600;
  }

  Fluttertoast.showToast(
    msg: " ${String.fromCharCode(0x2022)} $message", // adds a clean bullet prefix
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.BOTTOM,
    backgroundColor: bgColor,
    textColor: Colors.white,
    fontSize: 15.0,
  );
}
