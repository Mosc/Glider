import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:glider/app_theme.dart';
import 'package:glider/models/dark_theme.dart';
import 'package:glider/providers/persistence_provider.dart';
import 'package:glider/providers/repository_provider.dart';
import 'package:glider/utils/animation_util.dart';
import 'package:glider/utils/color_extension.dart';
import 'package:glider/utils/theme_mode_extension.dart';
import 'package:glider/widgets/common/provider_switch_list_tile.dart';
import 'package:glider/widgets/common/scrollable_bottom_sheet.dart';
import 'package:glider/widgets/common/smooth_animated_cross_fade.dart';
import 'package:glider/widgets/common/smooth_animated_switcher.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class AppearanceBottomSheet extends HookConsumerWidget {
  const AppearanceBottomSheet({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ScrollableBottomSheet(
      children: <Widget>[
        ProviderSwitchListTile(
          title: AppLocalizations.of(context)!.showUrl,
          provider: showUrlProvider,
          onSave: (bool value) =>
              ref.read(storageRepositoryProvider).setShowUrl(value: value),
        ),
        ProviderSwitchListTile(
          title: AppLocalizations.of(context)!.showFavicon,
          provider: showFaviconProvider,
          onSave: (bool value) =>
              ref.read(storageRepositoryProvider).setShowFavicon(value: value),
        ),
        ProviderSwitchListTile(
          title: AppLocalizations.of(context)!.showMetadata,
          provider: showMetadataProvider,
          onSave: (bool value) =>
              ref.read(storageRepositoryProvider).setShowMetadata(value: value),
        ),
        _buildTitledButtons(
          context,
          title: AppLocalizations.of(context)!.themeMode,
          children: <Widget>[
            for (ThemeMode themeMode in ThemeMode.values)
              _ThemeModeButton(themeMode),
          ],
        ),
        SmoothAnimatedSwitcher.vertical(
          condition:
              ref.watch(themeModeProvider).asData?.value != ThemeMode.light,
          child: _buildTitledButtons(
            context,
            title: AppLocalizations.of(context)!.darkTheme,
            children: <Widget>[
              for (DarkTheme darkTheme in DarkTheme.values)
                DarkThemeButton(darkTheme),
            ],
          ),
        ),
        _buildHorizontalScrollable(
          context,
          children: <Widget>[
            for (Color themeColor in AppTheme.themeColors)
              _ThemeColorButton(themeColor),
          ],
        ),
      ],
    );
  }

  Widget _buildTitledButtons(BuildContext context,
      {required String title, required List<Widget> children}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Text(
                title,
                style: Theme.of(context).textTheme.subtitle1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          Row(children: children),
        ],
      ),
    );
  }

  Widget _buildHorizontalScrollable(BuildContext context,
      {required List<Widget> children}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Row(children: children),
      ),
    );
  }
}

class _ThemeModeButton extends HookConsumerWidget {
  const _ThemeModeButton(this.mode, {Key? key}) : super(key: key);

  final ThemeMode mode;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ThemeMode themeMode =
        ref.watch(themeModeProvider).data?.value ?? ThemeMode.system;
    final Color color = mode.color(context, ref);

    useMemoized(
      () => Future<void>.microtask(() {
        if (mode == themeMode) {
          Scrollable.ensureVisible(
            context,
            duration: AnimationUtil.defaultDuration,
            curve: AnimationUtil.defaultCurve,
            alignmentPolicy: ScrollPositionAlignmentPolicy.keepVisibleAtEnd,
          );
        }
      }),
    );

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: ElevatedButton(
        onPressed: () async {
          await ref.read(storageRepositoryProvider).setThemeMode(mode);
          ref.refresh(themeModeProvider);
        },
        style: ElevatedButton.styleFrom(
          primary: color,
          onPrimary: color.isDark ? Colors.white : Colors.black,
          shape: const StadiumBorder(),
          minimumSize: const Size(40, 40),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            SmoothAnimatedCrossFade(
              condition: mode == themeMode,
              trueChild: const Icon(FluentIcons.checkmark_24_regular),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Text(mode.title(context)),
            ),
          ],
        ),
      ),
    );
  }
}

class DarkThemeButton extends HookConsumerWidget {
  const DarkThemeButton(this.base, {Key? key}) : super(key: key);

  final DarkTheme base;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final DarkTheme darkTheme =
        ref.watch(darkThemeProvider).data?.value ?? DarkTheme.grey;

    useMemoized(
      () => Future<void>.microtask(() {
        if (base == darkTheme) {
          Scrollable.ensureVisible(
            context,
            duration: AnimationUtil.defaultDuration,
            curve: AnimationUtil.defaultCurve,
            alignmentPolicy: ScrollPositionAlignmentPolicy.keepVisibleAtEnd,
          );
        }
      }),
    );

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: ElevatedButton(
        onPressed: () async {
          await ref.read(storageRepositoryProvider).setDarkTheme(base);
          ref.refresh(darkThemeProvider);
        },
        style: ElevatedButton.styleFrom(
          primary: base.color,
          onPrimary: base.color.isDark ? Colors.white : Colors.black,
          shape: const StadiumBorder(),
          minimumSize: const Size(40, 40),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            SmoothAnimatedCrossFade(
              condition: base == darkTheme,
              trueChild: const Icon(FluentIcons.checkmark_24_regular),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Text(base.title(context)),
            ),
          ],
        ),
      ),
    );
  }
}

class _ThemeColorButton extends HookConsumerWidget {
  const _ThemeColorButton(this.color, {Key? key}) : super(key: key);

  final Color color;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final Color themeColor =
        ref.watch(themeColorProvider).data?.value ?? AppTheme.defaultColor;

    useMemoized(
      () => Future<void>.microtask(() {
        if (color == themeColor) {
          Scrollable.ensureVisible(
            context,
            duration: AnimationUtil.defaultDuration,
            curve: AnimationUtil.defaultCurve,
            alignmentPolicy: ScrollPositionAlignmentPolicy.keepVisibleAtEnd,
          );
        }
      }),
    );

    return ElevatedButton(
      onPressed: () async {
        await ref.read(storageRepositoryProvider).setThemeColor(color);
        ref.refresh(themeColorProvider);
      },
      style: ElevatedButton.styleFrom(
        primary: color,
        minimumSize: const Size(40, 40),
        shape: const CircleBorder(),
        padding: EdgeInsets.zero,
      ),
      child: SmoothAnimatedSwitcher(
        condition: color == themeColor,
        child: const Icon(FluentIcons.checkmark_24_regular),
      ),
    );
  }
}
