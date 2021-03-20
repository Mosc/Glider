import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:glider/models/item.dart';
import 'package:glider/models/item_type.dart';
import 'package:glider/providers/item_provider.dart';
import 'package:glider/providers/persistence_provider.dart';
import 'package:glider/providers/repository_provider.dart';
import 'package:glider/repositories/auth_repository.dart';
import 'package:glider/utils/date_time_extension.dart';
import 'package:glider/utils/formatting_util.dart';
import 'package:glider/utils/scaffold_messenger_state_extension.dart';
import 'package:glider/utils/validators.dart';
import 'package:glider/widgets/common/experimental.dart';
import 'package:glider/widgets/items/item_tile_data.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ReplyBody extends HookWidget {
  const ReplyBody({Key? key, required this.parent, this.root})
      : super(key: key);

  final Item parent;
  final Item? root;

  @override
  Widget build(BuildContext context) {
    final ValueNotifier<bool> loadingState = useState(false);
    final GlobalKey<FormState> formKey = useMemoized(() => GlobalKey());
    final ValueNotifier<bool> parentCollapsedState = useState(true);
    final TextEditingController commentController = useTextEditingController();
    final TextEditingValue commentListenable =
        useValueListenable(commentController);
    final String? username = useProvider(usernameProvider).data?.value;

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
                  TextFormField(
                    controller: commentController,
                    decoration: const InputDecoration(labelText: 'Comment'),
                    keyboardType: TextInputType.multiline,
                    textCapitalization: TextCapitalization.sentences,
                    autofocus: true,
                    maxLines: null,
                    validator: Validators.notEmpty,
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
                          child: const Text('Insert parent quote'),
                        ),
                        const SizedBox(width: 16),
                      ],
                      ElevatedButton(
                        onPressed: loadingState.value
                            ? null
                            : () async {
                                if (formKey.currentState?.validate() == true) {
                                  loadingState.value = true;
                                  await _reply(context,
                                      text: commentController.text);
                                  loadingState.value = false;
                                }
                              },
                        child: const Text('Reply'),
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
            parent.copyWith(kids: <int>[], ancestors: <int>[]),
            onTap: () =>
                parentCollapsedState.value = !parentCollapsedState.value,
            dense: parentCollapsedState.value,
            interactive: true,
          ),
          if (username != null)
            ItemTileData(
              _buildItem(
                id: useProvider(previewIdStateProvider).state,
                username: username,
                text: commentListenable.text,
              ),
            ),
          const SizedBox(height: 16),
        ],
      ),
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

  Future<void> _reply(BuildContext context, {required String text}) async {
    final AuthRepository authRepository = context.read(authRepositoryProvider);
    final bool success = await authRepository.reply(
      parentId: parent.id,
      text: text,
    );

    if (success) {
      final StateController<int> previewIdStateController =
          context.read(previewIdStateProvider);
      final int previewId = previewIdStateController.state;

      // Make comment preview available.
      context.read(itemCacheStateProvider(previewId)).state = _buildItem(
        id: previewId,
        username: await authRepository.username,
        text: text,
      );

      // Add comment preview to parent's list of children.
      context.read(itemCacheStateProvider(parent.id)).state =
          parent.incrementDescendants().addKid(previewId);

      // Increment root's number of descendants.
      if (root != null && parent != root) {
        context.read(itemCacheStateProvider(root!.id)).state =
            root!.incrementDescendants();
      }

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
    required int id,
    String? username,
    String? text,
  }) =>
      Item(
        id: id,
        type: ItemType.comment,
        by: username,
        time: DateTime.now().secondsSinceEpoch,
        text: text != null && text.isNotEmpty == true
            ? FormattingUtil.convertHackerNewsToHtml(text)
            : null,
        ancestors: <int>[parent.id],
      );
}
