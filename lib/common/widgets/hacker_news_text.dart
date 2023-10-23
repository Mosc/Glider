import 'dart:convert';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:glider/common/constants/app_spacing.dart';
import 'package:glider/common/extensions/theme_data_extension.dart';
import 'package:glider/common/extensions/uri_extension.dart';
import 'package:markdown/markdown.dart' as md;

class HackerNewsText extends StatelessWidget {
  const HackerNewsText(this.data, {super.key});

  final String data;

  @override
  Widget build(BuildContext context) {
    final styleSheet = MarkdownStyleSheet(
      blockSpacing: Theme.of(context).textTheme.bodyMedium?.fontSize,
      blockquote: Theme.of(context).textTheme.bodyMedium,
      blockquoteDecoration:
          Theme.of(context).elevationToBoxDecoration(1).copyWith(
                borderRadius: const BorderRadius.all(Radius.circular(12)),
              ),
      blockquotePadding: AppSpacing.defaultTilePadding,
      a: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: Theme.of(context).colorScheme.primary,
            decoration: TextDecoration.underline,
          ),
      code: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: Theme.of(context).colorScheme.secondary,
            fontFamily: 'NotoSansMono',
          ),
      codeblockPadding: AppSpacing.defaultTilePadding,
      codeblockDecoration: BoxDecoration(
        color: Theme.of(context).elevationToColor(4),
      ),
      horizontalRuleDecoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: Theme.of(context).colorScheme.outline,
          ),
        ),
      ),
    );
    return _HackerNewsMarkdownBody(
      data: data,
      styleSheet: styleSheet,
      onTapLink: (text, href, title) async {
        if (href != null) {
          await Uri.tryParse(href)?.tryLaunch(title: title);
        }
      },
      extensionSet: md.ExtensionSet(
        const [
          HackerNewsCodeBlockSyntax(),
          md.FencedCodeBlockSyntax(),
          md.EmptyBlockSyntax(),
          md.BlockquoteSyntax(),
          md.HorizontalRuleSyntax(),
          md.UnorderedListSyntax(),
          md.OrderedListSyntax(),
          md.ParagraphSyntax(),
        ],
        [
          HackerNewsAsteriskEscapeSyntax(),
          HackerNewsEmphasisSyntax.asterisk(),
          HackerNewsAutolinkExtensionSyntax(),
          md.EscapeSyntax(),
          md.AutolinkSyntax(),
          md.EmailAutolinkSyntax(),
          md.CodeSyntax(),
        ],
      ),
      withDefaultBlockSyntaxes: false,
      withDefaultInlineSyntaxes: false,
      builders: {'pre': _PreElementBuilder(styleSheet)},
      fitContent: false,
    );
  }
}

class _HackerNewsMarkdownBody extends MarkdownBody {
  const _HackerNewsMarkdownBody({
    required super.data,
    super.styleSheet,
    super.onTapLink,
    super.extensionSet,
    this.withDefaultBlockSyntaxes = true,
    this.withDefaultInlineSyntaxes = true,
    super.builders,
    super.fitContent,
  });

  final bool withDefaultBlockSyntaxes;
  final bool withDefaultInlineSyntaxes;

  @override
  State<MarkdownWidget> createState() => _HackerNewsMarkdownBodyState();
}

class _HackerNewsMarkdownBodyState extends State<_HackerNewsMarkdownBody>
    implements MarkdownBuilderDelegate {
  late List<Widget> _children;
  final List<GestureRecognizer> _recognizers = <GestureRecognizer>[];

  @override
  void didChangeDependencies() {
    _parseMarkdown();
    super.didChangeDependencies();
  }

  @override
  void didUpdateWidget(_HackerNewsMarkdownBody oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.data != oldWidget.data ||
        widget.styleSheet != oldWidget.styleSheet) {
      _parseMarkdown();
    }
  }

  @override
  void dispose() {
    _disposeRecognizers();
    super.dispose();
  }

  void _parseMarkdown() {
    _disposeRecognizers();
    final fallbackStyleSheet =
        MarkdownStyleSheet.fromTheme(Theme.of(context)).copyWith(
      // ignore: deprecated_member_use
      textScaleFactor: MediaQuery.textScalerOf(context).textScaleFactor,
    );
    final styleSheet = fallbackStyleSheet.merge(widget.styleSheet);
    final document = md.Document(
      extensionSet: widget.extensionSet,
      encodeHtml: false,
      withDefaultBlockSyntaxes: widget.withDefaultBlockSyntaxes,
      withDefaultInlineSyntaxes: widget.withDefaultInlineSyntaxes,
    );
    final lines = const LineSplitter().convert(widget.data);
    final astNodes = document.parseLines(lines);
    final builder = MarkdownBuilder(
      delegate: this,
      selectable: widget.selectable,
      styleSheet: styleSheet,
      imageDirectory: widget.imageDirectory,
      imageBuilder: widget.imageBuilder,
      checkboxBuilder: widget.checkboxBuilder,
      bulletBuilder: widget.bulletBuilder,
      builders: widget.builders,
      paddingBuilders: widget.paddingBuilders,
      fitContent: widget.fitContent,
      listItemCrossAxisAlignment: widget.listItemCrossAxisAlignment,
      onTapText: widget.onTapText,
      softLineBreak: widget.softLineBreak,
    );
    _children = builder.build(astNodes);
  }

  void _disposeRecognizers() {
    if (_recognizers.isEmpty) return;

    for (final recognizer in _recognizers) {
      recognizer.dispose();
    }

    _recognizers.clear();
  }

  @override
  GestureRecognizer createLink(String text, String? href, String title) {
    final recognizer = TapGestureRecognizer()
      ..onTap = () => widget.onTapLink?.call(text, href, title);
    _recognizers.add(recognizer);
    return recognizer;
  }

  @override
  TextSpan formatText(MarkdownStyleSheet styleSheet, String code) {
    return TextSpan(
      text: code.replaceAll(RegExp(r'\n$'), ''),
      style: styleSheet.code,
    );
  }

  @override
  Widget build(BuildContext context) => widget.build(context, _children);
}

