part of 'stories_search_bloc.dart';

class StoriesSearchState
    with DataMixin<List<int>>, PaginatedListMixin, EquatableMixin {
  StoriesSearchState({
    this.status = Status.initial,
    this.data,
    this.page = 1,
    this.searchText,
    this.searchRange,
    this.dateRange,
    this.exception,
  });

  factory StoriesSearchState.fromJson(Map<String, dynamic> json) =>
      StoriesSearchState(
        status: Status.values.byName(json['status'] as String),
        data: (json['data'] as List<dynamic>?)
                ?.map((e) => e as int)
                .toList(growable: false) ??
            const [],
        searchText: json['searchText'] as String?,
        searchRange: json['searchRange'] != null
            ? SearchRange.values.byName(json['searchRange'] as String)
            : null,
        dateRange:
            json['dateRangeStart'] != null && json['dateRangeEnd'] != null
                ? DateTimeRange(
                    start: DateTime.fromMillisecondsSinceEpoch(
                      json['dateRangeStart'] as int,
                    ),
                    end: DateTime.fromMillisecondsSinceEpoch(
                      json['dateRangeEnd'] as int,
                    ),
                  )
                : null,
      );

  Map<String, dynamic> toJson() => <String, dynamic>{
        'status': status.name,
        'data': data,
        'searchText': searchText,
        'searchRange': searchRange?.name,
        'dateRangeStart': dateRange?.start.millisecondsSinceEpoch,
        'dateRangeEnd': dateRange?.end.millisecondsSinceEpoch,
      };

  @override
  final Status status;
  @override
  final List<int>? data;
  @override
  final int page;
  final String? searchText;
  final SearchRange? searchRange;
  final DateTimeRange? dateRange;
  @override
  final Object? exception;

  @override
  late List<int>? loadedData = super.loadedData?.toList(growable: false);

  @override
  late List<int>? currentPageData =
      super.currentPageData?.toList(growable: false);

  StoriesSearchState copyWith({
    Status Function()? status,
    List<int>? Function()? data,
    int Function()? page,
    String? Function()? searchText,
    SearchRange? Function()? searchRange,
    DateTimeRange? Function()? dateRange,
    Object? Function()? exception,
  }) =>
      StoriesSearchState(
        status: status != null ? status() : this.status,
        data: data != null ? data() : this.data,
        page: page != null ? page() : this.page,
        searchText: searchText != null ? searchText() : this.searchText,
        searchRange: searchRange != null ? searchRange() : this.searchRange,
        dateRange: dateRange != null ? dateRange() : this.dateRange,
        exception: exception != null ? exception() : this.exception,
      );

  @override
  List<Object?> get props => [
        status,
        data,
        page,
        searchText,
        searchRange,
        dateRange,
        exception,
      ];
}
