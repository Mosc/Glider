import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:glider/utils/animation_util.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ScrollToTopScaffold extends HookConsumerWidget {
  const ScrollToTopScaffold({super.key, this.body});

  final Widget? body;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ValueNotifier<bool> showFloatingActionButtonState = useState(false);

    final ScrollController? scrollController =
        PrimaryScrollController.of(context);

    useEffect(
      () {
        void onScrollListener() =>
            showFloatingActionButtonState.value = scrollController != null &&
                scrollController.hasClients &&
                scrollController.position.hasPixels &&
                scrollController.position.pixels > 0;

        scrollController?.addListener(onScrollListener);
        return () => scrollController?.removeListener(onScrollListener);
      },
      <Object?>[scrollController],
    );

    return Scaffold(
      body: body,
      floatingActionButton: showFloatingActionButtonState.value
          ? FloatingActionButton.small(
              onPressed: () => scrollController?.animateTo(
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
