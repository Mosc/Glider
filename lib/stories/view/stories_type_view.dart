import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:glider/common/constants/app_spacing.dart';
import 'package:glider/common/extensions/widget_list_extension.dart';
import 'package:glider/stories/cubit/stories_cubit.dart';
import 'package:glider/stories/models/story_type.dart';

class StoriesTypeView extends StatelessWidget {
  const StoriesTypeView(this._storiesCubit, {super.key});

  final StoriesCubit _storiesCubit;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StoriesCubit, StoriesState>(
      bloc: _storiesCubit,
      buildWhen: (previous, current) => previous.storyType != current.storyType,
      builder: (context, state) {
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
          child: Row(
            children: [
              for (final storyType in StoryType.values)
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
        );
      },
    );
  }
}
