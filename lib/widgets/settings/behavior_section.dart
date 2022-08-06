import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:glider/providers/persistence_provider.dart';
import 'package:glider/providers/repository_provider.dart';
import 'package:glider/widgets/common/provider_switch_list_tile.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

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
