import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:glider/models/item.dart';
import 'package:glider/models/item_type.dart';
import 'package:glider/providers/item_provider.dart';
import 'package:glider/providers/persistence_provider.dart';
import 'package:glider/providers/repository_provider.dart';
import 'package:glider/repositories/auth_repository.dart';
import 'package:glider/utils/formatting_util.dart';
import 'package:glider/utils/scaffold_messenger_state_extension.dart';
import 'package:glider/utils/validators.dart';
import 'package:glider/widgets/common/experimental.dart';
import 'package:glider/widgets/items/item_tile_data.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class EditBody extends HookConsumerWidget {
  const EditBody({Key? key, required this.item}) : super(key: key);

  final Item item;

  static const int _maxTitleLength = 80;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ValueNotifier<bool> loadingState = useState(false);
    final GlobalKey<FormState> formKey = useMemoized(() => GlobalKey());
    final TextEditingController titleController = useTextEditingController();
    final TextEditingValue titleListenable =
        useValueListenable(titleController);
    final TextEditingController textController = useTextEditingController();
    final TextEditingValue textListenable = useValueListenable(textController);
    final String? username = ref.watch(usernameProvider).asData?.value;

    useMemoized(
      () {
        titleController.text = item.title ?? '';
        textController.text =
            FormattingUtil.convertHtmlToHackerNews(item.text ?? '');
      },
    );

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
                if (item.title != null) ...<Widget>[
                  TextFormField(
                    controller: titleController,
                    decoration: InputDecoration(
                      labelText: AppLocalizations.of(context)!.title,
                    ),
                    textCapitalization: TextCapitalization.words,
                    autofocus: true,
                    maxLines: null,
                    maxLength: _maxTitleLength,
                    validator: (String? value) =>
                        Validators.notEmpty(context, value) ??
                        Validators.maxLength(context, value, _maxTitleLength),
                    enabled: !loadingState.value,
                  ),
                  const SizedBox(height: 16),
                ],
                if (item.text != null) ...<Widget>[
                  TextFormField(
                    controller: textController,
                    decoration: InputDecoration(
                      labelText: item.type == ItemType.comment
                          ? AppLocalizations.of(context)!.comment
                          : AppLocalizations.of(context)!.text,
                    ),
                    keyboardType: TextInputType.multiline,
                    textCapitalization: TextCapitalization.sentences,
                    autofocus: true,
                    maxLines: null,
                    validator: (String? value) =>
                        Validators.notEmpty(context, value),
                    enabled: !loadingState.value,
                  ),
                  const SizedBox(height: 16),
                ],
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    ElevatedButton(
                      onPressed: loadingState.value
                          ? null
                          : () async {
                              if (formKey.currentState?.validate() ?? false) {
                                loadingState.value = true;
                                await _edit(
                                  context,
                                  ref,
                                  title: titleController.text,
                                  text: textController.text,
                                );
                                loadingState.value = false;
                              }
                            },
                      child: Text(AppLocalizations.of(context)!.edit),
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
            AppLocalizations.of(context)!.preview,
            style: Theme.of(context).textTheme.subtitle1,
          ),
        ),
        if (username != null)
          ItemTileData(
            _buildItem(
              item,
              title: titleListenable.text,
              text: textListenable.text,
            ),
          ),
        const SizedBox(height: 16),
      ],
    );
  }

  Future<void> _edit(BuildContext context, WidgetRef ref,
      {String? title, String? text}) async {
    final AuthRepository authRepository = ref.read(authRepositoryProvider);
    final bool success = await authRepository.edit(
      id: item.id,
      title: title != null && title.isNotEmpty ? title : null,
      text: text != null && text.isNotEmpty ? text : null,
    );

    if (success) {
      // Make comment preview available.
      ref.read(itemNotifierProvider(item.id).notifier).setData(
            _buildItem(
              item,
              title: title,
              text: text,
            ),
          );

      Navigator.of(context).pop(true);
    } else {
      ScaffoldMessenger.of(context).replaceSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context)!.genericError)),
      );
    }
  }

  Item _buildItem(Item item, {String? title, String? text}) => item.copyWith(
        title: title != null && title.isNotEmpty ? title : null,
        text: text != null && text.isNotEmpty
            ? FormattingUtil.convertHackerNewsToHtml(text)
            : null,
        preview: true,
      );
}
