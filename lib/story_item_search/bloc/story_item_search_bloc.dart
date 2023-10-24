import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:glider/common/extensions/bloc_base_extension.dart';
import 'package:glider/common/mixins/data_mixin.dart';
import 'package:glider/common/models/status.dart';
import 'package:glider_domain/glider_domain.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:rxdart/transformers.dart';

part 'story_item_search_event.dart';
part 'story_item_search_state.dart';

const _debounceDuration = Duration(milliseconds: 300);

EventTransformer<Event> debounce<Event>(Duration duration) =>
    (events, mapper) => events.debounceTime(duration).switchMap(mapper);

class StoryItemSearchBloc
    extends HydratedBloc<ItemSearchEvent, StoryItemSearchState> {
  StoryItemSearchBloc(this._itemRepository, {required int id})
      : itemId = id,
        super(const StoryItemSearchState()) {
    on<LoadStoryItemSearchEvent>(
      (event, emit) async => _load(),
      transformer: debounce(_debounceDuration),
    );
    on<SetTextStoryItemSearchEvent>(
      (event, emit) async => _setText(event),
    );
  }

  final ItemRepository _itemRepository;
  final int itemId;

  @override
  String get id => itemId.toString();

  Future<void> _load() async {
    safeEmit(
      state.copyWith(status: () => Status.loading),
    );

    try {
      final items = await _itemRepository.searchStoryItems(
        itemId,
        text: state.searchText,
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

  Future<void> _setText(SetTextStoryItemSearchEvent event) async {
    safeEmit(
      state.copyWith(searchText: () => event.text),
    );
    add(const LoadStoryItemSearchEvent());
  }

  @override
  StoryItemSearchState? fromJson(Map<String, dynamic> json) =>
      StoryItemSearchState.fromJson(json);

  @override
  Map<String, dynamic>? toJson(StoryItemSearchState state) =>
      state.status == Status.success ? state.toJson() : null;
}
