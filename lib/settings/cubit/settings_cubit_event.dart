part of 'settings_cubit.dart';

sealed class SettingsCubitEvent {}

final class SettingsActionFailedEvent implements SettingsCubitEvent {
  const SettingsActionFailedEvent();
}
