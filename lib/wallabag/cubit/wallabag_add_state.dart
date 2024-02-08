part of 'wallabag_add_cubit.dart';

class WallabagAddState with EquatableMixin, DataMixin<int> {
  WallabagAddState({
    this.status = Status.initial,
    this.data,
    this.exception,
  });

  @override
  final int? data;

  @override
  final Object? exception;

  @override
  final Status status;

  WallabagAddState copyWith({
    int? Function()? data,
    Status Function()? status,
    Object? Function()? exception,
  }) =>
      WallabagAddState(
        data: (data != null) ? data() : this.data,
        status: (status != null) ? status() : this.status,
        exception: (exception != null) ? exception() : this.exception,
      );

  @override
  List<Object?> get props => [
        status,
        data,
        exception,
      ];
}
