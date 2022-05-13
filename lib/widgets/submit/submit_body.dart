import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:glider/models/item.dart';
import 'package:glider/models/item_type.dart';
import 'package:glider/models/submit_type.dart';
import 'package:glider/providers/item_provider.dart';
import 'package:glider/providers/persistence_provider.dart';
import 'package:glider/providers/repository_provider.dart';
import 'package:glider/repositories/auth_repository.dart';
import 'package:glider/repositories/web_repository.dart';
import 'package:glider/utils/date_time_extension.dart';
import 'package:glider/utils/formatting_util.dart';
import 'package:glider/utils/scaffold_messenger_state_extension.dart';
import 'package:glider/widgets/common/experimental.dart';
import 'package:glider/widgets/items/item_tile_data.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class SubmitBody extends HookConsumerWidget {
  const SubmitBody({super.key});

  static const int _titleMaxLength = 80;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ValueNotifier<bool> loadingState = useState(false);
    final GlobalKey<FormState> formKey = useMemoized(GlobalKey.new);
    final ValueNotifier<SubmitType> submitTypeState = useState(SubmitType.link);
    final TextEditingController titleController = useTextEditingController();
    final TextEditingValue titleListenable =
        useValueListenable(titleController);
    final TextEditingController urlController = useTextEditingController();
    final TextEditingValue urlListenable = useValueListenable(urlController);
    final TextEditingController textController = useTextEditingController();
    final TextEditingValue textListenable = useValueListenable(textController);
    final String? username = ref.watch(usernameProvider).value;

    String? link() =>
        submitTypeState.value == SubmitType.link ? urlListenable.text : null;

    String? text() =>
        submitTypeState.value == SubmitType.text ? textListenable.text : null;

    return ListView(
      padding: MediaQuery.of(context).padding.copyWith(top: 0),
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const Experimental(),
                const SizedBox(height: 16),
                Text(
                  AppLocalizations.of(context).storyTypeDescription,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                Wrap(
                  children: <Widget>[
                    for (SubmitType submitType in SubmitType.values)
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Radio<SubmitType>(
                            value: submitType,
                            groupValue: submitTypeState.value,
                            onChanged: loadingState.value
                                ? null
                                : (_) => submitTypeState.value = submitType,
                          ),
                          GestureDetector(
                            onTap: loadingState.value
                                ? null
                                : () => submitTypeState.value = submitType,
                            child: Text(submitType.title(context)),
                          ),
                        ],
                      ),
                  ],
                ),
                TextFormField(
                  controller: titleController,
                  decoration: InputDecoration(
                    labelText: AppLocalizations.of(context).title,
                  ),
                  keyboardType: TextInputType.text,
                  textCapitalization: TextCapitalization.words,
                  autofocus: true,
                  maxLength: _titleMaxLength,
                  maxLengthEnforcement: MaxLengthEnforcement.none,
                  validator: FormBuilderValidators.compose(
                    <FormFieldValidator<String>>[
                      FormBuilderValidators.required(),
                      FormBuilderValidators.maxLength(_titleMaxLength),
                    ],
                  ),
                  enabled: !loadingState.value,
                ),
                if (submitTypeState.value == SubmitType.link)
                  TextFormField(
                    controller: urlController,
                    decoration: InputDecoration(
                      labelText: AppLocalizations.of(context).link,
                    ),
                    keyboardType: TextInputType.url,
                    validator: FormBuilderValidators.compose(
                      <FormFieldValidator<String>>[
                        FormBuilderValidators.required(),
                        FormBuilderValidators.url(),
                      ],
                    ),
                    enabled: !loadingState.value,
                  ),
                if (submitTypeState.value == SubmitType.text)
                  TextFormField(
                    controller: textController,
                    decoration: InputDecoration(
                      labelText: AppLocalizations.of(context).text,
                    ),
                    keyboardType: TextInputType.multiline,
                    textCapitalization: TextCapitalization.sentences,
                    maxLines: null,
                    validator: FormBuilderValidators.required(),
                    enabled: !loadingState.value,
                  ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    if (submitTypeState.value == SubmitType.link) ...<Widget>[
                      OutlinedButton(
                        onPressed: loadingState.value
                            ? null
                            : _isUrl(context, urlController.text)
                                ? () => _autofillTitle(
                                      context,
                                      ref,
                                      titleController,
                                      url: urlController.text,
                                    )
                                : null,
                        child: Text(
                          AppLocalizations.of(context).autofillTitle,
                        ),
                      ),
                      const SizedBox(width: 16),
                    ],
                    ElevatedButton(
                      onPressed: loadingState.value
                          ? null
                          : () async {
                              if (formKey.currentState?.validate() ?? false) {
                                loadingState.value = true;
                                await _submit(
                                  context,
                                  ref,
                                  title: titleListenable.text,
                                  url: link(),
                                  text: text(),
                                );
                                loadingState.value = false;
                              }
                            },
                      child: Text(AppLocalizations.of(context).submit),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            AppLocalizations.of(context).preview,
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
        if (username != null)
          ItemTileData(
            _buildItem(
              context,
              id: ref.watch(previewIdStateProvider),
              username: username,
              title: titleListenable.text,
              url: link(),
              text: text(),
            ),
          ),
        const SizedBox(height: 16),
      ],
    );
  }

  bool _isUrl(BuildContext context, String? url) =>
      FormBuilderValidators.compose(
        <FormFieldValidator<String>>[
          FormBuilderValidators.required(),
          FormBuilderValidators.url(),
        ],
      ).call(url) ==
      null;

  Future<void> _autofillTitle(BuildContext context, WidgetRef ref,
      TextEditingController titleController,
      {required String url}) async {
    final WebRepository webRepository = ref.read(webRepositoryProvider);

    try {
      final String? title = await webRepository.extractTitle(url: url);

      if (title != null) {
        titleController.text = title.trim();
      }
    } on Exception {
      ScaffoldMessenger.of(context).replaceSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context).autofillTitleError),
        ),
      );
    }
  }

  Future<void> _submit(BuildContext context, WidgetRef ref,
      {required String title, String? url, String? text}) async {
    final AuthRepository authRepository = ref.read(authRepositoryProvider);
    final bool success = await authRepository.submit(
      title: title,
      url: url,
      text: text,
    );

    if (success) {
      // Decrement preview ID to prevent duplicates.
      ref.read(previewIdStateProvider.state).update((int state) => state - 1);

      Navigator.of(context).pop(true);
    } else {
      ScaffoldMessenger.of(context).replaceSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context).genericError)),
      );
    }
  }

  Item _buildItem(
    BuildContext context, {
    required int id,
    required String username,
    String? title,
    String? url,
    String? text,
  }) =>
      Item(
        id: id,
        type: ItemType.story,
        by: username,
        time: DateTime.now().secondsSinceEpoch,
        text: text?.isNotEmpty ?? false
            ? FormattingUtil.convertHackerNewsToHtml(text!)
            : null,
        url: _isUrl(context, url) ? url : null,
        title: title?.isNotEmpty ?? false ? title : null,
        score: 1,
        descendants: 0,
        preview: true,
      );
}
