import 'package:flutter/widgets.dart';
import 'package:glider/auth/cubit/auth_cubit.dart';
import 'package:glider/settings/cubit/settings_cubit.dart';

abstract interface class MenuItem<S> {
  bool isVisible(S state, AuthState authState, SettingsState settingsState);

  IconData? icon(S state);

  String label(BuildContext context, S state);
}
