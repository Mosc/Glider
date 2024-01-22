part of 'user_cubit.dart';

sealed class UserCubitEvent {}

final class UserActionFailedEvent implements UserCubitEvent {
  const UserActionFailedEvent();
}
