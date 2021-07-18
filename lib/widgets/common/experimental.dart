import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:glider/utils/text_style_extension.dart';
import 'package:glider/widgets/common/block.dart';

class Experimental extends StatelessWidget {
  const Experimental({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final AppLocalizations appLocalizations = AppLocalizations.of(context)!;

    return Block(
      child: Row(
        children: <Widget>[
          Icon(
            FluentIcons.warning_24_regular,
            size:
                Theme.of(context).textTheme.bodyText2?.scaledFontSize(context),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(appLocalizations.experimentalDescription),
          ),
        ],
      ),
    );
  }
}
