import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:glider/pages/stories_page.dart';
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

    return const StoriesPage();
  }
}
