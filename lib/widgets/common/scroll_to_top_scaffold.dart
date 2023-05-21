import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:glider/utils/animation_util.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ScrollToTopScaffold extends HookConsumerWidget {
  const ScrollToTopScaffold({super.key, required this.body});

  final Widget body;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ValueNotifier<bool> showFloatingActionButtonState = useState(false);

    return Scaffold(
      body: NotificationListener<ScrollNotification>(
        onNotification: (ScrollNotification notification) {
          if (notification is ScrollUpdateNotification &&
              notification.scrollDelta != null &&
              notification.scrollDelta! != 0) {
            showFloatingActionButtonState.value =
                notification.scrollDelta!.isNegative &&
                    notification.metrics.pixels >
                        notification.metrics.minScrollExtent;
          }
          return false;
        },
        child: body,
      ),
      floatingActionButton: showFloatingActionButtonState.value
          ? FloatingActionButton.small(
              onPressed: () => PrimaryScrollController.of(context).animateTo(
                0,
                duration: AnimationUtil.defaultDuration,
                curve: AnimationUtil.defaultCurve,
              ),
              tooltip: AppLocalizations.of(context).scrollToTop,
              child: const Icon(FluentIcons.arrow_upload_24_regular),
            )
          : null,
    );
  }
}
