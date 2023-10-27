part of 'history_cubit.dart';

class HistoryState with DataMixin<Map<int, DateTime?>>, EquatableMixin {
  const HistoryState({
    this.status = Status.initial,
    this.data,
    this.exception,
  });

  factory HistoryState.fromJson(Map<String, dynamic> json) => HistoryState(
        status: Status.values.byName(json['status'] as String),
        data: (json['data'] as Map<int, dynamic>?)
            ?.map((k, v) => MapEntry(k, DateTime.parse(v as String))),
      );

  Map<String, dynamic> toJson() => <String, dynamic>{
        'status': status.name,
        'data':
            data?.map((key, value) => MapEntry(key, value?.toIso8601String())),
      };

  @override
  final Status status;
  @override
  final Map<int, DateTime?>? data;
  @override
  final Object? exception;

  HistoryState copyWith({
    Status Function()? status,
    Map<int, DateTime?>? Function()? data,
    Object? Function()? exception,
  }) =>
      HistoryState(
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
