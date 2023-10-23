import 'package:clock/clock.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:glider/app/models/app_route.dart';
import 'package:glider/common/constants/app_spacing.dart';
import 'package:glider/common/extensions/uri_extension.dart';
import 'package:glider/common/widgets/preview_card.dart';
import 'package:glider/item/models/item_style.dart';
import 'package:glider/item/widgets/item_data_tile.dart';
import 'package:glider/l10n/extensions/app_localizations_extension.dart';
import 'package:glider/settings/cubit/settings_cubit.dart';
import 'package:glider/settings/extensions/variant_extension.dart';
import 'package:glider_domain/glider_domain.dart';
import 'package:go_router/go_router.dart';
import 'package:material_color_utilities/material_color_utilities.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage(this._settingsCubit, {super.key});

  final SettingsCubit _settingsCubit;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          const _SliverSettingsAppBar(),
          SliverSafeArea(
            top: false,
            sliver: SliverToBoxAdapter(
              child: _SettingsBody(_settingsCubit),
            ),
          ),
        ],
      ),
    );
  }
}

class _SliverSettingsAppBar extends StatelessWidget {
  const _SliverSettingsAppBar();

  @override
  Widget build(BuildContext context) {
    return SliverAppBar.medium(title: Text(context.l10n.settings));
  }
}

class _SettingsBody extends StatelessWidget {
  const _SettingsBody(this._settingsCubit);

  final SettingsCubit _settingsCubit;

