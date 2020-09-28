import 'package:html_unescape/html_unescape_small.dart';

class FormattingUtil {
  FormattingUtil._();

  static String convertHtmlToHackerNews(String value) => HtmlUnescape()
      .convert(value)
      // "Blank lines separate paragraphs."
      .replaceAll('<p>', '\n')
      // "Text surrounded by asterisks is italicized, if the character after the
      // first asterisk isn't whitespace."
      .replaceAllMapped(
        RegExp(r'\<i\>(.*?)\<\/i\>'),
        (Match match) => '*${match[1]}*',
      )
      // "Text after a blank line that is indented by two or more spaces is
      // reproduced verbatim. (This is intended for code.)"
      .replaceAllMapped(
        RegExp(r'\<pre\>\<code\>(.*?)\<\/code\>\<\/pre\>', dotAll: true),
        (Match match) => match[1].trimRight(),
      )
      // "Urls become links, except in the text field of a submission."
      .replaceAllMapped(
        RegExp(r'\<a href=\"(.*?)\".*?\>.*?\<\/a\>'),
        (Match match) => match[1],
      )
      .replaceAll('\n', '\n\n');

  static String convertHackerNewsToHtml(String value) => value
      // "Text surrounded by asterisks is italicized, if the character after the
      // first asterisk isn't whitespace."
      .replaceAllMapped(
        RegExp(r'\*(\S.*?)\*'),
        (Match match) => '<i>${match[1]}</i>',
      )
      // "Text after a blank line that is indented by two or more spaces is
      // reproduced verbatim. (This is intended for code.)"
      .replaceAllMapped(
        RegExp(r'^\ {2,}(.*)', multiLine: true),
        (Match match) => '<pre>${match[1]}</pre>',
      )
      // "Urls become links, except in the text field of a submission."
      .replaceAllMapped(
        RegExp(r'(^|\s)(http(s?)\:\/\/\S*[\w/])'),
        (Match match) => '${match[1]}<a href="${match[2]}">${match[2]}</a>',
      )
      // "Blank lines separate paragraphs."
      .replaceAll(RegExp('\n{2,}'), '<p>');
}
