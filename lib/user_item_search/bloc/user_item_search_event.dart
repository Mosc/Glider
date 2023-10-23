part of 'user_item_search_bloc.dart';

sealed class UserItemSearchEvent with EquatableMixin {
  const UserItemSearchEvent();
}

final class LoadUserItemSearchEvent extends UserItemSearchEvent {
  const LoadUserItemSearchEvent();

  @override
  List<Object?> get props => [];
}

final class SetTextUserItemSearchEvent extends UserItemSearchEvent {
  const SetTextUserItemSearchEvent(this.text);

  final String? text;

  @override
  List<Object?> get props => [text];
}
