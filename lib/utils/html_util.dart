import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart' as parser;

class HtmlUtil {
  const HtmlUtil._();

  static String getTitle(dynamic input) {
    final dom.Document document = parser.parse(input);
    return document?.head?.querySelector('title')?.text;
  }

  static Map<String, String> getHiddenFormValues(dynamic input) {
    final dom.Document document = parser.parse(input);
    final dom.Element form =
        document?.body?.getElementsByTagName('form')?.first;
    final Iterable<dom.Element> hiddenInputs =
        form?.querySelectorAll("input[type='hidden']");
    return <String, String>{
      if (hiddenInputs != null)
        for (dom.Element hiddenInput in hiddenInputs)
          hiddenInput.attributes['name']: hiddenInput.attributes['value']
    };
  }
}
