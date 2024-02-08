part of 'wallabag_cubit.dart';

class WallabagState with EquatableMixin, DataMixin<WallabagApiService> {
  const WallabagState({
    this.status = Status.initial,
    this.data,
    this.authData,
    this.exception,
  });

  @override
  final WallabagApiService? data;
  final WallabagAuthData? authData;

  WallabagState copyWith({
    WallabagApiService? Function()? data,
    WallabagAuthData? Function()? authData,
    Status Function()? status,
    Object? Function()? exception,
  }) =>
      WallabagState(
        data: (data != null) ? data() : this.data,
        authData: (authData != null) ? authData() : this.authData,
        status: (status != null) ? status() : this.status,
        exception: (exception != null) ? exception() : this.exception,
      );

  @override
  final Object? exception;

  @override
  final Status status;

  @override
  List<Object?> get props => [
        data,
        authData,
        status,
        exception,
      ];
}
