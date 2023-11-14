import 'dart:async';
import 'dart:convert';
import 'dart:ui';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:glider/common/extensions/bloc_base_extension.dart';
import 'package:glider_domain/glider_domain.dart';
import 'package:material_color_utilities/scheme/variant.dart';
import 'package:pub_semver/pub_semver.dart';
import 'package:share_plus/share_plus.dart';

part 'settings_state.dart';

class SettingsCubit extends Cubit<SettingsState> {
  SettingsCubit(
    this._settingsRepository,
    this._packageRepository,
    this._itemInteractionRepository,
  ) : super(const SettingsState()) {
    unawaited(_load());
  }

  final SettingsRepository _settingsRepository;
  final PackageRepository _packageRepository;
  final ItemInteractionRepository _itemInteractionRepository;

  Future<void> _load() async {
    final themeMode = await _settingsRepository.getThemeMode();
    final useDynamicTheme = await _settingsRepository.getUseDynamicTheme();
    final themeColor = await _settingsRepository.getThemeColor();
    final themeVariant = await _settingsRepository.getThemeVariant();
    final usePureBackground = await _settingsRepository.getUsePureBackground();
    final font = await _settingsRepository.getFont();
    final useLargeStoryStyle =
        await _settingsRepository.getUseLargeStoryStyle();
    final showFavicons = await _settingsRepository.getShowFavicons();
    final showStoryMetadata = await _settingsRepository.getShowStoryMetadata();
    final showUserAvatars = await _settingsRepository.getShowUserAvatars();
    final useActionButtons = await _settingsRepository.getUseActionButtons();
    final useThreadNavigation =
        await _settingsRepository.getUseThreadNavigation();
    final enableDownvoting = await _settingsRepository.getEnableDownvoting();
    safeEmit(
      state.copyWith(
        themeMode: themeMode != null ? () => themeMode : null,
        useDynamicTheme: useDynamicTheme != null ? () => useDynamicTheme : null,
        themeColor: themeColor != null ? () => themeColor : null,
        themeVariant: themeVariant != null ? () => themeVariant : null,
        usePureBackground:
            usePureBackground != null ? () => usePureBackground : null,
        font: font != null ? () => font : null,
        useLargeStoryStyle:
            useLargeStoryStyle != null ? () => useLargeStoryStyle : null,
        showFavicons: showFavicons != null ? () => showFavicons : null,
        showStoryMetadata:
            showStoryMetadata != null ? () => showStoryMetadata : null,
        showUserAvatars: showUserAvatars != null ? () => showUserAvatars : null,
        useActionButtons:
            useActionButtons != null ? () => useActionButtons : null,
        useThreadNavigation:
            useThreadNavigation != null ? () => useThreadNavigation : null,
        enableDownvoting:
            enableDownvoting != null ? () => enableDownvoting : null,
        appVersion: _packageRepository.getVersion,
      ),
    );
  }

  Future<void> setUseLargeStoryStyle(bool value) async {
    await _settingsRepository.setUseLargeStoryStyle(value: value);
    final useLargeStoryStyle =
        await _settingsRepository.getUseLargeStoryStyle();

    if (useLargeStoryStyle != null) {
      safeEmit(
        state.copyWith(useLargeStoryStyle: () => useLargeStoryStyle),
      );
    }
  }

  Future<void> setShowFavicons(bool value) async {
    await _settingsRepository.setShowFavicons(value: value);
    final showFavicons = await _settingsRepository.getShowFavicons();

    if (showFavicons != null) {
      safeEmit(
        state.copyWith(showFavicons: () => showFavicons),
      );
    }
  }

  Future<void> setShowStoryMetadata(bool value) async {
    await _settingsRepository.setShowStoryMetadata(value: value);
    final showStoryMetadata = await _settingsRepository.getShowStoryMetadata();

    if (showStoryMetadata != null) {
      safeEmit(
        state.copyWith(showStoryMetadata: () => showStoryMetadata),
      );
    }
  }

  Future<void> setShowUserAvatars(bool value) async {
    await _settingsRepository.setShowUserAvatars(value: value);
    final showUserAvatars = await _settingsRepository.getShowUserAvatars();

    if (showUserAvatars != null) {
      safeEmit(
        state.copyWith(showUserAvatars: () => showUserAvatars),
      );
    }
  }

  Future<void> setUseActionButtons(bool value) async {
    await _settingsRepository.setUseActionButtons(value: value);
    final useActionButtons = await _settingsRepository.getUseActionButtons();

    if (useActionButtons != null) {
      safeEmit(
        state.copyWith(useActionButtons: () => useActionButtons),
      );
    }
  }

  Future<void> setThemeMode(ThemeMode value) async {
    await _settingsRepository.setThemeMode(value: value);
    final themeMode = await _settingsRepository.getThemeMode();

    if (themeMode != null) {
      safeEmit(
        state.copyWith(themeMode: () => themeMode),
      );
    }
  }

  Future<void> setUseDynamicTheme(bool value) async {
    await _settingsRepository.setUseDynamicTheme(value: value);
    final useDynamicTheme = await _settingsRepository.getUseDynamicTheme();

    if (useDynamicTheme != null) {
      safeEmit(
        state.copyWith(useDynamicTheme: () => useDynamicTheme),
      );
    }
  }

  Future<void> setThemeColor(Color value) async {
    await _settingsRepository.setThemeColor(value: value);
    final themeColor = await _settingsRepository.getThemeColor();

    if (themeColor != null) {
      safeEmit(
        state.copyWith(themeColor: () => themeColor),
      );
    }
  }

  Future<void> setThemeVariant(Variant value) async {
    await _settingsRepository.setThemeVariant(value: value);
    final themeVariant = await _settingsRepository.getThemeVariant();

    if (themeVariant != null) {
      safeEmit(
        state.copyWith(themeVariant: () => themeVariant),
      );
    }
  }

  Future<void> setUsePureBackground(bool value) async {
    await _settingsRepository.setUsePureBackground(value: value);
    final usePureBackground = await _settingsRepository.getUsePureBackground();

    if (usePureBackground != null) {
      safeEmit(
        state.copyWith(usePureBackground: () => usePureBackground),
      );
    }
  }

  Future<void> setFont(String value) async {
    await _settingsRepository.setFont(value: value);
    final font = await _settingsRepository.getFont();

    if (font != null) {
      safeEmit(
        state.copyWith(font: () => font),
      );
    }
  }

  Future<void> setShowJobs(bool value) async {
    await _settingsRepository.setShowJobs(value: value);
    final showJobs = await _settingsRepository.getShowJobs();

    if (showJobs != null) {
      safeEmit(
        state.copyWith(showJobs: () => showJobs),
      );
    }
  }

  Future<void> setUseThreadNavigation(bool value) async {
    await _settingsRepository.setUseThreadNavigation(value: value);
    final useThreadNavigation =
        await _settingsRepository.getUseThreadNavigation();

    if (useThreadNavigation != null) {
      safeEmit(
        state.copyWith(useThreadNavigation: () => useThreadNavigation),
      );
    }
  }

  Future<void> setEnableDownvoting(bool value) async {
    await _settingsRepository.setEnableDownvoting(value: value);
    final enableDownvoting = await _settingsRepository.getEnableDownvoting();

    if (enableDownvoting != null) {
      safeEmit(
        state.copyWith(enableDownvoting: () => enableDownvoting),
      );
    }
  }

  Future<void> exportFavorites() async {
    final favorites = await _itemInteractionRepository.favoritedStream.first;
    await Share.share(jsonEncode(favorites));
  }
}
