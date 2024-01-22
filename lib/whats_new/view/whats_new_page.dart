import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:glider/common/constants/app_spacing.dart';
import 'package:glider/common/widgets/hacker_news_text.dart';
import 'package:glider/l10n/extensions/app_localizations_extension.dart';
import 'package:glider/settings/cubit/settings_cubit.dart';
import 'package:go_router/go_router.dart';

class WhatsNewPage extends StatelessWidget {
  const WhatsNewPage(
    this._settingsCubit, {
    super.key,
  });

  final SettingsCubit _settingsCubit;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          const _SliverWhatsNewAppBar(),
          SliverSafeArea(
            top: false,
            sliver: SliverToBoxAdapter(
              child: _WhatsNewBody(_settingsCubit),
            ),
          ),
          const SliverPadding(
            padding: AppSpacing.floatingActionButtonPageBottomPadding,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.pop(),
        icon: const Icon(Icons.rocket_launch_outlined),
        label: Text(context.l10n.explore),
      ),
    );
  }
}

class _SliverWhatsNewAppBar extends StatelessWidget {
  const _SliverWhatsNewAppBar();

  @override
  Widget build(BuildContext context) {
    return SliverAppBar.medium(title: Text(context.l10n.whatsNew));
  }
}

class _WhatsNewBody extends StatelessWidget {
  const _WhatsNewBody(this._settingsCubit);

  final SettingsCubit _settingsCubit;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsCubit, SettingsState>(
      bloc: _settingsCubit,
      builder: (context, settingsState) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
        child: HackerNewsText(
          context.l10n.whatsNewDescription,
          useInAppBrowser: settingsState.useInAppBrowser,
        ),
      ),
    );
  }
}
