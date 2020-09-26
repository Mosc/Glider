import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:glider/utils/url_util.dart';
import 'package:glider/widgets/common/block.dart';
import 'package:html/dom.dart' as dom;

class DecoratedHtml extends StatelessWidget {
  const DecoratedHtml(String html, {Key key, bool prependParagraphTag = true})
      // Hacker News prefixes every paragraph with a tag except the first one.
      : _html = prependParagraphTag ? '<p>$html' : html,
        super(key: key);

  final String _html;

  static const String _quoteCharacter = '&gt;';

  @override
  Widget build(BuildContext context) {
    return HtmlWidget(
      _html,
      buildAsync: false,
      hyperlinkColor: Theme.of(context).primaryColor,
      customStylesBuilder: (dom.Element element) {
        switch (element.localName) {
          case 'pre':
            return <String, String>{'margin-bottom': '1em'};
        }

        return null;
      },
      customWidgetBuilder: (dom.Element element) {
        if (isQuote(element)) {
          final String unquotedInnerHtml =
              trimQuoteCharacters(element.innerHtml).trimLeft();

          if (unquotedInnerHtml.isNotEmpty) {
            final String unquotedOuterHtml = element.outerHtml
                .replaceFirst(element.innerHtml, unquotedInnerHtml);
            return Block(
              child: DecoratedHtml(
                unquotedOuterHtml,
                prependParagraphTag: false,
              ),
            );
          } else {
            return const SizedBox.shrink();
          }
        }

        return null;
      },
      onTapUrl: UrlUtil.tryLaunch,
      textStyle: Theme.of(context).textTheme.bodyText2,
    );
  }

  static bool isQuote(dom.Element element) =>
      element.innerHtml.startsWith(_quoteCharacter);

  static String trimQuoteCharacters(String from) {
    return from.replaceFirst(RegExp('^($_quoteCharacter)+'), '');
  }
}
