part of 'stories_cubit.dart';

class StoriesState
    with DataMixin<List<int>>, PaginatedListMixin, EquatableMixin {
  StoriesState({
    this.status = Status.initial,
    this.data,
    this.page = 1,
    this.storyType = StoryType.topStories,
    this.exception,
  });

  factory StoriesState.fromJson(Map<String, dynamic> json) => StoriesState(
        status: Status.values.byName(json['status'] as String),
        data: (json['data'] as List<dynamic>?)
            ?.map((e) => e as int)
            .toList(growable: false),
        storyType: StoryType.values.byName(json['storyType'] as String),
      );

  Map<String, dynamic> toJson() => <String, dynamic>{
        'status': status.name,
        'data': data,
        'storyType': storyType.name,
      };

  @override
  final Status status;
  @override
  final List<int>? data;
  @override
  final int page;
  final StoryType storyType;
  @override
  final Object? exception;

  @override
  late List<int>? loadedData = super.loadedData?.toList(growable: false);

  @override
  late List<int>? currentPageData =
      super.currentPageData?.toList(growable: false);

  StoriesState copyWith({
    Status Function()? status,
    List<int>? Function()? data,
    int Function()? page,
    StoryType Function()? storyType,
    Object? Function()? exception,
  }) =>
      StoriesState(
        status: status != null ? status() : this.status,
        data: data != null ? data() : this.data,
        page: page != null ? page() : this.page,
        storyType: storyType != null ? storyType() : this.storyType,
        exception: exception != null ? exception() : this.exception,
      );

  @override
  List<Object?> get props => [
        status,
        data,
        page,
        storyType,
        exception,
      ];
}
