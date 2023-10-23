import 'package:flutter/material.dart';
import 'package:glider/common/constants/app_spacing.dart';
import 'package:glider/common/widgets/animated_visibility.dart';
import 'package:glider/l10n/extensions/app_localizations_extension.dart';

class PreviewBottomPanel extends StatelessWidget {
  const PreviewBottomPanel({
    super.key,
    required this.visible,
    this.onChanged,
    required this.child,
  });

  final bool visible;
  final void Function(bool)? onChanged;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(
            // Use half of the available height for the preview (if visible).
            // The layout builder helps exclude any keyboard's view insets.
            child: LayoutBuilder(
              builder: (context, constraints) => ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: constraints.maxHeight / 2,
                ),
                child: AnimatedVisibility.vertical(
                  visible: visible,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Divider(height: 1),
                      Flexible(child: child),
                    ],
                  ),
                ),
              ),
            ),
          ),
          ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: MediaQuery.viewInsetsOf(context).bottom,
            ),
            // Alignment may seem unnecesary because it is hidden behind a
            // keyboard when relevant, but keyboards may be translucent.
            child: Align(
              alignment: Alignment.topCenter,
              child: SwitchListTile.adaptive(
                value: visible,
                onChanged: onChanged,
                title: Text(context.l10n.preview),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
