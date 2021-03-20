import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';

class AppBarUtil {
  const AppBarUtil._();

  static Widget? buildFluentIconsLeading(BuildContext context) {
    final ModalRoute<dynamic>? parentRoute = ModalRoute.of(context);

    final bool canPop = parentRoute?.canPop ?? false;
    final bool useCloseButton =
        parentRoute is PageRoute<dynamic> && parentRoute.fullscreenDialog;

    if (canPop) {
      if (useCloseButton) {
        return IconButton(
          icon: const Icon(FluentIcons.dismiss_24_filled),
          tooltip: MaterialLocalizations.of(context).closeButtonTooltip,
          onPressed: () => Navigator.of(context).maybePop(),
        );
      } else {
        return IconButton(
          icon: const Icon(FluentIcons.arrow_left_24_filled),
          tooltip: MaterialLocalizations.of(context).backButtonTooltip,
          onPressed: () => Navigator.of(context).maybePop(),
        );
      }
    }

    return null;
  }
}
