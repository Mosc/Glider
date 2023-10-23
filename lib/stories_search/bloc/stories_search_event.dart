part of 'stories_search_bloc.dart';

sealed class StoriesSearchEvent with EquatableMixin {
  const StoriesSearchEvent();
}

final class LoadStoriesSearchEvent extends StoriesSearchEvent {
  const LoadStoriesSearchEvent();

  @override
  List<Object?> get props => [];
}

final class SetTextStoriesSearchEvent extends StoriesSearchEvent {
  const SetTextStoriesSearchEvent(this.text);

  final String? text;

  @override
  List<Object?> get props => [text];
}

final class SetSearchRangeStoriesSearchEvent extends StoriesSearchEvent {
  const SetSearchRangeStoriesSearchEvent(this.searchRange);

  final SearchRange? searchRange;

  @override
  List<Object?> get props => [searchRange];
}

final class SetDateRangeStoriesSearchEvent extends StoriesSearchEvent {
  const SetDateRangeStoriesSearchEvent(this.dateRange);

  final DateTimeRange? dateRange;

  @override
  List<Object?> get props => [dateRange];
}
