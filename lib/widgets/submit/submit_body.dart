import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:glider/l10n/app_localizations.dart';
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
import 'package:glider/utils/validators.dart';
import 'package:glider/widgets/common/experimental.dart';
import 'package:glider/widgets/items/item_tile_data.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class SubmitBody extends HookWidget {
  const SubmitBody({Key? key}) : super(key: key);

  static const int _maxTitleLength = 80;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations appLocalizations = AppLocalizations.of(context)!;

    final ValueNotifier<bool> loadingState = useState(false);
    final GlobalKey<FormState> formKey = useMemoized(() => GlobalKey());
    final ValueNotifier<SubmitType> submitTypeState = useState(SubmitType.link);
    final TextEditingController titleController = useTextEditingController();
    final TextEditingValue titleListenable =
        useValueListenable(titleController);
    final TextEditingController urlController = useTextEditingController();
    final TextEditingValue urlListenable = useValueListenable(urlController);
    final TextEditingController textController = useTextEditingController();
    final TextEditingValue textListenable = useValueListenable(textController);
    final String? username = useProvider(usernameProvider).data?.value;

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
                  appLocalizations.storyTypeDescription,
                  style: Theme.of(context).textTheme.caption,
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
                  decoration:
                      InputDecoration(labelText: appLocalizations.title),
                  keyboardType: TextInputType.text,
                  textCapitalization: TextCapitalization.words,
                  autofocus: true,
                  maxLines: null,
                  maxLength: _maxTitleLength,
                  maxLengthEnforcement: MaxLengthEnforcement.none,
                  validator: (String? value) =>
                      Validators.notEmpty(context, value) ??
                      Validators.maxLength(context, value, _maxTitleLength),
                  enabled: !loadingState.value,
                ),
                if (submitTypeState.value == SubmitType.link)
                  TextFormField(
                    controller: urlController,
                    decoration:
                        InputDecoration(labelText: appLocalizations.link),
                    keyboardType: TextInputType.url,
                    maxLines: null,
                    validator: (String? value) =>
                        Validators.notEmpty(context, value) ??
                        Validators.url(context, value),
                    enabled: !loadingState.value,
                  ),
                if (submitTypeState.value == SubmitType.text)
                  TextFormField(
                    controller: textController,
                    decoration:
                        InputDecoration(labelText: appLocalizations.text),
                    keyboardType: TextInputType.multiline,
                    textCapitalization: TextCapitalization.sentences,
                    maxLines: null,
                    validator: (String? value) =>
                        Validators.notEmpty(context, value),
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
                                      titleController,
                                      url: urlController.text,
                                    )
                                : null,
                        child: Text(appLocalizations.autofillTitle),
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
                                  title: titleListenable.text,
                                  url: link(),
                                  text: text(),
                                );
                                loadingState.value = false;
                              }
                            },
                      child: Text(appLocalizations.submit),
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
            appLocalizations.preview,
            style: Theme.of(context).textTheme.subtitle1,
          ),
        ),
        if (username != null)
          ItemTileData(
            _buildItem(
              context,
              id: useProvider(previewIdStateProvider).state,
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
      Validators.url(context, url) == null;

  Future<void> _autofillTitle(
      BuildContext context, TextEditingController titleController,
      {required String url}) async {
    final AppLocalizations appLocalizations = AppLocalizations.of(context)!;

    final WebRepository webRepository = context.read(webRepositoryProvider);

    try {
      final String? title = await webRepository.extractTitle(url: url);

      if (title != null) {
        titleController.text = title.trim();
      }
    } on Exception {
      ScaffoldMessenger.of(context).showSnackBarQuickly(
        SnackBar(content: Text(appLocalizations.autofillTitleError)),
      );
    }
  }

  Future<void> _submit(BuildContext context,
      {required String title, String? url, String? text}) async {
    final AppLocalizations appLocalizations = AppLocalizations.of(context)!;

    final AuthRepository authRepository = context.read(authRepositoryProvider);
    final bool success = await authRepository.submit(
      title: title,
      url: url,
      text: text,
    );

    if (success) {
      final StateController<int> previewIdStateController =
          context.read(previewIdStateProvider);

      // Decrement preview ID to prevent duplicates.
      previewIdStateController.state--;

      Navigator.of(context).pop(true);
    } else {
      ScaffoldMessenger.of(context).showSnackBarQuickly(
        SnackBar(content: Text(appLocalizations.genericError)),
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
      );
}
