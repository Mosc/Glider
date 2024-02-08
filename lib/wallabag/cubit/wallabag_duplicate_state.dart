part of 'wallabag_duplicate_cubit.dart';

class WallabagDuplicateState with EquatableMixin, DataMixin<bool> {
  WallabagDuplicateState({
    this.status = Status.initial,
    this.data,
    this.exception,
  });

  @override
  final bool? data;

  @override
  final Object? exception;

  @override
  final Status status;

  WallabagDuplicateState copyWith({
    bool? Function()? data,
    Status Function()? status,
    Object? Function()? exception,
  }) =>
      WallabagDuplicateState(
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
