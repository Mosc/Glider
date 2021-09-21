import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/widgets.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

enum SearchOrder {
  byDate,
  byRelevance,
}

extension SearchOrderExtension on SearchOrder {
  String title(BuildContext context) {
    final AppLocalizations appLocalizations = AppLocalizations.of(context)!;

    switch (this) {
      case SearchOrder.byDate:
        return appLocalizations.byDate;
      case SearchOrder.byRelevance:
        return appLocalizations.byRelevance;
    }
  }

  IconData get icon {
    switch (this) {
      case SearchOrder.byDate:
        return FluentIcons.new_24_regular;
      case SearchOrder.byRelevance:
        return FluentIcons.ribbon_star_24_regular;
    }
  }

  String get apiPath {
    switch (this) {
      case SearchOrder.byDate:
        return 'search_by_date';
      case SearchOrder.byRelevance:
        return 'search';
    }
  }
}
