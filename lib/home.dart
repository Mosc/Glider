import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:glider/pages/stories_page.dart';
import 'package:glider/utils/color_extension.dart';
import 'package:glider/utils/uni_links_handler.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jiffy/jiffy.dart';

class Home extends HookConsumerWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    useMemoized(
      () async {
        final Locale locale = Localizations.localeOf(context);
        final Iterable<String> availableLocaleNames =
            Jiffy.getAllAvailableLocales();

        if (availableLocaleNames.contains(locale.languageCode)) {
          return Jiffy.locale(locale.languageCode);
        } else {
          return Jiffy.locale();
        }
      },
      <Object?>[Localizations.localeOf(context)],
    );

    useMemoized(() => UniLinksHandler.init(context));
    useEffect(
      () => UniLinksHandler.dispose,
      <Object?>[UniLinksHandler.uriSubscription],
    );

    final Color overlayColor =
        Theme.of(context).brightness.isDark ? Colors.black54 : Colors.black26;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light.copyWith(
        statusBarColor: overlayColor,
        systemNavigationBarColor: overlayColor,
      ),
      child: const StoriesPage(),
    );
  }
}
