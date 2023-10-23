import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:glider/common/extensions/bloc_base_extension.dart';
import 'package:glider/submit/models/text_input.dart';
import 'package:glider/submit/models/title_input.dart';
import 'package:glider/submit/models/url_input.dart';
import 'package:glider_domain/glider_domain.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

part 'submit_state.dart';

class SubmitCubit extends HydratedCubit<SubmitState> {
  SubmitCubit(
    this._itemInteractionRepository,
    this._genericRepository,
  ) : super(const SubmitState());

  final ItemInteractionRepository _itemInteractionRepository;
  final WebsiteRepository _genericRepository;

  void setTitle(String title) {
    final titleInput = TitleInput.dirty(title);
    safeEmit(
      state.copyWith(
        title: () => titleInput,
        isValid: () => Formz.validate([titleInput, state.url, state.text]),
      ),
    );
  }

  void setUrl(String url) {
    final urlInput = UrlInput.dirty(url, text: state.text.value);
    final textInput = TextInput.dirty(state.text.value, url: url);
    safeEmit(
      state.copyWith(
        url: () => urlInput,
        text: () => textInput,
        isValid: () => Formz.validate([state.title, urlInput, textInput]),
      ),
    );
  }

  void setText(String text) {
    final urlInput = UrlInput.dirty(state.url.value, text: text);
    final textInput = TextInput.dirty(text, url: state.url.value);
    safeEmit(
      state.copyWith(
        url: () => urlInput,
        text: () => textInput,
        isValid: () => Formz.validate([state.title, urlInput, textInput]),
      ),
    );
  }

  void setPreview(bool preview) {
    safeEmit(
      state.copyWith(preview: () => preview),
    );
  }

  Future<void> autofillTitle() async {
    final url = Uri.tryParse(state.url.value);

    if (url != null) {
      final title = await _genericRepository.getWebsiteTitle(url);

      if (title != null) {
        final titleInput = TitleInput.dirty(title.trim());
        safeEmit(
          state.copyWith(
            title: () => titleInput,
            isValid: () => Formz.validate([titleInput, state.url, state.text]),
          ),
        );
      }
    }
  }

  Future<void> submit() async {
    final success = await _itemInteractionRepository.submit(
      title: state.title.value,
      url: state.url.value,
      text: state.text.value,
    );
    safeEmit(
      success
          ? const SubmitState(success: true)
          : state.copyWith(success: () => false),
    );
  }

  @override
  SubmitState? fromJson(Map<String, dynamic> json) =>
      SubmitState.fromJson(json);

  @override
  Map<String, dynamic>? toJson(SubmitState state) => state.toJson();
}
