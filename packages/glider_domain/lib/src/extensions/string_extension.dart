import 'package:html/dom.dart' as html_dom;
import 'package:html/parser.dart' as html_parser;

// https://news.ycombinator.com/formatdoc
extension StringExtension on String {
  String convertHtmlToHackerNews() => html_parser.parseFragment(this).convert();
}

extension on html_dom.Node {
  String get _url => attributes['href'] ?? text!;

  String convert() => switch (this) {
        // "Urls become links, except in the text field of a submission."
        // We cheat by not handling submissions any differently.
        // Unlike the website, we prefer showing the full URL.
        html_dom.Element(localName: 'a') => '[$_url](${Uri.decodeFull(_url)})',
        // "Text surrounded by asterisks is italicized."
        html_dom.Element(localName: 'i') => '*${convertNodes()}*',
        // "Blank lines separate paragraphs."
        html_dom.Element(localName: 'p') => '\n\n${convertNodes()}',
        // "Text after a blank line that is indented by two or more spaces is
        // reproduced verbatim. (This is intended for code.)"
        // No need to add spaces here though, as they're part of the HTML.
        html_dom.Text(parentNode: html_dom.Element(localName: 'code')) => text!,
        // "To get a literal asterisk, use \* or **."
        // Escape asterisks not surrounded by spaces.
        // There may be newlines part of the HTML which don't show up on the
        // website. Replace them with a space, but exclude starting newlines.
        // There may be adjacent spaces. Replace them with single spaces.
        html_dom.Text() => text!
            .replaceAll(RegExp(r'(?<!^| )\*|\*(?! |$)'), r'\*')
            .replaceAll(RegExp(r'(?<!^)\n'), ' ')
            .replaceAll(RegExp(' {2,}'), ' '),
        _ => convertNodes(),
      };

  String convertNodes() => nodes.map((node) => node.convert()).join();
}