// Emphasis only needs two spaces, as opposed to the Markdown default of four.
class HackerNewsCodeBlockSyntax extends md.CodeBlockSyntax {
  const HackerNewsCodeBlockSyntax();

  @override
  RegExp get pattern => RegExp(r'^(?:  | ?\t)(.*)$');
}

// Auto-linking should not be different from default Markdown, but a bug in its
// implementation causes it to not handle links directly after newlines.
class HackerNewsAutolinkExtensionSyntax extends md.AutolinkExtensionSyntax {
  @override
  bool tryMatch(md.InlineParser parser, [int? startMatchPos]) {
    startMatchPos ??= parser.pos;
    final startMatch = pattern.matchAsPrefix(parser.source, startMatchPos);
    if (startMatch == null) {
      return false;
    }

    // When it is a link and it is not preceded by `*`, `_`, `~`, `(`, or `>`,
    // it is invalid. See
    // https://github.github.com/gfm/#extended-autolink-path-validation.
    if (startMatch[1] != null && parser.pos > 0) {
      final precededBy = String.fromCharCode(parser.charAt(parser.pos - 1));
      const validPrecedingChars = {'\n', ' ', '*', '_', '~', '(', '>'};
      if (validPrecedingChars.contains(precededBy) == false) {
        return false;
      }
    }

    // When it is an email link and followed by `_` or `-`, it is invalid. See
    // https://github.github.com/gfm/#example-633
    if (startMatch[2] != null && parser.source.length > startMatch.end) {
      final followedBy = String.fromCharCode(parser.charAt(startMatch.end));
      const invalidFollowingChars = {'_', '-'};
      if (invalidFollowingChars.contains(followedBy)) {
        return false;
      }
    }

    parser.writeText();
    return onMatch(parser, startMatch);
  }
}

// Unlike default Markdown, double asterisks do not result in a strong tag.
class HackerNewsEmphasisSyntax extends md.DelimiterSyntax {
  HackerNewsEmphasisSyntax.asterisk()
      : super(
          r'\*+',
          requiresDelimiterRun: true,
          allowIntraWord: true,
          tags: _tags,
          startCharacter: '*'.codeUnits.single,
        );

  static final _tags = [md.DelimiterTag('em', 1)];
}

// The use of asterisks for emphasis can be escaped with either a backslash
// or another asterisk. Markdown already takes care of the former.
class HackerNewsAsteriskEscapeSyntax extends md.InlineSyntax {
  HackerNewsAsteriskEscapeSyntax()
      : super(
          r'\*(\*)',
          startCharacter: '*'.codeUnits.single,
        );

  @override
  bool onMatch(md.InlineParser parser, Match match) {
    parser.addNode(md.Text(match[1]!));
    return true;
  }
}

// Unlike the default implementation, wrap pre text rather than scrolling it.
class _PreElementBuilder extends MarkdownElementBuilder {
  _PreElementBuilder(this.styleSheet);

  final MarkdownStyleSheet styleSheet;

  @override
  Widget? visitText(md.Text text, TextStyle? preferredStyle) {
    return Padding(
      padding: styleSheet.codeblockPadding ?? EdgeInsets.zero,
      child: Text(
        text.text.replaceAll(RegExp(r'\n$'), ''),
        style: styleSheet.code,
      ),
    );
  }
}
