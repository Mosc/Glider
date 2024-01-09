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
    return BlocBuilder<StoriesCubit, StoriesState>(
      bloc: _storiesCubit,
      builder: (context, state) => BlocBuilder<SettingsCubit, SettingsState>(
        bloc: _settingsCubit,
        builder: (context, settingsState) => MenuAnchor(
          menuChildren: [
            for (final storyType in StoryType.values)
              if (storyType != StoryType.jobStories || settingsState.showJobs)
                MenuItemButton(
                  onPressed: () async => _storiesCubit.setStoryType(storyType),
                  child: Text(storyType.label(context)),
                ),
          ],
          builder: (context, controller, child) => FilterChip.elevated(
            avatar: Icon(state.storyType.icon),
            label: Row(
              children: [
                Expanded(
                  child: Text(state.storyType.label(context)),
                ),
                const Icon(Icons.arrow_drop_down),
              ].spaced(width: AppSpacing.m),
            ),
            labelPadding: const EdgeInsetsDirectional.only(start: AppSpacing.m),
            onSelected: (storyType) =>
                controller.isOpen ? controller.close() : controller.open(),
          ),
        ),
      ),
    );
  }
}
