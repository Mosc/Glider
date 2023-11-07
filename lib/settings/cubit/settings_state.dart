part of 'settings_cubit.dart';

class SettingsState with EquatableMixin {
  const SettingsState({
    this.useLargeStoryStyle = true,
    this.showFavicons = true,
    this.showStoryMetadata = true,
    this.showUserAvatars = true,
    this.useActionButtons = false,
    this.themeMode = ThemeMode.system,
    this.useDynamicTheme = true,
    this.themeColor = const Color(0xff6750a4),
    this.themeVariant = Variant.tonalSpot,
    this.usePureBackground = false,
    this.showJobs = true,
    this.useThreadNavigation = true,
    this.enableDownvoting = false,
    this.appVersion,
  });

  final bool useLargeStoryStyle;
  final bool showFavicons;
  final bool showStoryMetadata;
  final bool showUserAvatars;
  final bool useActionButtons;
  final ThemeMode themeMode;
  final bool useDynamicTheme;
  final Color themeColor;
  final Variant themeVariant;
  final bool usePureBackground;
  final bool showJobs;
  final bool useThreadNavigation;
  final bool enableDownvoting;
  final Version? appVersion;

  SettingsState copyWith({
    bool Function()? useLargeStoryStyle,
    bool Function()? showFavicons,
    bool Function()? showStoryMetadata,
    bool Function()? showUserAvatars,
    bool Function()? useActionButtons,
    ThemeMode Function()? themeMode,
    bool Function()? useDynamicTheme,
    Color Function()? themeColor,
    Variant Function()? themeVariant,
    bool Function()? usePureBackground,
    bool Function()? showJobs,
    bool Function()? useThreadNavigation,
    bool Function()? enableDownvoting,
    Version? Function()? appVersion,
  }) =>
      SettingsState(
        useLargeStoryStyle: useLargeStoryStyle != null
            ? useLargeStoryStyle()
            : this.useLargeStoryStyle,
        showFavicons: showFavicons != null ? showFavicons() : this.showFavicons,
        showStoryMetadata: showStoryMetadata != null
            ? showStoryMetadata()
            : this.showStoryMetadata,
        showUserAvatars:
            showUserAvatars != null ? showUserAvatars() : this.showUserAvatars,
        useActionButtons: useActionButtons != null
            ? useActionButtons()
            : this.useActionButtons,
        themeMode: themeMode != null ? themeMode() : this.themeMode,
        useDynamicTheme:
            useDynamicTheme != null ? useDynamicTheme() : this.useDynamicTheme,
        themeColor: themeColor != null ? themeColor() : this.themeColor,
        themeVariant: themeVariant != null ? themeVariant() : this.themeVariant,
        usePureBackground: usePureBackground != null
            ? usePureBackground()
            : this.usePureBackground,
        showJobs: showJobs != null ? showJobs() : this.showJobs,
        useThreadNavigation: useThreadNavigation != null
            ? useThreadNavigation()
            : this.useThreadNavigation,
        enableDownvoting: enableDownvoting != null
            ? enableDownvoting()
            : this.enableDownvoting,
        appVersion: appVersion != null ? appVersion() : this.appVersion,
      );

  @override
  List<Object?> get props => [
        useLargeStoryStyle,
        showFavicons,
        showStoryMetadata,
        showUserAvatars,
        useActionButtons,
        themeMode,
        useDynamicTheme,
        themeColor,
        themeVariant,
        usePureBackground,
        showJobs,
        useThreadNavigation,
        enableDownvoting,
        appVersion,
      ];
}
