part of 'settings_cubit.dart';

class SettingsState with EquatableMixin {
  const SettingsState({
    this.themeMode = ThemeMode.system,
    this.useDynamicTheme = true,
    this.themeColor = const Color(0xff6750a4),
    this.themeVariant = Variant.tonalSpot,
    this.usePureBackground = false,
    this.font = 'Noto Sans',
    this.useLargeStoryStyle = true,
    this.showFavicons = true,
    this.showStoryMetadata = true,
    this.showUserAvatars = true,
    this.useActionButtons = false,
    this.showJobs = true,
    this.useThreadNavigation = true,
    this.enableDownvoting = false,
    this.useInAppBrowser = false,
    this.wordFilters = const {},
    this.domainFilters = const {},
    this.appVersion,
  });

  final ThemeMode themeMode;
  final bool useDynamicTheme;
  final Color themeColor;
  final Variant themeVariant;
  final bool usePureBackground;
  final String font;
  final bool useLargeStoryStyle;
  final bool showFavicons;
  final bool showStoryMetadata;
  final bool showUserAvatars;
  final bool useActionButtons;
  final bool showJobs;
  final bool useThreadNavigation;
  final bool enableDownvoting;
  final bool useInAppBrowser;
  final Set<String> wordFilters;
  final Set<String> domainFilters;
  final Version? appVersion;

  SettingsState copyWith({
    ThemeMode Function()? themeMode,
    bool Function()? useDynamicTheme,
    Color Function()? themeColor,
    Variant Function()? themeVariant,
    bool Function()? usePureBackground,
    String Function()? font,
    bool Function()? useLargeStoryStyle,
    bool Function()? showFavicons,
    bool Function()? showStoryMetadata,
    bool Function()? showUserAvatars,
    bool Function()? useActionButtons,
    bool Function()? showJobs,
    bool Function()? useThreadNavigation,
    bool Function()? enableDownvoting,
    bool Function()? useInAppBrowser,
    Set<String> Function()? wordFilters,
    Set<String> Function()? domainFilters,
    Version? Function()? appVersion,
  }) =>
      SettingsState(
        themeMode: themeMode != null ? themeMode() : this.themeMode,
        useDynamicTheme:
            useDynamicTheme != null ? useDynamicTheme() : this.useDynamicTheme,
        themeColor: themeColor != null ? themeColor() : this.themeColor,
        themeVariant: themeVariant != null ? themeVariant() : this.themeVariant,
        usePureBackground: usePureBackground != null
            ? usePureBackground()
            : this.usePureBackground,
        font: font != null ? font() : this.font,
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
        showJobs: showJobs != null ? showJobs() : this.showJobs,
        useThreadNavigation: useThreadNavigation != null
            ? useThreadNavigation()
            : this.useThreadNavigation,
        enableDownvoting: enableDownvoting != null
            ? enableDownvoting()
            : this.enableDownvoting,
        useInAppBrowser:
            useInAppBrowser != null ? useInAppBrowser() : this.useInAppBrowser,
        wordFilters: wordFilters != null ? wordFilters() : this.wordFilters,
        domainFilters:
            domainFilters != null ? domainFilters() : this.domainFilters,
        appVersion: appVersion != null ? appVersion() : this.appVersion,
      );

  @override
  List<Object?> get props => [
        themeMode,
        useDynamicTheme,
        themeColor,
        themeVariant,
        usePureBackground,
        font,
        useLargeStoryStyle,
        showFavicons,
        showStoryMetadata,
        showUserAvatars,
        useActionButtons,
        showJobs,
        useThreadNavigation,
        enableDownvoting,
        useInAppBrowser,
        wordFilters,
        domainFilters,
        appVersion,
      ];
}
