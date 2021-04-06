import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:glider/utils/url_util.dart';
import 'package:glider/widgets/common/block.dart';
import 'package:html/dom.dart' as dom;

class DecoratedHtml extends StatelessWidget {
  const DecoratedHtml(String html, {Key? key, bool prependParagraphTag = true})
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
        if (element.localName == 'pre') {
          return <String, String>{
            'margin-top': '1em',
            'margin-bottom': '1em',
            'font-family': 'monospace',
          };
        }

        if (_isQuote(element)) {
          return <String, String>{'margin': '0'};
        }

        return null;
      },
      customWidgetBuilder: (dom.Element element) {
        if (_isQuote(element)) {
          final String unquotedInnerHtml =
              _trimQuoteCharacters(element.innerHtml).trimLeft();

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
      onTapUrl: (String url) => UrlUtil.tryLaunch(context, url),
      textStyle: Theme.of(context).textTheme.bodyText2,
    );
  }

  static bool _isQuote(dom.Element element) =>
      element.innerHtml.startsWith(_quoteCharacter);

  static String _trimQuoteCharacters(String from) =>
      from.replaceFirst(RegExp('^($_quoteCharacter)+'), '');
}
