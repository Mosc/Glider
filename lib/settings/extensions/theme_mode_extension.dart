import 'package:glider_domain/glider_domain.dart';
import 'package:intl/intl.dart' as intl;

extension ThemeModeExtension on ThemeMode {
  String get capitalizedLabel => intl.toBeginningOfSentenceCase(name)!;
}
