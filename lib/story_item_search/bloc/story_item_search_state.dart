part of 'story_item_search_bloc.dart';

class StoryItemSearchState with DataMixin<List<int>>, EquatableMixin {
  const StoryItemSearchState({
    this.status = Status.initial,
    this.data,
    this.searchText,
    this.exception,
  });

  @override
  final Status status;
  @override
  final List<int>? data;
  final String? searchText;
  @override
  final Object? exception;

  StoryItemSearchState copyWith({
    Status Function()? status,
    List<int>? Function()? data,
    String? Function()? searchText,
    Object? Function()? exception,
  }) =>
      StoryItemSearchState(
        status: status != null ? status() : this.status,
        data: data != null ? data() : this.data,
        searchText: searchText != null ? searchText() : this.searchText,
        exception: exception != null ? exception() : this.exception,
      );

  @override
  List<Object?> get props => [
        status,
        data,
        searchText,
        exception,
      ];
}
