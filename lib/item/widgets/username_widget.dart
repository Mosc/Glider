import 'package:flutter/material.dart';
import 'package:glider/common/constants/app_spacing.dart';
import 'package:glider/item/widgets/avatar_widget.dart';

class UsernameWidget extends StatelessWidget {
  const UsernameWidget({
    super.key,
    required this.username,
    this.style = UsernameStyle.none,
    this.onTap,
  });

  final String username;
  final UsernameStyle style;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    void onPressed() => onTap?.call();
    void onLongPress() {}

    final padding = ButtonStyleButton.scaledPadding(
      const EdgeInsets.symmetric(horizontal: AppSpacing.l),
      const EdgeInsets.symmetric(horizontal: AppSpacing.m),
      const EdgeInsets.symmetric(horizontal: AppSpacing.s),
      // ignore: deprecated_member_use
      MediaQuery.textScalerOf(context).textScaleFactor,
    );
    const visualDensity = VisualDensity(
      horizontal: VisualDensity.minimumDensity,
      vertical: VisualDensity.minimumDensity,
    );
    const tapTargetSize = MaterialTapTargetSize.shrinkWrap;
    final icon = AvatarWidget(username: username);
    final label = Text(
      username,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );

    return switch (style) {
      UsernameStyle.loggedInUser => FilledButton.icon(
          onPressed: onPressed,
          onLongPress: onLongPress,
          style: FilledButton.styleFrom(
            padding: padding,
            visualDensity: visualDensity,
            tapTargetSize: tapTargetSize,
          ),
          icon: icon,
          label: label,
        ),
      UsernameStyle.storyUser => FilledButton.tonalIcon(
          onPressed: onPressed,
          onLongPress: onLongPress,
          style: FilledButton.styleFrom(
            padding: padding,
            visualDensity: visualDensity,
            tapTargetSize: tapTargetSize,
          ),
          icon: icon,
          label: label,
        ),
      UsernameStyle.none => ElevatedButton.icon(
          onPressed: onPressed,
          onLongPress: onLongPress,
          style: ElevatedButton.styleFrom(
            padding: padding,
            visualDensity: visualDensity,
            tapTargetSize: tapTargetSize,
          ),
          icon: icon,
          label: label,
        ),
    };
  }
}

enum UsernameStyle {
  loggedInUser,
  storyUser,
  none,
}
