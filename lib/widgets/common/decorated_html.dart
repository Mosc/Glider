import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:glider/utils/url_util.dart';
import 'package:glider/widgets/common/block.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:html/dom.dart' as dom;

class DecoratedHtml extends HookConsumerWidget {
  const DecoratedHtml(
    String html, {
    super.key,
    bool prependParagraphTag = true,
  })
  // Hacker News prefixes every paragraph with a tag except the first one.
  : _html = prependParagraphTag ? '<p>$html' : html;

  final String _html;

  static final RegExp _quoteRegex = RegExp(r'^\s?(&gt;)+');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return HtmlWidget(
      _html,
      buildAsync: false,
      customStylesBuilder: (dom.Element element) {
        if (_isQuote(element)) {
          return <String, String>{'margin': '0'};
        }

        return null;
      },
      customWidgetBuilder: (dom.Element element) {
        if (_isQuote(element)) {
          element.innerHtml = _trimQuote(element).trimLeft();

          if (element.innerHtml.isNotEmpty) {
            return Block(
              child: DecoratedHtml(
                element.outerHtml,
                prependParagraphTag: false,
              ),
            );
          } else {
            return const SizedBox.shrink();
          }
        }

        return null;
      },
      onTapUrl: (String url) => UrlUtil.tryLaunch(context, ref, url),
      textStyle: Theme.of(context).textTheme.bodyMedium,
    );
  }

  static bool _isQuote(dom.Element element) =>
      element.innerHtml.startsWith(_quoteRegex);

  static String _trimQuote(dom.Element element) =>
      element.innerHtml.replaceFirst(_quoteRegex, '');
}
