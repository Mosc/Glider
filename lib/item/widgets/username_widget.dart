import 'package:flutter/material.dart';
import 'package:glider/common/constants/app_spacing.dart';
import 'package:glider/item/widgets/avatar_widget.dart';

class UsernameWidget extends StatelessWidget {
  UsernameWidget({
    required this.username,
    this.showAvatar = true,
    this.style = UsernameStyle.none,
    this.onTap,
  }) : super(key: ValueKey(username));

  final String username;
  final bool showAvatar;
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
      UsernameStyle.loggedInUser when showAvatar => FilledButton.icon(
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
      UsernameStyle.loggedInUser => FilledButton(
          onPressed: onPressed,
          onLongPress: onLongPress,
          style: FilledButton.styleFrom(
            padding: padding,
            visualDensity: visualDensity,
            tapTargetSize: tapTargetSize,
          ),
          child: label,
        ),
      UsernameStyle.storyUser when showAvatar => FilledButton.tonalIcon(
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
      UsernameStyle.storyUser => FilledButton(
          onPressed: onPressed,
          onLongPress: onLongPress,
          style: FilledButton.styleFrom(
            padding: padding,
            visualDensity: visualDensity,
            tapTargetSize: tapTargetSize,
          ),
          child: label,
        ),
      UsernameStyle.none when showAvatar => ElevatedButton.icon(
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
      UsernameStyle.none => ElevatedButton(
          onPressed: onPressed,
          onLongPress: onLongPress,
          style: ElevatedButton.styleFrom(
            padding: padding,
            visualDensity: visualDensity,
            tapTargetSize: tapTargetSize,
          ),
          child: label,
        ),
    };
  }
}

enum UsernameStyle {
  loggedInUser,
  storyUser,
  none,
}
