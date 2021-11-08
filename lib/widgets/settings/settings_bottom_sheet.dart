import 'package:flutter/widgets.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:glider/providers/persistence_provider.dart';
import 'package:glider/providers/repository_provider.dart';
import 'package:glider/widgets/common/provider_switch_list_tile.dart';
import 'package:glider/widgets/common/scrollable_bottom_sheet.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class SettingsBottomSheet extends HookConsumerWidget {
  const SettingsBottomSheet({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ScrollableBottomSheet(
      children: <Widget>[
        ProviderSwitchListTile(
          title: AppLocalizations.of(context)!.useCustomTabs,
          provider: useCustomTabsProvider,
          onSave: (bool value) => ref
              .read(storageRepositoryProvider)
              .setUseCustomTabs(value: value),
        ),
      ],
    );
  }
}
