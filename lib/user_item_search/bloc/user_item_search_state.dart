part of 'user_item_search_bloc.dart';

class UserItemSearchState with DataMixin<List<int>>, EquatableMixin {
  const UserItemSearchState({
    this.status = Status.initial,
    this.data,
    this.searchText,
    this.exception,
  });

  factory UserItemSearchState.fromJson(Map<String, dynamic> json) =>
      UserItemSearchState(
        status: Status.values.byName(json['status'] as String),
        data: (json['data'] as List<dynamic>?)
                ?.map((e) => e as int)
                .toList(growable: false) ??
            const [],
        searchText: json['searchText'] as String?,
      );

  Map<String, dynamic> toJson() => <String, dynamic>{
        'status': status.name,
        'data': data,
        'searchText': searchText,
      };

  @override
  final Status status;
  @override
  final List<int>? data;
  final String? searchText;
  @override
  final Object? exception;

  UserItemSearchState copyWith({
    Status Function()? status,
    List<int>? Function()? data,
    String? Function()? searchText,
    Object? Function()? exception,
  }) =>
      UserItemSearchState(
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
