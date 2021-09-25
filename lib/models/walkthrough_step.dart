import 'package:flutter/widgets.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

enum WalkthroughStep {
  step1,
  step2,
  step3,
}

extension WalktroughStepExtension on WalkthroughStep {
  int get number {
    switch (this) {
      case WalkthroughStep.step1:
        return 1;
      case WalkthroughStep.step2:
        return 2;
      case WalkthroughStep.step3:
        return 3;
    }
  }

  String text(BuildContext context) {
    final bool rtl = Directionality.of(context) == TextDirection.rtl;
    final String startToEnd = rtl
        ? AppLocalizations.of(context)!.left
        : AppLocalizations.of(context)!.right;
    final String endToStart = rtl
        ? AppLocalizations.of(context)!.right
        : AppLocalizations.of(context)!.left;

    switch (this) {
      case WalkthroughStep.step1:
        return AppLocalizations.of(context)!.walkthroughStep1(
          startToEnd,
          endToStart,
          AppLocalizations.of(context)!.appName,
        );
      case WalkthroughStep.step2:
        return AppLocalizations.of(context)!.walkthroughStep2;
      case WalkthroughStep.step3:
        return AppLocalizations.of(context)!.walkthroughStep3(
          endToStart,
        );
    }
  }

  bool get canLongPress {
    switch (this) {
      case WalkthroughStep.step1:
        return false;
      case WalkthroughStep.step2:
      case WalkthroughStep.step3:
        return true;
    }
  }

  WalkthroughStep get nextStep {
    switch (this) {
      case WalkthroughStep.step1:
        return WalkthroughStep.step2;
      case WalkthroughStep.step2:
        return WalkthroughStep.step3;
      case WalkthroughStep.step3:
        throw UnsupportedError('No next step found for $this');
    }
  }
}
