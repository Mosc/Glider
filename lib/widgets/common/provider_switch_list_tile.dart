import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ProviderSwitchListTile extends HookWidget {
  const ProviderSwitchListTile({
    Key? key,
    required this.title,
    required this.provider,
    required this.onSave,
  }) : super(key: key);

  final String title;
  final RootProvider<Object, AsyncValue<bool>> provider;
  final Future<void> Function(bool value) onSave;

  @override
  Widget build(BuildContext context) {
    return SwitchListTile(
      title: Text(title),
      value: useProvider(provider).data?.value ?? true,
      onChanged: (bool newValue) async {
        await onSave(newValue);
        context.refresh(provider);
      },
    );
  }
}
