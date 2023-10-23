import 'package:flutter/material.dart';
import 'package:glider/common/constants/app_spacing.dart';
import 'package:glider/common/widgets/hacker_news_text.dart';
import 'package:glider/l10n/extensions/app_localizations_extension.dart';
import 'package:go_router/go_router.dart';

class WhatsNewPage extends StatelessWidget {
  const WhatsNewPage({
    this.selectedColor,
    super.key,
  });

  final Color? selectedColor;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const CustomScrollView(
        slivers: [
          _SliverWhatsNewAppBar(),
          SliverSafeArea(
            top: false,
            sliver: SliverToBoxAdapter(
              child: _WhatsNewBody(),
            ),
          ),
          SliverToBoxAdapter(
            child: SizedBox(height: AppSpacing.xxl * 4),
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
  const _WhatsNewBody();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
      child: HackerNewsText(context.l10n.whatsNewDescription),
    );
  }
}
