import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:glider/common/extensions/bloc_base_extension.dart';
import 'package:glider/reply/models/text_input.dart';
import 'package:glider_domain/glider_domain.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

part 'reply_state.dart';

class ReplyCubit extends HydratedCubit<ReplyState> {
  ReplyCubit(
    this._itemRepository,
    this._itemInteractionRepository, {
    required int id,
  })  : itemId = id,
        super(const ReplyState()) {
    _itemSubscription = _itemRepository.getItemStream(itemId).listen(
          (item) => safeEmit(
            state.copyWith(parentItem: () => item),
          ),
        );
  }

  final ItemRepository _itemRepository;
  final ItemInteractionRepository _itemInteractionRepository;
  final int itemId;

  late final StreamSubscription<Item> _itemSubscription;

  @override
  String get id => itemId.toString();

  void setText(String text) {
    final textInput = TextInput.dirty(text);
    safeEmit(
      state.copyWith(
        text: () => textInput,
        isValid: () => Formz.validate([textInput]),
      ),
    );
  }

  void setPreview(bool preview) {
    safeEmit(
      state.copyWith(preview: () => preview),
    );
  }

  void quoteParent() {
    final quotedParent = state.parentItem!.text!
        .splitMapJoin('\n', onNonMatch: (m) => '> $m'.trimRight());
    final textInput = TextInput.dirty('$quotedParent\n\n${state.text.value}');
    safeEmit(
      state.copyWith(
        text: () => textInput,
        isValid: () => Formz.validate([textInput]),
      ),
    );
  }

  Future<void> reply() async {
    final success =
        await _itemInteractionRepository.reply(itemId, text: state.text.value);
    safeEmit(
      success
          ? const ReplyState(success: true)
          : state.copyWith(success: () => false),
    );
  }

  @override
  ReplyState? fromJson(Map<String, dynamic> json) => ReplyState.fromJson(json);

  @override
  Map<String, dynamic>? toJson(ReplyState state) => state.toJson();

  @override
  Future<void> close() async {
    await _itemSubscription.cancel();
    return super.close();
  }
}
