part of 'submit_cubit.dart';

class SubmitState with EquatableMixin {
  const SubmitState({
    this.title = const TitleInput.pure(''),
    this.url = const UrlInput.pure(''),
    this.text = const TextInput.pure(''),
    this.isValid = false,
    this.preview = true,
    this.success = false,
  });

  factory SubmitState.fromMap(Map<String, dynamic> json) => SubmitState(
        title: TitleInput.pure(json['title'] as String? ?? ''),
        url: UrlInput.pure(
          json['url'] as String? ?? '',
          text: json['text'] as String? ?? '',
        ),
        text: TextInput.pure(
          json['text'] as String? ?? '',
          url: json['url'] as String? ?? '',
        ),
        isValid: json['isValid'] as bool? ?? false,
      );

  Map<String, dynamic> toMap() => <String, dynamic>{
        'title': title.value,
        'url': url.value,
        'text': text.value,
        'isValid': isValid,
      };

  final TitleInput title;
  final UrlInput url;
  final TextInput text;
  final bool isValid;
  final bool preview;
  final bool success;

  SubmitState copyWith({
    TitleInput Function()? title,
    UrlInput Function()? url,
    TextInput Function()? text,
    bool Function()? isValid,
    bool Function()? preview,
    bool Function()? success,
  }) =>
      SubmitState(
        title: title != null ? title() : this.title,
        url: url != null ? url() : this.url,
        text: text != null ? text() : this.text,
        isValid: isValid != null ? isValid() : this.isValid,
        preview: preview != null ? preview() : this.preview,
        success: success != null ? success() : this.success,
      );

  @override
  List<Object?> get props => [
        title,
        url,
        text,
        isValid,
        preview,
        success,
      ];
}
