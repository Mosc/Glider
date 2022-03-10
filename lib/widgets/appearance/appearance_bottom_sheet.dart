import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:glider/app_theme.dart';
import 'package:glider/models/dark_theme.dart';
import 'package:glider/models/text_size.dart';
import 'package:glider/providers/persistence_provider.dart';
import 'package:glider/providers/repository_provider.dart';
import 'package:glider/utils/animation_util.dart';
import 'package:glider/utils/theme_mode_extension.dart';
import 'package:glider/widgets/common/provider_switch_list_tile.dart';
import 'package:glider/widgets/common/scrollable_bottom_sheet.dart';
import 'package:glider/widgets/common/smooth_animated_switcher.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class AppearanceBottomSheet extends HookConsumerWidget {
  const AppearanceBottomSheet({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ScrollableBottomSheet(
      children: <Widget>[
        ProviderSwitchListTile(
          title: AppLocalizations.of(context).showUrl,
          provider: showUrlProvider,
          onSave: (bool value) =>
              ref.read(storageRepositoryProvider).setShowUrl(value: value),
        ),
        ProviderSwitchListTile(
          title: AppLocalizations.of(context).showFavicon,
          provider: showFaviconProvider,
          onSave: (bool value) =>
              ref.read(storageRepositoryProvider).setShowFavicon(value: value),
        ),
        ProviderSwitchListTile(
          title: AppLocalizations.of(context).showMetadata,
          provider: showMetadataProvider,
          onSave: (bool value) =>
              ref.read(storageRepositoryProvider).setShowMetadata(value: value),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
          child: Row(
            children: <Widget>[
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: Text(
                    AppLocalizations.of(context).textSize,
                    style: Theme.of(context).textTheme.titleMedium,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
              Slider(
                value: ref.watch(textScaleFactorProvider).value ??
                    TextSize.medium.scaleFactor,
                min: TextSize.small.scaleFactor,
                max: TextSize.large.scaleFactor,
                divisions: TextSize.values.length - 1,
                label: TextSize.values
                    .singleWhere(
                      (TextSize textSize) =>
                          textSize.scaleFactor ==
                          ref.watch(textScaleFactorProvider).value,
                      orElse: () => TextSize.medium,
                    )
                    .title(context),
                onChanged: (double textScaleFactor) {
                  ref
                      .read(storageRepositoryProvider)
                      .setTextScaleFactor(textScaleFactor: textScaleFactor);
                  ref.refresh(textScaleFactorProvider);
                },
              ),
            ],
          ),
        ),
        _buildTitledButtons(
          context,
          title: AppLocalizations.of(context).themeMode,
          children: <Widget>[
            for (ThemeMode themeMode in ThemeMode.values)
              _ThemeModeButton(themeMode),
          ],
        ),
        SmoothAnimatedSwitcher.vertical(
          condition: ref.watch(themeModeProvider).value != ThemeMode.light,
          child: _buildTitledButtons(
            context,
            title: AppLocalizations.of(context).darkTheme,
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
                style: Theme.of(context).textTheme.titleMedium,
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
    final ThemeMode selectedMode =
        ref.watch(themeModeProvider).value ?? ThemeMode.system;
    final bool selected = mode == selectedMode;
    final Color color = mode.color(context, ref);

    useMemoized(
      () => Future<void>.microtask(() {
        if (selected) {
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
      child: ChipTheme(
        data: ChipThemeData.fromDefaults(
          brightness: ThemeData.estimateBrightnessForColor(color),
          secondaryColor: color,
          labelStyle: const TextStyle(),
        ).copyWith(
          backgroundColor: color,
          secondaryLabelStyle:
              TextStyle(color: Theme.of(context).colorScheme.primary),
          side: selected
              ? BorderSide(color: Theme.of(context).colorScheme.primary)
              : const BorderSide(color: Colors.transparent),
        ),
        child: ChoiceChip(
          onSelected: (_) async {
            await ref.read(storageRepositoryProvider).setThemeMode(mode);
            ref.refresh(themeModeProvider);
          },
          selected: selected,
          label: Text(mode.title(context)),
        ),
      ),
    );
  }
}

class DarkThemeButton extends HookConsumerWidget {
  const DarkThemeButton(this.darkTheme, {Key? key}) : super(key: key);

  final DarkTheme darkTheme;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final DarkTheme selectedDarkTheme =
        ref.watch(darkThemeProvider).value ?? DarkTheme.grey;
    final bool selected = darkTheme == selectedDarkTheme;
    final Color color = darkTheme.color;

    useMemoized(
      () => Future<void>.microtask(() {
        if (selected) {
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
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 7),
      child: ChipTheme(
        data: ChipThemeData.fromDefaults(
          brightness: ThemeData.estimateBrightnessForColor(color),
          secondaryColor: color,
          labelStyle: const TextStyle(),
        ).copyWith(
          backgroundColor: color,
          secondaryLabelStyle:
              TextStyle(color: Theme.of(context).colorScheme.primary),
          side: selected
              ? BorderSide(color: Theme.of(context).colorScheme.primary)
              : const BorderSide(color: Colors.transparent),
        ),
        child: ChoiceChip(
          onSelected: (_) async {
            await ref.read(storageRepositoryProvider).setDarkTheme(darkTheme);
            ref.refresh(darkThemeProvider);
          },
          selected: selected,
          label: Text(darkTheme.title(context)),
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
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
    final Color selectedColor =
        ref.watch(themeColorProvider).value ?? AppTheme.defaultColor;
    final bool selected = color == selectedColor;

    useMemoized(
      () => Future<void>.microtask(() {
        if (selected) {
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
      child: ChipTheme(
        data: ChipThemeData.fromDefaults(
          brightness: ThemeData.estimateBrightnessForColor(color),
          secondaryColor: color,
          labelStyle: const TextStyle(),
        ).copyWith(
          backgroundColor: color,
          labelPadding: EdgeInsets.zero,
          side: selected
              ? BorderSide(color: color)
              : const BorderSide(color: Colors.transparent),
        ),
        child: ChoiceChip(
          onSelected: (_) async {
            await ref.read(storageRepositoryProvider).setThemeColor(color);
            ref.refresh(themeColorProvider);
          },
          selected: selected,
          label: Icon(
            FluentIcons.checkmark_24_regular,
            color: selected ? color : Colors.transparent,
          ),
          visualDensity: const VisualDensity(
            horizontal: VisualDensity.minimumDensity,
          ),
        ),
      ),
    );
  }
}
