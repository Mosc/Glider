import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:glider/models/item.dart';
import 'package:glider/models/item_type.dart';
import 'package:glider/providers/item_provider.dart';
import 'package:glider/providers/persistence_provider.dart';
import 'package:glider/providers/repository_provider.dart';
import 'package:glider/repositories/auth_repository.dart';
import 'package:glider/utils/date_time_extension.dart';
import 'package:glider/utils/formatting_util.dart';
import 'package:glider/utils/scaffold_messenger_state_extension.dart';
import 'package:glider/widgets/common/experimental.dart';
import 'package:glider/widgets/items/item_tile_data.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ReplyBody extends HookConsumerWidget {
  const ReplyBody({super.key, required this.parent, this.root});

  final Item parent;
  final Item? root;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ValueNotifier<bool> loadingState = useState(false);
    final GlobalKey<FormState> formKey = useMemoized(GlobalKey.new);
    final ValueNotifier<bool> parentCollapsedState = useState(true);
    final TextEditingController commentController = useTextEditingController();
    final TextEditingValue commentListenable =
        useValueListenable(commentController);
    final String? username = ref.watch(usernameProvider).value;

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
                TextFormField(
                  controller: commentController,
                  decoration: InputDecoration(
                    labelText: AppLocalizations.of(context).comment,
                  ),
                  keyboardType: TextInputType.multiline,
                  textCapitalization: TextCapitalization.sentences,
                  autofocus: true,
                  maxLines: null,
                  validator: FormBuilderValidators.required(),
                  enabled: !loadingState.value,
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    if (parent.text != null) ...<Widget>[
                      OutlinedButton(
                        onPressed: loadingState.value
                            ? null
                            : () => _quoteParent(commentController),
                        child: Text(
                          AppLocalizations.of(context).quoteParent,
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
                                await _reply(context, ref,
                                    text: commentController.text);
                                loadingState.value = false;
                              }
                            },
                      child: Text(AppLocalizations.of(context).reply),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        ListTile(
          title: Text(
            AppLocalizations.of(context).preview,
            style: Theme.of(context)
                .textTheme
                .titleSmall
                ?.copyWith(color: Theme.of(context).colorScheme.primary),
          ),
        ),
        ItemTileData(
          parent.copyWith(kids: <int>[], indentation: 0),
          root: parent,
          onTap: () => parentCollapsedState.value = !parentCollapsedState.value,
          dense: parentCollapsedState.value,
          interactive: true,
        ),
        if (username != null)
          ItemTileData(
            _buildItem(
              id: ref.watch(previewIdStateProvider),
              username: username,
              text: commentListenable.text,
            ),
          ),
        const SizedBox(height: 16),
      ],
    );
  }

  void _quoteParent(TextEditingController commentController) {
    final String quotedParent =
        FormattingUtil.convertHtmlToHackerNews(parent.text!).replaceAllMapped(
      RegExp('^.+', multiLine: true),
      (Match match) => '> ${match[0]}',
    );
    commentController.text = '$quotedParent\n\n${commentController.text}';
  }

  Future<void> _reply(BuildContext context, WidgetRef ref,
      {required String text}) async {
    final AuthRepository authRepository = ref.read(authRepositoryProvider);
    final bool success = await authRepository.reply(
      parentId: parent.id,
      text: text,
    );

    if (success) {
      final StateController<int> previewIdStateController =
          ref.read(previewIdStateProvider.state);
      final int previewId = previewIdStateController.state;

      // Make comment preview available.
      ref.read(itemNotifierProvider(previewId).notifier).setData(
            _buildItem(
              id: previewId,
              username: await authRepository.username,
              text: text,
            ),
          );

      // Add comment preview to parent's list of children.
      ref.read(itemNotifierProvider(parent.id).notifier).setData(
            parent.incrementDescendants().addKid(previewId),
          );

      // Increment root's number of descendants.
      if (root != null && parent != root) {
        ref.read(itemNotifierProvider(root!.id).notifier).setData(
              root!.incrementDescendants(),
            );
      }

      // Decrement preview ID to prevent duplicates.
      previewIdStateController.update((int state) => state - 1);

      Navigator.of(context).pop(true);
    } else {
      ScaffoldMessenger.of(context).replaceSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context).genericError)),
      );
    }
  }

  Item _buildItem({
    required int id,
    String? username,
    String? text,
  }) =>
      Item(
        id: id,
        type: ItemType.comment,
        by: username,
        time: DateTime.now().secondsSinceEpoch,
        text: text != null && text.isNotEmpty
            ? FormattingUtil.convertHackerNewsToHtml(text)
            : null,
        indentation: 1,
        preview: true,
      );
}
