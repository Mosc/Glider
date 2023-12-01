import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:glider/common/constants/app_spacing.dart';
import 'package:glider/common/extensions/widget_list_extension.dart';
import 'package:glider/settings/cubit/settings_cubit.dart';
import 'package:glider/stories/cubit/stories_cubit.dart';
import 'package:glider/stories/models/story_type.dart';

class StoriesTypeView extends StatelessWidget {
  const StoriesTypeView(
    this._storiesCubit,
    this._settingsCubit, {
    super.key,
  });

  final StoriesCubit _storiesCubit;
  final SettingsCubit _settingsCubit;

  @override
  Widget build(BuildContext context) {
    final directionality = Directionality.of(context);
    final padding = MediaQuery.paddingOf(context);

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: EdgeInsetsDirectional.only(
        top: AppSpacing.s,
        bottom: AppSpacing.s,
        start: AppSpacing.xl,
        end: AppSpacing.xl +
            switch (directionality) {
              TextDirection.ltr => padding.right,
              TextDirection.rtl => padding.left,
            },
      ),
      child: _StoriesTypeBody(
        _storiesCubit,
        _settingsCubit,
      ),
    );
  }
}

class _StoriesTypeBody extends StatelessWidget {
  const _StoriesTypeBody(
    this._storiesCubit,
    this._settingsCubit,
  );

  final StoriesCubit _storiesCubit;
  final SettingsCubit _settingsCubit;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StoriesCubit, StoriesState>(
      bloc: _storiesCubit,
      buildWhen: (previous, current) => previous.storyType != current.storyType,
      builder: (context, state) => BlocBuilder<SettingsCubit, SettingsState>(
        bloc: _settingsCubit,
        builder: (context, settingsState) => Row(
          children: [
            for (final storyType in StoryType.values)
              if (storyType != StoryType.jobStories || settingsState.showJobs)
                ChoiceChip(
                  showCheckmark: false,
                  avatar: Icon(
                    state.storyType == storyType
                        ? storyType.selectedIcon
                        : storyType.icon,
                    color: Theme.of(context).colorScheme.onBackground,
                  ),
                  label: Text(storyType.label(context)),
                  selected: state.storyType == storyType,
                  onSelected: (selected) =>
                      _storiesCubit.setStoryType(storyType),
                ),
          ].spaced(width: AppSpacing.m),
        ),
      ),
    );
  }
}
