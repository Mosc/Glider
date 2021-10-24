import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ProviderSwitchListTile extends HookConsumerWidget {
  const ProviderSwitchListTile({
    Key? key,
    required this.title,
    required this.provider,
    required this.onSave,
  }) : super(key: key);

  final String title;
  final ProviderBase<AsyncValue<bool>> provider;
  final Future<void> Function(bool value) onSave;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SwitchListTile(
      title: Text(title),
      value: ref.watch(provider).asData?.value ?? true,
      onChanged: (bool newValue) async {
        await onSave(newValue);
        ref.refresh(provider);
      },
    );
  }
}
