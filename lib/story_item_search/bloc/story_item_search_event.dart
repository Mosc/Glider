part of 'story_item_search_bloc.dart';

sealed class ItemSearchEvent with EquatableMixin {
  const ItemSearchEvent();
}

final class LoadStoryItemSearchEvent extends ItemSearchEvent {
  const LoadStoryItemSearchEvent();

  @override
  List<Object?> get props => [];
}

final class SetTextStoryItemSearchEvent extends ItemSearchEvent {
  const SetTextStoryItemSearchEvent(this.text);

  final String? text;

  @override
  List<Object?> get props => [text];
}
