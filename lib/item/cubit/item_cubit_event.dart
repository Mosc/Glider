part of 'item_cubit.dart';

sealed class ItemCubitEvent {}

final class ItemActionFailedEvent implements ItemCubitEvent {
  const ItemActionFailedEvent();
}
