import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:glider/l10n/app_localizations.dart';
import 'package:glider/widgets/common/floating_app_bar_scroll_view.dart';
import 'package:glider/widgets/submit/submit_body.dart';

class SubmitPage extends HookWidget {
  const SubmitPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final AppLocalizations appLocalizations = AppLocalizations.of(context)!;

    return Scaffold(
      body: FloatingAppBarScrollView(
        title: Text(appLocalizations.submit),
        body: const SubmitBody(),
      ),
    );
  }
}
