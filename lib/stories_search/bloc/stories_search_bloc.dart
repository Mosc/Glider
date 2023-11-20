import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:glider/common/extensions/bloc_base_extension.dart';
import 'package:glider/common/mixins/data_mixin.dart';
import 'package:glider/common/mixins/paginated_list_mixin.dart';
import 'package:glider/common/models/status.dart';
import 'package:glider/stories_search/models/search_range.dart';
import 'package:glider/stories_search/models/search_type.dart';
import 'package:glider_domain/glider_domain.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:rxdart/transformers.dart';

part 'stories_search_event.dart';
part 'stories_search_state.dart';

const _debounceDuration = Duration(milliseconds: 300);

EventTransformer<Event> debounce<Event>(Duration duration) =>
    (events, mapper) => events.debounceTime(duration).switchMap(mapper);

class StoriesSearchBloc
    extends HydratedBloc<StoriesSearchEvent, StoriesSearchState> {
  StoriesSearchBloc(this._itemRepository, {this.searchType = SearchType.search})
      : super(StoriesSearchState()) {
    on<LoadStoriesSearchEvent>(
      (event, emit) async => _load(),
      transformer: debounce(_debounceDuration),
    );
    on<SetTextStoriesSearchEvent>(
      (event, emit) async => _setText(event),
    );
    on<SetSearchRangeStoriesSearchEvent>(
      (event, emit) async => _setSearchRange(event),
    );
    on<SetDateRangeStoriesSearchEvent>(
      (event, emit) async => _setDateRange(event),
    );
  }

  final ItemRepository _itemRepository;
  final SearchType searchType;

  @override
  String get id => searchType.name;

  Future<void> _load() async {
    safeEmit(
      state.copyWith(
        status: () => Status.loading,
        page: () => 1,
        exception: () => null,
      ),
    );

    try {
      final dateRange =
          state.searchRange == SearchRange.custom && state.dateRange != null
              ? DateTimeRange(
                  start: state.dateRange!.start,
                  end: state.dateRange!.end.add(const Duration(days: 1)),
                )
              : state.searchRange?.dateRange();
      final items = await _itemRepository.searchStories(
        text: state.searchText,
        startDate: dateRange?.start,
        endDate: dateRange?.end,
      );
      safeEmit(
        state.copyWith(
          status: () => Status.success,
          data: () => items.map((item) => item.id).toList(growable: false),
          exception: () => null,
        ),
      );
    } on Object catch (exception) {
      safeEmit(
        state.copyWith(
          status: () => Status.failure,
          exception: () => exception,
        ),
      );
    }
  }

  Future<void> showMore() async {
    safeEmit(
      state.copyWith(page: () => state.page + 1),
    );
  }

  Future<void> _setText(SetTextStoriesSearchEvent event) async {
    safeEmit(
      state.copyWith(searchText: () => event.text),
    );
    add(const LoadStoriesSearchEvent());
  }

  Future<void> _setSearchRange(SetSearchRangeStoriesSearchEvent event) async {
    safeEmit(
      state.copyWith(
        searchRange: () => event.searchRange,
        dateRange: () => null,
      ),
    );

    if (state.searchRange != SearchRange.custom) {
      add(const LoadStoriesSearchEvent());
    }
  }

  Future<void> _setDateRange(SetDateRangeStoriesSearchEvent event) async {
    safeEmit(
      state.copyWith(dateRange: () => event.dateRange),
    );
    add(const LoadStoriesSearchEvent());
  }

  @override
  StoriesSearchState? fromJson(Map<String, dynamic> json) =>
      StoriesSearchState.fromJson(json);

  @override
  Map<String, dynamic>? toJson(StoriesSearchState state) =>
      state.status == Status.success ? state.toJson() : null;
}
