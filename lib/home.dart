import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:glider/pages/stories_page.dart';
import 'package:glider/utils/uni_links_handler.dart';
import 'package:jiffy/jiffy.dart';

class Home extends HookWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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

    return const StoriesPage();
  }
}
