import 'package:flutter/material.dart';

extension ScaffoldMessengerStateExtension on ScaffoldMessengerState {
  ScaffoldFeatureController<SnackBar, SnackBarClosedReason> replaceSnackBar(
      SnackBar snackBar) {
    hideCurrentSnackBar();
    return showSnackBar(snackBar);
  }
}
