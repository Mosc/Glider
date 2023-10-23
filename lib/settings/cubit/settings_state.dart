part of 'settings_cubit.dart';

class SettingsState with EquatableMixin {
  const SettingsState({
    this.useLargeStoryStyle = true,
    this.showStoryMetadata = true,
    this.useDynamicTheme = true,
    this.themeColor = const Color(0xff6750a4),
    this.themeVariant = Variant.tonalSpot,
    this.usePureBackground = false,
    this.showJobs = false,
    this.useThreadNavigation = true,
    this.appVersion,
  });

  final bool useLargeStoryStyle;
  final bool showStoryMetadata;
  final bool useDynamicTheme;
  final Color themeColor;
  final Variant themeVariant;
  final bool usePureBackground;
  final bool showJobs;
  final bool useThreadNavigation;
  final Version? appVersion;

  SettingsState copyWith({
    bool Function()? useLargeStoryStyle,
    bool Function()? showStoryMetadata,
    bool Function()? useDynamicTheme,
    Color Function()? themeColor,
    Variant Function()? themeVariant,
    bool Function()? usePureBackground,
    bool Function()? showJobs,
    bool Function()? useThreadNavigation,
    Version? Function()? appVersion,
  }) =>
      SettingsState(
        useLargeStoryStyle: useLargeStoryStyle != null
            ? useLargeStoryStyle()
            : this.useLargeStoryStyle,
        showStoryMetadata: showStoryMetadata != null
            ? showStoryMetadata()
            : this.showStoryMetadata,
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
        appVersion: appVersion != null ? appVersion() : this.appVersion,
      );

  @override
  List<Object?> get props => [
        useLargeStoryStyle,
        showStoryMetadata,
        useDynamicTheme,
        themeColor,
        themeVariant,
        usePureBackground,
        showJobs,
        useThreadNavigation,
        appVersion,
      ];
}
