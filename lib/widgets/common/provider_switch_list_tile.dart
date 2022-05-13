import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ProviderSwitchListTile extends HookConsumerWidget {
  const ProviderSwitchListTile({
    super.key,
    required this.title,
    this.trailing,
    required this.provider,
    required this.onSave,
  });

  final String title;
  final Widget? trailing;
  final ProviderBase<AsyncValue<bool>> provider;
  final Future<void> Function(bool value) onSave;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SwitchListTile(
      title: Row(
        children: <Widget>[
          Text(title),
          if (trailing != null) trailing!,
        ],
      ),
      value: ref.watch(provider).value ?? false,
      onChanged: (bool newValue) async {
        await onSave(newValue);
        ref.invalidate(provider);
      },
    );
  }
}
