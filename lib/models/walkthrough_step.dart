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
    final AppLocalizations appLocalizations = AppLocalizations.of(context)!;

    final bool rtl = Directionality.of(context) == TextDirection.rtl;
    final String startToEnd =
        rtl ? appLocalizations.left : appLocalizations.right;
    final String endToStart =
        rtl ? appLocalizations.right : appLocalizations.left;

    switch (this) {
      case WalkthroughStep.step1:
        return appLocalizations.walkthroughStep1(
            startToEnd, endToStart, appLocalizations.appName);
      case WalkthroughStep.step2:
        return appLocalizations.walkthroughStep2;
      case WalkthroughStep.step3:
        return appLocalizations.walkthroughStep3(endToStart);
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
