part of 'story_similar_cubit.dart';

class StorySimilarState with DataMixin<List<int>>, EquatableMixin {
  const StorySimilarState({
    this.status = Status.initial,
    this.item,
    this.data,
    this.exception,
  });

  factory StorySimilarState.fromMap(Map<String, dynamic> json) =>
      StorySimilarState(
        status: Status.values.byName(json['status'] as String),
        item: json['item'] != null
            ? Item.fromMap(json['item'] as Map<String, dynamic>)
            : null,
        data: (json['data'] as List<dynamic>?)
            ?.map((e) => e as int)
            .toList(growable: false),
      );

  Map<String, dynamic> toMap() => <String, dynamic>{
        'status': status.name,
        'item': item?.toMap(),
        'data': data,
      };

  @override
  final Status status;
  final Item? item;
  @override
  final List<int>? data;
  @override
  final Object? exception;

  StorySimilarState copyWith({
    Status Function()? status,
    Item? Function()? item,
    List<int>? Function()? data,
    Object? Function()? exception,
  }) =>
      StorySimilarState(
        status: status != null ? status() : this.status,
        item: item != null ? item() : this.item,
        data: data != null ? data() : this.data,
        exception: exception != null ? exception() : this.exception,
      );

  @override
  List<Object?> get props => [
        status,
        item,
        data,
        exception,
      ];
}
