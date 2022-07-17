import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:glider/app_theme.dart';
import 'package:glider/models/dark_theme.dart';
import 'package:glider/models/item.dart';
import 'package:glider/models/item_type.dart';
import 'package:glider/models/text_size.dart';
import 'package:glider/pages/item_page.dart';
import 'package:glider/providers/persistence_provider.dart';
import 'package:glider/providers/repository_provider.dart';
import 'package:glider/utils/animation_util.dart';
import 'package:glider/utils/date_time_extension.dart';
import 'package:glider/utils/theme_mode_extension.dart';
import 'package:glider/widgets/common/provider_switch_list_tile.dart';
import 'package:glider/widgets/common/smooth_animated_switcher.dart';
import 'package:glider/widgets/items/item_tile_data.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class SettingsBody extends HookConsumerWidget {
  const SettingsBody({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListView(
      padding: MediaQuery.of(context).padding.copyWith(top: 0),
      children: const <Widget>[
        PreviewSection(),
        SizedBox(height: 16),
        AppearanceSection(),
        SizedBox(height: 16),
        BehaviorSection(),
      ],
    );
  }
}

class PreviewSection extends HookConsumerWidget {
  const PreviewSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: <Widget>[
        ListTile(
          title: Text(
            AppLocalizations.of(context).preview,
            style: Theme.of(context)
                .textTheme
                .titleSmall
                ?.copyWith(color: Theme.of(context).colorScheme.primary),
          ),
        ),
        ItemTileData(
          Item(
            id: 0x7fffffff,
            type: ItemType.story,
            by: 'this_user_does_not_exist',
            time: DateTime.now().secondsSinceEpoch,
            url: 'https://github.com/Mosc/Glider',
            score: 3154,
            title: 'Glider is an opinionated Hacker News client',
            descendants: 322,
            preview: true,
          ),
          dense: true,
        ),
        ItemTileData(
          Item(
            id: 0x7ffffffe,
            type: ItemType.comment,
            by: 'neither_does_this_user',
            time: DateTime.now().secondsSinceEpoch,
            text: "That's <i>awesome</i>.",
            indentation: 1,
            preview: true,
          ),
        ),
      ],
    );
  }
}

class AppearanceSection extends HookConsumerWidget {
  const AppearanceSection({super.key});

  static const int _avatarDescriptionItemId = 30668207;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        ListTile(
          title: Text(
            AppLocalizations.of(context).appearance,
            style: Theme.of(context)
                .textTheme
                .titleSmall
                ?.copyWith(color: Theme.of(context).colorScheme.primary),
          ),
        ),
        ProviderSwitchListTile(
          title: AppLocalizations.of(context).showDomain,
          provider: showDomainProvider,
          onSave: (bool value) =>
              ref.read(storageRepositoryProvider).setShowDomain(value: value),
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
        ProviderSwitchListTile(
          title: AppLocalizations.of(context).showAvatar,
          trailing: IconButton(
            icon: const Icon(FluentIcons.info_24_regular),
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (_) => const ItemPage(id: _avatarDescriptionItemId),
              ),
            ),
          ),
          provider: showAvatarProvider,
          onSave: (bool value) =>
              ref.read(storageRepositoryProvider).setShowAvatar(value: value),
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
                      .setTextScaleFactor(value: textScaleFactor);
                  ref.invalidate(textScaleFactorProvider);
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
              ThemeModeButton(themeMode),
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
              ThemeColorButton(themeColor),
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

class BehaviorSection extends HookConsumerWidget {
  const BehaviorSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        ListTile(
          title: Text(
            AppLocalizations.of(context).behavior,
            style: Theme.of(context)
                .textTheme
                .titleSmall
                ?.copyWith(color: Theme.of(context).colorScheme.primary),
          ),
        ),
        ProviderSwitchListTile(
          title: AppLocalizations.of(context).useCustomTabs,
          provider: useCustomTabsProvider,
          onSave: (bool value) => ref
              .read(storageRepositoryProvider)
              .setUseCustomTabs(value: value),
        ),
        ProviderSwitchListTile(
          title: AppLocalizations.of(context).useGestures,
          provider: useGesturesProvider,
          onSave: (bool value) =>
              ref.read(storageRepositoryProvider).setUseGestures(value: value),
        ),
        ProviderSwitchListTile(
          title: AppLocalizations.of(context).useInfiniteScroll,
          provider: useInfiniteScrollProvider,
          onSave: (bool value) => ref
              .read(storageRepositoryProvider)
              .setUseInfiniteScroll(value: value),
        ),
        ProviderSwitchListTile(
          title: AppLocalizations.of(context).showJobs,
          provider: showJobsProvider,
          onSave: (bool value) =>
              ref.read(storageRepositoryProvider).setShowJobs(value: value),
        ),
      ],
    );
  }
}

class ThemeModeButton extends HookConsumerWidget {
  const ThemeModeButton(this.mode, {super.key});

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
            ref.invalidate(themeModeProvider);
          },
          selected: selected,
          label: Text(mode.title(context)),
        ),
      ),
    );
  }
}

class DarkThemeButton extends HookConsumerWidget {
  const DarkThemeButton(this.darkTheme, {super.key});

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
      padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 4),
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
          label: Text(darkTheme.title(context)),
          selected: selected,
          onSelected: (_) async {
            await ref.read(storageRepositoryProvider).setDarkTheme(darkTheme);
            ref.invalidate(darkThemeProvider);
          },
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
      ),
    );
  }
}

class ThemeColorButton extends HookConsumerWidget {
  const ThemeColorButton(this.color, {super.key});

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
          label: Icon(
            FluentIcons.checkmark_24_regular,
            color: selected ? color : Colors.transparent,
          ),
          selected: selected,
          onSelected: (_) async {
            await ref.read(storageRepositoryProvider).setThemeColor(color);
            ref.invalidate(themeColorProvider);
          },
          visualDensity: const VisualDensity(
            horizontal: VisualDensity.minimumDensity,
          ),
        ),
      ),
    );
  }
}
