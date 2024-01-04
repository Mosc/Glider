part of 'inbox_cubit.dart';

typedef IdWithParent = (int parentId, int id);

class InboxState with DataMixin<List<IdWithParent>>, EquatableMixin {
  const InboxState({
    this.status = Status.initial,
    this.data,
    this.exception,
  });

  factory InboxState.fromMap(Map<String, dynamic> json) => InboxState(
        status: Status.values.byName(json['status'] as String),
        data: (json['data'] as List<dynamic>?)
            ?.map((e) => e as Map<String, dynamic>)
            .map((e) => (e['parentId'] as int, e['id'] as int))
            .toList(growable: false),
      );

  Map<String, dynamic> toMap() => <String, dynamic>{
        'status': status.name,
        'data': data
            ?.map((e) => <String, dynamic>{'parentId': e.$1, 'id': e.$2})
            .toList(growable: false),
      };

  @override
  final Status status;
  @override
  final List<IdWithParent>? data;
  @override
  final Object? exception;

  InboxState copyWith({
    Status Function()? status,
    List<IdWithParent>? Function()? data,
    Object? Function()? exception,
  }) =>
      InboxState(
        status: status != null ? status() : this.status,
        data: data != null ? data() : this.data,
        exception: exception != null ? exception() : this.exception,
      );

  @override
  List<Object?> get props => [
        status,
        data,
        exception,
      ];
}
