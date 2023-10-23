import 'package:flutter/material.dart';
import 'package:glider/common/constants/app_spacing.dart';
import 'package:glider/common/extensions/widget_list_extension.dart';
import 'package:glider/l10n/extensions/app_localizations_extension.dart';

const _iconSize = 40.0;

class EmptyWidget extends StatelessWidget {
  const EmptyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.xl),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.air_outlined,
            size: _iconSize,
          ),
          Text(context.l10n.empty),
        ].spaced(height: AppSpacing.xl),
      ),
    );
  }
}
