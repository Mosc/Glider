import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:glider/common/extensions/bloc_base_extension.dart';
import 'package:glider/common/mixins/data_mixin.dart';
import 'package:glider/common/mixins/paginated_list_mixin.dart';
import 'package:glider/common/models/status.dart';
import 'package:glider/stories/models/story_type.dart';
import 'package:glider_domain/glider_domain.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

part 'stories_state.dart';

class StoriesCubit extends HydratedCubit<StoriesState> {
  StoriesCubit(this._itemRepository) : super(const StoriesState());

  final ItemRepository _itemRepository;

  @override
  String id = StoryType.topStories.name;

  Future<void> load() async {
    safeEmit(
      state.copyWith(
        status: () => Status.loading,
        page: () => 1,
        exception: () => null,
      ),
    );

    try {
      final itemIds = await switch (state.storyType) {
        StoryType.topStories => _itemRepository.getTopStoryIds,
        StoryType.newStories => _itemRepository.getNewStoryIds,
        StoryType.bestStories => _itemRepository.getBestStoryIds,
        StoryType.askStories => _itemRepository.getAskStoryIds,
        StoryType.showStories => _itemRepository.getShowStoryIds,
        StoryType.jobStories => _itemRepository.getJobStoryIds,
      }();
      safeEmit(
        state.copyWith(data: () => itemIds),
      );
      await _loadCurrentPage();
      safeEmit(
        state.copyWith(status: () => Status.success),
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
      state.copyWith(
        status: () => Status.loading,
        page: () => state.page + 1,
        exception: () => null,
      ),
    );

    try {
      await _loadCurrentPage();
      safeEmit(
        state.copyWith(status: () => Status.success),
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

  Future<List<Item>> _loadCurrentPage() async {
    return Future.wait<Item>(
      [
        if (state.currentPageData case final ids?)
          for (final id in ids) _itemRepository.getItem(id),
      ],
    );
  }

  Future<void> setStoryType(StoryType storyType) async {
    id = storyType.name;
    safeEmit(
      state.copyWith(storyType: () => storyType),
    );
    await load();
  }

  @override
  StoriesState? fromJson(Map<String, dynamic> json) =>
      StoriesState.fromJson(json);

  @override
  Map<String, dynamic>? toJson(StoriesState state) =>
      state.status == Status.success ? state.toJson() : null;
}
