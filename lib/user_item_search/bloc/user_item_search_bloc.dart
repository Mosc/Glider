import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:glider/common/extensions/bloc_base_extension.dart';
import 'package:glider/common/mixins/data_mixin.dart';
import 'package:glider/common/models/status.dart';
import 'package:glider/common/transformers/debounce.dart';
import 'package:glider_domain/glider_domain.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

part 'user_item_search_event.dart';
part 'user_item_search_state.dart';

class UserItemSearchBloc
    extends Bloc<UserItemSearchEvent, UserItemSearchState> {
  UserItemSearchBloc(this._itemRepository, {required this.username})
      : super(const UserItemSearchState()) {
    on<LoadUserItemSearchEvent>(
      (event, emit) async => _load(),
      transformer: debounce(const Duration(milliseconds: 300)),
    );
    on<SetTextUserItemSearchEvent>(
      (event, emit) async => _setText(event),
    );
  }

  final ItemRepository _itemRepository;
  final String username;

  Future<void> _load() async {
    safeEmit(
      state.copyWith(status: () => Status.loading),
    );

    try {
      final items = await _itemRepository.searchUserItems(
        username,
        text: state.searchText,
      );
      safeEmit(
        state.copyWith(
          status: () => Status.success,
          data: () => items.map((item) => item.id).toList(growable: false),
          exception: () => null,
        ),
      );
    } on Object catch (exception) {
      safeEmit(
        state.copyWith(
          status: () => Status.failure,
          exception: () => exception,
        ),
      );
    }
  }

  Future<void> _setText(SetTextUserItemSearchEvent event) async {
    safeEmit(
      state.copyWith(searchText: () => event.text),
    );
    add(const LoadUserItemSearchEvent());
  }
}
