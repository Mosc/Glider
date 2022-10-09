import 'package:flutter/widgets.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

enum UserTag {
  founder,
  ceo,
  moderator,
  exModerator,
}

extension UserTagExtension on UserTag {
  String title(BuildContext context) {
    switch (this) {
      case UserTag.founder:
        return AppLocalizations.of(context).founder;
      case UserTag.ceo:
        return AppLocalizations.of(context).ceo;
      case UserTag.moderator:
        return AppLocalizations.of(context).moderator;
      case UserTag.exModerator:
        return AppLocalizations.of(context).exModerator;
    }
  }
}
