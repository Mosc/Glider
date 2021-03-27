import 'package:flutter/widgets.dart';

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
    final String startToEndText = rtl ? 'left' : 'right';
    final String endToStartText = rtl ? 'right' : 'left';

    switch (this) {
      case WalkthroughStep.step1:
        return 'Most important actions in Glider are performed using gestures. '
            'That includes upvoting, replying and opening links. '
            'For instance, try swiping $startToEndText on this tile.\n\n'
            'Or dismiss this walkthrough at any point by swiping '
            '$endToStartText.';
      case WalkthroughStep.step2:
        return "You've cast an upvote!\n\n"
            'Less frequently used actions, such as favoriting and sharing, '
            'are performed with long-presses. '
            'Use this method to simulate adding this walkthrough tile to your '
            'favorites. '
            'When logged in, favorites are added to your Hacker News account.';
      case WalkthroughStep.step3:
        return 'Great! Keep in mind that both upvotes and favorites can be '
            'undone using the mentioned interactions as well.\n\n'
            'Complete this walkthrough by swiping $endToStartText.';
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
        throw Exception('No next step found for $this');
    }
  }
}
