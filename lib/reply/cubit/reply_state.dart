part of 'reply_cubit.dart';

class ReplyState with EquatableMixin {
  const ReplyState({
    this.parentItem,
    this.text = const TextInput.pure(''),
    this.isValid = false,
    this.preview = true,
    this.success = false,
  });

  factory ReplyState.fromJson(Map<String, dynamic> json) => ReplyState(
        parentItem: json['parentItem'] != null
            ? Item.fromJson(json['parentItem'] as Map<String, dynamic>)
            : null,
        text: TextInput.pure(json['text'] as String? ?? ''),
        isValid: json['isValid'] as bool? ?? false,
      );

  Map<String, dynamic> toJson() => <String, dynamic>{
        'parentItem': parentItem,
        'text': text.value,
        'isValid': isValid,
      };

  final Item? parentItem;
  final TextInput text;
  final bool isValid;
  final bool preview;
  final bool success;

  ReplyState copyWith({
    Item Function()? parentItem,
    TextInput Function()? text,
    bool Function()? isValid,
    bool Function()? preview,
    bool Function()? success,
  }) =>
      ReplyState(
        parentItem: parentItem != null ? parentItem() : this.parentItem,
        text: text != null ? text() : this.text,
        isValid: isValid != null ? isValid() : this.isValid,
        preview: preview != null ? preview() : this.preview,
        success: success != null ? success() : this.success,
      );

  @override
  List<Object?> get props => [
        parentItem,
        text,
        isValid,
        preview,
        success,
      ];
}
