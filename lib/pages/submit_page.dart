import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:glider/widgets/common/floating_app_bar_scroll_view.dart';
import 'package:glider/widgets/submit/submit_body.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class SubmitPage extends HookConsumerWidget {
  const SubmitPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: FloatingAppBarScrollView(
        title: Text(AppLocalizations.of(context).submit),
        body: const SubmitBody(),
      ),
    );
  }
}
