part of 'story_item_search_bloc.dart';

sealed class StoryItemSearchEvent with EquatableMixin {
  const StoryItemSearchEvent();
}

final class LoadStoryItemSearchEvent extends StoryItemSearchEvent {
  const LoadStoryItemSearchEvent();

  @override
  List<Object?> get props => [];
}

final class SetTextStoryItemSearchEvent extends StoryItemSearchEvent {
  const SetTextStoryItemSearchEvent(this.text);

  final String? text;

  @override
  List<Object?> get props => [text];
}
