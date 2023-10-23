part of 'edit_cubit.dart';

class EditState with EquatableMixin {
  const EditState({
    this.item,
    this.title,
    this.text,
    this.isValid = false,
    this.preview = true,
    this.success = false,
  });

  factory EditState.fromJson(Map<String, dynamic> json) => EditState(
        item: json['item'] != null
            ? Item.fromJson(json['item'] as Map<String, dynamic>)
            : null,
        title: json['title'] != null
            ? TitleInput.pure(json['title'] as String)
            : null,
        text: json['text'] != null
            ? TextInput.pure(json['text'] as String)
            : null,
        isValid: json['isValid'] as bool? ?? false,
      );

  Map<String, dynamic> toJson() => <String, dynamic>{
        'item': item,
        'title': title?.value,
        'text': text?.value,
        'isValid': isValid,
      };

  final Item? item;
  final TitleInput? title;
  final TextInput? text;
  final bool isValid;
  final bool preview;
  final bool success;

  EditState copyWith({
    Item Function()? item,
    TitleInput? Function()? title,
    TextInput? Function()? text,
    bool Function()? isValid,
    bool Function()? preview,
    bool Function()? success,
  }) =>
      EditState(
        item: item != null ? item() : this.item,
        title: title != null ? title() : this.title,
        text: text != null ? text() : this.text,
        isValid: isValid != null ? isValid() : this.isValid,
        preview: preview != null ? preview() : this.preview,
        success: success != null ? success() : this.success,
      );

  @override
  List<Object?> get props => [
        item,
        title,
        text,
        isValid,
        preview,
        success,
      ];
}
