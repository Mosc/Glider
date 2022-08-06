import 'package:flutter/material.dart';
import 'package:glider/widgets/settings/appearance_section.dart';
import 'package:glider/widgets/settings/behavior_section.dart';
import 'package:glider/widgets/settings/preview_section.dart';
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
