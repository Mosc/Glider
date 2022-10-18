import 'package:collection/collection.dart';
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

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return HtmlWidget(
      _html,
      buildAsync: false,
      factoryBuilder: _DecoratedWidgetFactory.new,
      onTapUrl: (String url) => UrlUtil.tryLaunch(context, ref, url),
      textStyle: Theme.of(context).textTheme.bodyMedium,
    );
  }
}

class _DecoratedWidgetFactory extends WidgetFactory {
  static final RegExp _quoteRegex = RegExp(r'\s*(&gt;)+\s*');
  static final RegExp _unescapedQuoteRegex = RegExp(r'\s*>+\s*');

  @override
  void parse(BuildMetadata meta) {
    if (meta.element.localName == 'pre') {
      meta.register(_preOp);
    } else if (meta.element.innerHtml.startsWith(_quoteRegex)) {
      meta.register(_quoteOp);
    } else {
      super.parse(meta);
    }
  }

  late final BuildOp _preOp = BuildOp(
    defaultStyles: (dom.Element element) => <String, String>{
      'white-space': 'pre-wrap',
    },
  );

  late final BuildOp _quoteOp = BuildOp(
    defaultStyles: (dom.Element element) => <String, String>{
      'margin': '0',
    },
    onTree: (BuildMetadata meta, BuildTree tree) {
      final BuildBit<dynamic, dynamic>? bit = tree.bits.firstOrNull;

      if (bit is TextBit) {
        TextBit(
          tree,
          bit.data.replaceAll(_unescapedQuoteRegex, ''),
          tsb: bit.tsb,
        ).insertBefore(bit);
        bit.detach();
      }
    },
    onWidgets: (
      BuildMetadata meta,
      Iterable<WidgetPlaceholder<dynamic>> widgets,
    ) =>
        listOrNull(
      buildColumnPlaceholder(meta, widgets)!.wrapWith(
        (_, Widget child) {
          final Iterable<RegExpMatch> matches =
              _quoteRegex.allMatches(meta.element.innerHtml);

          for (final RegExpMatch _ in matches) {
            child = Block(child: child);
          }

          return SizedBox(
            width: double.infinity,
            child: child,
          );
        },
      ),
    ),
  );
}
