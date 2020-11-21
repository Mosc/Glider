import 'package:flutter/material.dart';

extension ScaffoldMessengerStateExtension on ScaffoldMessengerState {
  ScaffoldFeatureController<SnackBar, SnackBarClosedReason> showSnackBarQuickly(
      SnackBar snackBar) {
    hideCurrentSnackBar();
    return showSnackBar(snackBar);
  }
}
