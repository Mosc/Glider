import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
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
import 'package:validators/validators.dart' as validators;

class SubmitBody extends HookWidget {
  const SubmitBody({Key key}) : super(key: key);

  static const int _maxTitleLength = 80;

  @override
  Widget build(BuildContext context) {
    final GlobalKey<FormState> formKey = useMemoized(() => GlobalKey());
    final ValueNotifier<SubmitType> submitTypeState = useState(SubmitType.url);
    final TextEditingController titleController = useTextEditingController();
    final TextEditingValue titleListenable =
        useValueListenable(titleController);
    final TextEditingController urlController = useTextEditingController();
    final TextEditingValue urlListenable = useValueListenable(urlController);
    final TextEditingController textController = useTextEditingController();
    final TextEditingValue textListenable = useValueListenable(textController);

    String url() =>
        submitTypeState.value == SubmitType.url ? urlListenable.text : null;

    String text() =>
        submitTypeState.value == SubmitType.text ? textListenable.text : null;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
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
                    'Select the type of content to submit.',
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
                              onChanged: (_) =>
                                  submitTypeState.value = submitType,
                            ),
                            GestureDetector(
                              onTap: () => submitTypeState.value = submitType,
                              child: Text(submitType.title),
                            ),
                          ],
                        ),
                    ],
                  ),
                  TextFormField(
                    controller: titleController,
                    decoration: const InputDecoration(labelText: 'Title'),
                    keyboardType: TextInputType.text,
                    textCapitalization: TextCapitalization.words,
                    autofocus: true,
                    maxLines: null,
                    maxLength: _maxTitleLength,
                    maxLengthEnforced: false,
                    validator: (String value) =>
                        Validators.notEmpty(value) ??
                        Validators.maxLength(value, _maxTitleLength),
                  ),
                  if (submitTypeState.value == SubmitType.url)
                    TextFormField(
                      controller: urlController,
                      decoration: const InputDecoration(labelText: 'URL'),
                      keyboardType: TextInputType.url,
                      maxLines: null,
                      validator: (String value) =>
                          Validators.notEmpty(value) ?? Validators.url(value),
                    ),
                  if (submitTypeState.value == SubmitType.text)
                    TextFormField(
                      controller: textController,
                      decoration: const InputDecoration(labelText: 'Text'),
                      keyboardType: TextInputType.multiline,
                      textCapitalization: TextCapitalization.sentences,
                      maxLines: null,
                      validator: Validators.notEmpty,
                    ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      if (submitTypeState.value == SubmitType.url) ...<Widget>[
                        OutlinedButton(
                          onPressed: _isUrl(urlController.text)
                              ? () => _autofillTitle(context, titleController,
                                  url: urlController.text)
                              : null,
                          child: const Text('Autofill title'),
                        ),
                        const SizedBox(width: 16),
                      ],
                      ElevatedButton(
                        onPressed: () async {
                          if (formKey.currentState.validate()) {
                            await _submit(
                              context,
                              title: titleListenable.text,
                              url: url(),
                              text: text(),
                            );
                          }
                        },
                        child: const Text('Submit'),
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
              'Preview',
              style: Theme.of(context).textTheme.subtitle1,
            ),
          ),
          ItemTileData(
            _buildItem(
              id: useProvider(previewIdStateProvider).state,
              username: useProvider(usernameProvider).data?.value,
              title: titleListenable.text,
              url: url(),
              text: text(),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  bool _isUrl(String url) => validators.isURL(url, requireProtocol: true);

  Future<void> _autofillTitle(
      BuildContext context, TextEditingController titleController,
      {@required String url}) async {
    final WebRepository webRepository = context.read(webRepositoryProvider);

    try {
      final String title = await webRepository.extractTitle(url: url);
      titleController.text = title?.trim();
    } on Exception {
      ScaffoldMessenger.of(context).showSnackBarQuickly(
        const SnackBar(content: Text('Could not autofill title')),
      );
    }
  }

  Future<void> _submit(BuildContext context,
      {@required String title, String url, String text}) async {
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
        const SnackBar(content: Text('Something went wrong')),
      );
    }
  }

  Item _buildItem({
    @required int id,
    @required String username,
    String title,
    String url,
    String text,
  }) =>
      Item(
        id: id,
        type: ItemType.story,
        by: username,
        time: DateTime.now().secondsSinceEpoch,
        text: text?.isNotEmpty == true
            ? FormattingUtil.convertHackerNewsToHtml(text)
            : null,
        url: _isUrl(url) ? url : null,
        title: title?.isNotEmpty == true ? title : null,
        score: 1,
        descendants: 0,
      );
}
