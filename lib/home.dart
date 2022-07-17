import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:glider/pages/stories_page.dart';
import 'package:glider/utils/color_extension.dart';
import 'package:glider/utils/uni_links_handler.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class Home extends HookConsumerWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    useMemoized(() => UniLinksHandler.init(context));
    useEffect(
      () => UniLinksHandler.dispose,
      <Object?>[UniLinksHandler.uriSubscription],
    );

    final ValueNotifier<bool> isEdgeToEdgeState = useState(true);

    useMemoized(
      () async {
        if (Platform.isAndroid) {
          final AndroidDeviceInfo androidInfo =
              await DeviceInfoPlugin().androidInfo;
          isEdgeToEdgeState.value = androidInfo.version.sdkInt != null &&
              androidInfo.version.sdkInt! >= 29;
        }
      },
    );

    final bool isDark = Theme.of(context).brightness.isDark;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        systemNavigationBarColor: isEdgeToEdgeState.value
            ? Colors.transparent
            : isDark
                ? Colors.black38
                : const Color(0xE6FFFFFF),
        systemNavigationBarIconBrightness:
            isDark ? Brightness.light : Brightness.dark,
      ),
      child: const StoriesPage(),
    );
  }
}
