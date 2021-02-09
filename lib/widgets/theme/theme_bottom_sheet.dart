import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:glider/app_theme.dart';
import 'package:glider/models/theme_base.dart';
import 'package:glider/providers/persistence_provider.dart';
import 'package:glider/providers/repository_provider.dart';
import 'package:glider/utils/color_extension.dart';
import 'package:glider/widgets/common/smooth_animated_cross_fade.dart';
import 'package:glider/widgets/common/smooth_animated_switcher.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ThemeDialog extends HookWidget {
  const ThemeDialog({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Wrap(
          children: <Widget>[
            _buildHorizontalScrollable(
              children: ThemeBase.values
                  .map((ThemeBase base) => _ThemeBaseButton(base))
                  .toList(growable: false),
            ),
            const SizedBox(width: double.infinity, height: 12),
            _buildHorizontalScrollable(
              children: Colors.primaries
                  .map(
                    (MaterialColor materialColor) => <int>[300, 400, 500, 600]
                        .map((int shade) => materialColor[shade])
                        .firstWhere(
                          (Color color) => color.isDark,
                          orElse: () => materialColor[700],
                        ),
                  )
                  .map((Color color) => _ThemeColorButton(color))
                  .toList(growable: false),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHorizontalScrollable({@required List<Widget> children}) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(children: children),
      ),
    );
  }
}

class _ThemeBaseButton extends HookWidget {
  const _ThemeBaseButton(this.base, {Key key}) : super(key: key);

  final ThemeBase base;

  @override
  Widget build(BuildContext context) {
    final ThemeBase themeBase =
        useProvider(themeBaseProvider).data?.value ?? ThemeBase.system;

    useMemoized(
      () => Future<void>.microtask(() {
        if (base == themeBase) {
          Scrollable.ensureVisible(
            context,
            duration: const Duration(milliseconds: 400),
            curve: Curves.easeInOut,
            alignmentPolicy: ScrollPositionAlignmentPolicy.keepVisibleAtEnd,
          );
        }
      }),
    );

    return Padding(
      padding: const EdgeInsets.all(4),
      child: ElevatedButtonTheme(
        data: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            primary: base.color(context),
            onPrimary: base.color(context).isDark ? Colors.white : Colors.black,
            shape: const StadiumBorder(),
            minimumSize: const Size(40, 40),
          ),
        ),
        child: ElevatedButton.icon(
          onPressed: () async {
            await context.read(storageRepositoryProvider).setThemeBase(base);
            await context.refresh(themeBaseProvider);
          },
          label: Text(base.title),
          icon: SmoothAnimatedCrossFade(
            duration: kThemeChangeDuration,
            condition: base == themeBase,
            trueChild: const Icon(FluentIcons.checkmark_24_regular),
          ),
        ),
      ),
    );
  }
}

class _ThemeColorButton extends HookWidget {
  const _ThemeColorButton(this.color, {Key key}) : super(key: key);

  final Color color;

  @override
  Widget build(BuildContext context) {
    final Color themeColor =
        useProvider(themeColorProvider).data?.value ?? AppTheme.defaultColor;

    useMemoized(
      () => Future<void>.microtask(() {
        if (color == themeColor) {
          Scrollable.ensureVisible(
            context,
            duration: const Duration(milliseconds: 400),
            curve: Curves.easeInOut,
            alignmentPolicy: ScrollPositionAlignmentPolicy.keepVisibleAtEnd,
          );
        }
      }),
    );

    return ElevatedButtonTheme(
      data: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          primary: color,
          shape: const CircleBorder(),
          minimumSize: const Size(40, 40),
          padding: EdgeInsets.zero,
        ),
      ),
      child: ElevatedButton(
        onPressed: () async {
          await context.read(storageRepositoryProvider).setThemeColor(color);
          await context.refresh(themeColorProvider);
        },
        child: SmoothAnimatedSwitcher(
          duration: kThemeChangeDuration,
          condition: color == themeColor,
          child: const Icon(FluentIcons.checkmark_24_regular),
        ),
      ),
    );
  }
}
