import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:glider/pages/user_page.dart';
import 'package:glider/providers/persistence_provider.dart';
import 'package:glider/widgets/common/smooth_animated_switcher.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class MetadataUsername extends HookConsumerWidget {
  const MetadataUsername({Key? key, required this.username, this.rootUsername})
      : super(key: key);

  final String username;
  final String? rootUsername;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final bool byLoggedInUser = username == ref.watch(usernameProvider).value;
    final bool byRoot = username == rootUsername;

    return GestureDetector(
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (_) => UserPage(id: username),
        ),
      ),
      child: Row(
        children: <Widget>[
          SmoothAnimatedSwitcher.horizontal(
            condition: ref.watch(showAvatarProvider).value ?? false,
            child: Row(
              children: <Widget>[
                _buildAvatar(context),
                const SizedBox(width: 6),
              ],
            ),
          ),
          if (byLoggedInUser || byRoot)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 3),
              decoration: BoxDecoration(
                color: byLoggedInUser ? colorScheme.primary : null,
                border: Border.all(color: colorScheme.primary),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                username,
                style: textTheme.bodySmall?.copyWith(
                  color: byLoggedInUser
                      ? colorScheme.onPrimary
                      : colorScheme.primary,
                ),
              ),
            )
          else
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 1),
              child: Text(
                username,
                style:
                    textTheme.bodySmall?.copyWith(color: colorScheme.primary),
              ),
            ),
        ],
      ),
    );
  }

  CustomPaint _buildAvatar(BuildContext context) {
    final double scaleFactor = MediaQuery.of(context).textScaleFactor;
    final double pixelSize = 2 * scaleFactor;
    final double avatarSize = 7 * pixelSize;

    return CustomPaint(
      painter: _AvatarPainter(
        username: username,
        pixelSize: pixelSize,
        scaleFactor: scaleFactor,
      ),
      size: Size(avatarSize, avatarSize),
    );
  }
}

// Algorithm based on https://news.ycombinator.com/item?id=30668207 by tomxor.
class _AvatarPainter extends CustomPainter {
  const _AvatarPainter(
      {required this.username, required this.pixelSize, this.scaleFactor = 1});

  final String username;
  final double pixelSize;
  final double scaleFactor;

  @override
  void paint(Canvas canvas, Size size) {
    const int seedSteps = 28;
    final Offset start = Offset(scaleFactor, scaleFactor);
    final List<Offset> points = <Offset>[];
    final Paint paint = Paint()..strokeWidth = pixelSize;
    int seed = 1;

    for (int i = seedSteps + username.length - 1; i >= seedSteps; i--) {
      seed = _xorShift32(seed);
      seed += username.codeUnitAt(i - seedSteps);
    }

    paint.color = Color(seed >> 8 | 0xff000000);

    for (int i = seedSteps - 1; i >= 0; i--) {
      seed = _xorShift32(seed);

      final int x = i & 3;
      final int y = i >> 2;

      if (seed.toUnsigned(32) >> seedSteps + 1 > x * x / 3 + y / 2) {
        points
          ..add(Offset(pixelSize * 3 + pixelSize * x, pixelSize * y) + start)
          ..add(Offset(pixelSize * 3 - pixelSize * x, pixelSize * y) + start);
      }
    }

    canvas.drawPoints(PointMode.points, points, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;

  static int _xorShift32(int number) {
    int result = number;
    result ^= result << 13;
    result ^= result.toUnsigned(32) >> 17;
    result ^= result << 5;
    return result;
  }
}
