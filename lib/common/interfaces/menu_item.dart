import 'package:flutter/widgets.dart';
import 'package:glider/auth/cubit/auth_cubit.dart';

abstract interface class MenuItem<S> {
  bool isVisible(S state, AuthState authState);

  IconData? get icon;

  String label(BuildContext context);
}
