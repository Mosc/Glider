import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:glider/common/extensions/bloc_base_extension.dart';
import 'package:glider/edit/models/text_input.dart';
import 'package:glider/edit/models/title_input.dart';
import 'package:glider_domain/glider_domain.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

part 'edit_state.dart';

class EditCubit extends HydratedCubit<EditState> {
  EditCubit(
    this._itemRepository,
    this._itemInteractionRepository, {
    required int id,
  })  : itemId = id,
        super(const EditState()) {
    _itemSubscription = _itemRepository.getItemStream(itemId).listen(
          (item) => safeEmit(
            state.copyWith(
              item: () => item,
              title: state.title == null && item.title != null
                  ? () => TitleInput.dirty(item.title!)
                  : null,
              text: state.text == null && item.text != null
                  ? () => TextInput.dirty(item.text!)
                  : null,
            ),
          ),
        );
  }

  final ItemRepository _itemRepository;
  final ItemInteractionRepository _itemInteractionRepository;
  final int itemId;

  late final StreamSubscription<Item> _itemSubscription;

  @override
  String get id => itemId.toString();

  void setTitle(String title) {
    final titleInput = TitleInput.dirty(title);
    safeEmit(
      state.copyWith(
        title: () => titleInput,
        isValid: () => Formz.validate(
          [titleInput, if (state.text case final text?) text],
        ),
      ),
    );
  }

  void setText(String text) {
    final textInput = TextInput.dirty(text);
    safeEmit(
      state.copyWith(
        text: () => textInput,
        isValid: () => Formz.validate(
          [if (state.title case final title?) title, textInput],
        ),
      ),
    );
  }

  void setPreview(bool preview) {
    safeEmit(
      state.copyWith(preview: () => preview),
    );
  }

  Future<void> edit() async {
    final success = await _itemInteractionRepository.edit(
      itemId,
      title: state.title?.value,
      text: state.text?.value,
    );
    safeEmit(
      success
          ? const EditState(success: true)
          : state.copyWith(success: () => false),
    );
  }

  @override
  EditState? fromJson(Map<String, dynamic> json) => EditState.fromJson(json);

  @override
  Map<String, dynamic>? toJson(EditState state) => state.toJson();

  @override
  Future<void> close() async {
    await _itemSubscription.cancel();
    return super.close();
  }
}
