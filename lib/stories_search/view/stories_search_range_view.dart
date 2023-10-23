import 'package:clock/clock.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:glider/common/constants/app_spacing.dart';
import 'package:glider/common/extensions/widget_list_extension.dart';
import 'package:glider/stories_search/bloc/stories_search_bloc.dart';
import 'package:glider/stories_search/models/search_range.dart';

class StoriesSearchRangeView extends StatelessWidget {
  const StoriesSearchRangeView(this._storiesSearchBloc, {super.key});

  final StoriesSearchBloc _storiesSearchBloc;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<StoriesSearchBloc, StoriesSearchState>(
      bloc: _storiesSearchBloc,
      listener: (context, state) async {
        if (state.searchRange == SearchRange.custom &&
            state.dateRange == null) {
          final dateRange = await showDateRangePicker(
            context: context,
            firstDate: DateTime.fromMillisecondsSinceEpoch(0),
            lastDate: clock.now(),
          );
          _storiesSearchBloc.add(
            dateRange != null
                ? SetDateRangeStoriesSearchEvent(dateRange)
                : const SetSearchRangeStoriesSearchEvent(null),
          );
        }
      },
      buildWhen: (previous, current) =>
          previous.searchRange != current.searchRange ||
          previous.dateRange != current.dateRange,
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
              for (final searchRange in SearchRange.values)
                ChoiceChip(
                  label: Text(
                    searchRange.label(
                      context,
                      dateRange: state.dateRange,
                    ),
                  ),
                  selected: state.searchRange == searchRange,
                  onSelected: (selected) => _storiesSearchBloc.add(
                    SetSearchRangeStoriesSearchEvent(
                      selected ? searchRange : null,
                    ),
                  ),
                ),
            ].spaced(width: AppSpacing.m),
          ),
        );
      },
    );
  }
}
