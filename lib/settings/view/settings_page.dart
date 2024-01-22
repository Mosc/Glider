import 'package:bloc_presentation/bloc_presentation.dart';
import 'package:clock/clock.dart';
import 'package:flutter/material.dart' hide ThemeMode;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:glider/app/models/app_route.dart';
import 'package:glider/common/constants/app_spacing.dart';
import 'package:glider/common/constants/app_uris.dart';
import 'package:glider/common/extensions/uri_extension.dart';
import 'package:glider/common/widgets/preview_card.dart';
import 'package:glider/item/models/item_style.dart';
import 'package:glider/item/models/vote_type.dart';
import 'package:glider/item/widgets/item_data_tile.dart';
import 'package:glider/l10n/extensions/app_localizations_extension.dart';
import 'package:glider/settings/cubit/settings_cubit.dart';
import 'package:glider/settings/extensions/theme_mode_extension.dart';
import 'package:glider/settings/extensions/variant_extension.dart';
import 'package:glider/settings/widgets/menu_list_tile.dart';
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

  static const List<String> _fonts = [
    'Fira Sans',
    'IBM Plex Sans',
    'Inter',
    'Noto Sans',
    'Open Sans',
    'Roboto',
  ];
  static final Uri _privacyPolicyUrl = AppUris.projectUri
      .replace(path: '${AppUris.projectUri.path}/blob/master/PRIVACY.md');
  static const String _license = 'MIT';
  static final Uri _licenseUrl = AppUris.projectUri
      .replace(path: '${AppUris.projectUri.path}/blob/master/LICENSE');
  static final Uri _sourceCodeUrl = AppUris.projectUri;
  static final Uri _issueTrackerUrl =
      AppUris.projectUri.replace(path: '${AppUris.projectUri.path}/issues');

  @override
  Widget build(BuildContext context) {
    return BlocPresentationListener<SettingsCubit, SettingsCubitEvent>(
      bloc: _settingsCubit,
      listener: (context, event) => switch (event) {
        SettingsActionFailedEvent() =>
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(context.l10n.failure),
            ),
          ),
      },
      child: BlocBuilder<SettingsCubit, SettingsState>(
        bloc: _settingsCubit,
        builder: (context, state) => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: AppSpacing.defaultTilePadding,
              child: Text(
                context.l10n.theme,
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: Theme.of(context).colorScheme.secondary,
                    ),
              ),
            ),
            MenuListTile(
              title: Text(context.l10n.themeMode),
              trailing: Text(state.themeMode.capitalizedLabel),
              onChanged: _settingsCubit.setThemeMode,
              values: ThemeMode.values,
              selected: (value) => state.themeMode == value,
              childBuilder: (value) => Text(value.capitalizedLabel),
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
              onTap: () async => context.push<void>(
                AppRoute.themeColorDialog.location(),
              ),
            ),
            MenuListTile(
              title: Text(context.l10n.themeVariant),
              trailing: Text(state.themeVariant.capitalizedLabel),
              enabled: !state.useDynamicTheme,
              onChanged: _settingsCubit.setThemeVariant,
              values: Variant.values,
              selected: (value) => state.themeVariant == value,
              childBuilder: (value) => Text(value.capitalizedLabel),
            ),
            SwitchListTile.adaptive(
              value: state.usePureBackground,
              onChanged: _settingsCubit.setUsePureBackground,
              title: Text(context.l10n.pureBackground),
              subtitle: Text(context.l10n.pureBackgroundDescription),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
            ),
            MenuListTile(
              title: Text(context.l10n.font),
              trailing: Text(state.font),
              onChanged: _settingsCubit.setFont,
              values: _fonts,
              selected: (value) => state.font == value,
              childBuilder: Text.new,
            ),
            const Divider(),
            Padding(
              padding: AppSpacing.defaultTilePadding,
              child: Text(
                context.l10n.appearance,
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: Theme.of(context).colorScheme.secondary,
                    ),
              ),
            ),
            MenuListTile(
              title: Text(context.l10n.storyLines),
              trailing: Text(
                state.storyLines >= 0
                    ? '${state.storyLines}'
                    : context.l10n.variable,
              ),
              onChanged: _settingsCubit.setStoryLines,
              values: const [1, 2, -1],
              selected: (value) => state.storyLines == value,
              childBuilder: (value) =>
                  Text(value >= 0 ? '$value' : context.l10n.variable),
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
              value: state.showFavicons,
              onChanged: _settingsCubit.setShowFavicons,
              title: Text(context.l10n.favicons),
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
              value: state.showUserAvatars,
              onChanged: _settingsCubit.setShowUserAvatars,
              title: Text(context.l10n.userAvatars),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
            ),
            SwitchListTile.adaptive(
              value: state.useActionButtons,
              onChanged: _settingsCubit.setUseActionButtons,
              title: Text(context.l10n.actionButtons),
              subtitle: Text(context.l10n.actionButtonsDescription),
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
                        score: 42,
                        descendantCount: 7,
                      ),
                      vote: VoteType.upvote,
                      storyLines: state.storyLines,
                      useLargeStoryStyle: state.useLargeStoryStyle,
                      showFavicons: state.showFavicons,
                      showMetadata: state.showStoryMetadata,
                      showUserAvatars: state.showUserAvatars,
                      style: ItemStyle.overview,
                      useInAppBrowser: state.useInAppBrowser,
                      onTapFavorite: state.useActionButtons ? () {} : null,
                      onTapUpvote: state.useActionButtons ? () {} : null,
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
            SwitchListTile.adaptive(
              value: state.enableDownvoting,
              onChanged: _settingsCubit.setEnableDownvoting,
              title: Text(context.l10n.downvoting),
              subtitle: Text(context.l10n.downvotingDescription),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
            ),
            SwitchListTile.adaptive(
              value: state.useInAppBrowser,
              onChanged: _settingsCubit.setUseInAppBrowser,
              title: Text(context.l10n.inAppBrowser),
              subtitle: Text(context.l10n.inAppBrowserDescription),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
            ),
            SwitchListTile.adaptive(
              value: state.useNavigationDrawer,
              onChanged: _settingsCubit.setUseNavigationDrawer,
              title: Text(context.l10n.navigationDrawer),
              subtitle: Text(context.l10n.navigationDrawerDescription),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
            ),
            ListTile(
              title: Text(context.l10n.filters),
              subtitle: Text(context.l10n.filtersDescription),
              onTap: () async => context.push<void>(
                AppRoute.filtersDialog.location(),
              ),
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
            ListTile(
              title: Text(context.l10n.clearVisited),
              onTap: () async {
                final confirm = await context.push<bool>(
                  AppRoute.confirmDialog.location(),
                );
                if (confirm ?? false) await _settingsCubit.clearVisited();
              },
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
                subtitle: Text(appVersion.canonicalizedVersion),
                enabled: false,
              ),
            ListTile(
              title: Text(context.l10n.privacyPolicy),
              trailing: const Icon(Icons.open_in_new_outlined),
              onTap: () => _privacyPolicyUrl.tryLaunch(
                context,
                useInAppBrowser: state.useInAppBrowser,
              ),
            ),
            ListTile(
              title: Text(context.l10n.license),
              subtitle: const Text(_license),
              trailing: const Icon(Icons.open_in_new_outlined),
              onTap: () => _licenseUrl.tryLaunch(
                context,
                useInAppBrowser: state.useInAppBrowser,
              ),
            ),
            ListTile(
              title: Text(context.l10n.sourceCode),
              subtitle: Text(_sourceCodeUrl.toString()),
              trailing: const Icon(Icons.open_in_new_outlined),
              onTap: () => _sourceCodeUrl.tryLaunch(
                context,
                useInAppBrowser: state.useInAppBrowser,
              ),
            ),
            ListTile(
              title: Text(context.l10n.issueTracker),
              subtitle: Text(_issueTrackerUrl.toString()),
              trailing: const Icon(Icons.open_in_new_outlined),
              onTap: () => _issueTrackerUrl.tryLaunch(
                context,
                useInAppBrowser: state.useInAppBrowser,
              ),
            ),
            ListTile(
              title: Text(
                MaterialLocalizations.of(context).licensesPageTitle,
              ),
              onTap: () => showLicensePage(
                context: context,
                applicationName: context.l10n.appName,
                applicationVersion: state.appVersion?.canonicalizedVersion,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