  static const String _authority = 'github.com';
  static const String _basePath = 'Mosc/Glider';
  static final Uri _privacyPolicyUrl =
      Uri.https(_authority, '$_basePath/blob/master/PRIVACY.md');
  static const String _license = 'MIT';
  static final Uri _licenseUrl =
      Uri.https(_authority, '$_basePath/blob/master/LICENSE');
  static final Uri _sourceCodeUrl = Uri.https('github.com', _basePath);
  static final Uri _issueTrackerUrl =
      Uri.https(_authority, '$_basePath/issues');

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsCubit, SettingsState>(
      bloc: _settingsCubit,
      builder: (context, state) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: AppSpacing.defaultTilePadding,
            child: Text(
              context.l10n.appearance,
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: Theme.of(context).colorScheme.secondary,
                  ),
            ),
          ),
          SwitchListTile.adaptive(
            value: state.useLargeStoryStyle,
            onChanged: _settingsCubit.setUseLargeStoryStyle,
            title: Text(context.l10n.largeStoryStyle),
            subtitle: Text(context.l10n.largeStoryStyleDescription),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
          ),
          SwitchListTile.adaptive(
            value: state.showStoryMetadata,
            onChanged: _settingsCubit.setShowStoryMetadata,
            title: Text(context.l10n.storyMetadata),
            subtitle: Text(context.l10n.storyMetadataDescription),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
          ),
          SwitchListTile.adaptive(
            value: state.useDynamicTheme,
            onChanged: _settingsCubit.setUseDynamicTheme,
            title: Text(context.l10n.dynamicTheme),
            subtitle: Text(context.l10n.dynamicThemeDescription),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
          ),
          ListTile(
            title: Text(context.l10n.themeColor),
            trailing: Icon(
              Icons.circle,
              color: state.themeColor,
              size: 40,
            ),
            enabled: !state.useDynamicTheme,
            onTap: () async {
              final value = await context.push<Color>(
                AppRoute.themeColorDialog.location(),
                extra: state.themeColor,
              );
              if (value != null) await _settingsCubit.setThemeColor(value);
            },
          ),
          MenuAnchor(
            style: Theme.of(context)
                .menuTheme
                .style
                ?.copyWith(alignment: AlignmentDirectional.bottomEnd),
            menuChildren: [
              for (final variant in Variant.values)
                MenuItemButton(
                  onPressed: () async =>
                      _settingsCubit.setThemeVariant(variant),
                  leadingIcon: Visibility.maintain(
                    visible: state.themeVariant == variant,
                    child: const Icon(Icons.check_outlined),
                  ),
                  child: Text(variant.capitalizedLabel),
                ),
            ],
            builder: (context, controller, child) => ListTile(
              title: Text(context.l10n.themeVariant),
              trailing: Text(state.themeVariant.capitalizedLabel),
              enabled: !state.useDynamicTheme,
              onTap: () async =>
                  controller.isOpen ? controller.close() : controller.open(),
            ),
          ),
          SwitchListTile.adaptive(
            value: state.usePureBackground,
            onChanged: _settingsCubit.setUsePureBackground,
            title: Text(context.l10n.pureBackground),
            subtitle: Text(context.l10n.pureBackgroundDescription),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
          ),
          BlocBuilder<SettingsCubit, SettingsState>(
            bloc: _settingsCubit,
            builder: (context, state) => Padding(
              padding: AppSpacing.defaultTilePadding,
              child: PreviewCard(
                child: HeroMode(
                  enabled: false,
                  child: ItemDataTile(
                    Item(
                      id: -1,
                      username: 'cats4ever',
                      dateTime: clock.now(),
                      title:
                          'Show HN: A fat cat on a treadmill under water [video]',
                      url: Uri.https(
                        'www.youtube.com',
                        'watch',
                        {'v': '1A37RTaoEuM'},
                      ),
                      score: 322,
                      descendantCount: 17,
                    ),
                    upvoted: true,
                    useLargeStoryStyle: state.useLargeStoryStyle,
                    showMetadata: state.showStoryMetadata,
                    style: ItemStyle.overview,
                  ),
                ),
              ),
            ),
          ),
          const Divider(),
          Padding(
            padding: AppSpacing.defaultTilePadding,
            child: Text(
              context.l10n.behavior,
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: Theme.of(context).colorScheme.secondary,
                  ),
            ),
          ),
          SwitchListTile.adaptive(
            value: state.showJobs,
            onChanged: _settingsCubit.setShowJobs,
            title: Text(context.l10n.showJobs),
            subtitle: Text(context.l10n.showJobsDescription),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
          ),
          SwitchListTile.adaptive(
            value: state.useThreadNavigation,
            onChanged: _settingsCubit.setUseThreadNavigation,
            title: Text(context.l10n.threadNavigation),
            subtitle: Text(context.l10n.threadNavigationDescription),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
          ),
          const Divider(),
          Padding(
            padding: AppSpacing.defaultTilePadding,
            child: Text(
              context.l10n.data,
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: Theme.of(context).colorScheme.secondary,
                  ),
            ),
          ),
          ListTile(
            title: Text(context.l10n.exportFavorites),
            subtitle: Text(context.l10n.exportFavoritesDescription),
            onTap: _settingsCubit.exportFavorites,
          ),
          const Divider(),
          Padding(
            padding: AppSpacing.defaultTilePadding,
            child: Text(
              context.l10n.about,
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                  ),
            ),
          ),
          if (state.appVersion case final appVersion?)
            ListTile(
              title: Text(context.l10n.appVersion),
              subtitle: Text(appVersion),
              enabled: false,
            ),
          ListTile(
            title: Text(context.l10n.privacyPolicy),
            trailing: const Icon(Icons.open_in_new_outlined),
            onTap: _privacyPolicyUrl.tryLaunch,
          ),
          ListTile(
            title: Text(context.l10n.license),
            subtitle: const Text(_license),
            trailing: const Icon(Icons.open_in_new_outlined),
            onTap: _licenseUrl.tryLaunch,
          ),
          ListTile(
            title: Text(context.l10n.sourceCode),
            subtitle: Text(_sourceCodeUrl.toString()),
            trailing: const Icon(Icons.open_in_new_outlined),
            onTap: _sourceCodeUrl.tryLaunch,
          ),
          ListTile(
            title: Text(context.l10n.issueTracker),
            subtitle: Text(_issueTrackerUrl.toString()),
            trailing: const Icon(Icons.open_in_new_outlined),
            onTap: _issueTrackerUrl.tryLaunch,
          ),
          ListTile(
            title: Text(
              MaterialLocalizations.of(context).licensesPageTitle,
            ),
            onTap: () => showLicensePage(
              context: context,
              applicationName: context.l10n.appName,
              applicationVersion: state.appVersion,
            ),
          ),
        ],
      ),
    );
  }
}
