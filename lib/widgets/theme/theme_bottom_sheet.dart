import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:glider/app_theme.dart';
import 'package:glider/models/theme_base.dart';
import 'package:glider/providers/persistence_provider.dart';
import 'package:glider/providers/repository_provider.dart';
import 'package:glider/repositories/storage_repository.dart';
import 'package:glider/utils/color_extension.dart';
import 'package:glider/widgets/common/smooth_animated_cross_fade.dart';
import 'package:glider/widgets/common/smooth_animated_switcher.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ThemeDialog extends HookWidget {
  const ThemeDialog({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final StorageRepository storageRepository =
        useProvider(storageRepositoryProvider);

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Wrap(
          children: <Widget>[
            _buildThemeBaseButtons(context, storageRepository),
            const SizedBox(width: double.infinity, height: 12),
            _buildThemeColorButtons(context, storageRepository),
          ],
        ),
      ),
    );
  }

  Widget _buildThemeBaseButtons(
      BuildContext context, StorageRepository storageRepository) {
    final ThemeBase currentThemeMode =
        useProvider(themeBaseProvider).data?.value ?? ThemeBase.system;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: <Widget>[
            for (ThemeBase themeBase in ThemeBase.values)
              Padding(
                padding: const EdgeInsets.all(4),
                child: ElevatedButtonTheme(
                  data: ElevatedButtonThemeData(
                    style: ElevatedButton.styleFrom(
                      primary: themeBase.color(context),
                      onPrimary: themeBase.color(context).isDark
                          ? Colors.white
                          : Colors.black,
                      shape: const StadiumBorder(),
                      minimumSize: const Size(40, 40),
                    ),
                  ),
                  child: ElevatedButton.icon(
                    onPressed: () async {
                      await storageRepository.setThemeMode(themeBase);
                      await context.refresh(themeBaseProvider);
                    },
                    label: Text(themeBase.title),
                    icon: SmoothAnimatedCrossFade(
                      duration: kThemeChangeDuration,
                      condition: themeBase == currentThemeMode,
                      trueChild: const Icon(FluentIcons.checkmark_24_regular),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildThemeColorButtons(
      BuildContext context, StorageRepository storageRepository) {
    final Color themeColor =
        useProvider(themeColorProvider).data?.value ?? AppTheme.defaultColor;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: Colors.primaries
              .map(
                (MaterialColor materialColor) => <int>[300, 400, 500, 600]
                    .map((int shade) => materialColor[shade])
                    .firstWhere(
                      (Color color) => color.isDark,
                      orElse: () => materialColor[700],
                    ),
              )
              .map(
                (Color color) => ElevatedButtonTheme(
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
                      await storageRepository.setThemeColor(color);
                      await context.refresh(themeColorProvider);
                    },
                    child: SmoothAnimatedSwitcher(
                      duration: kThemeChangeDuration,
                      condition: color == themeColor,
                      child: const Icon(FluentIcons.checkmark_24_regular),
                    ),
                  ),
                ),
              )
              .toList(growable: false),
        ),
      ),
    );
  }
}
