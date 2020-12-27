import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:glider/models/item.dart';
import 'package:glider/models/item_type.dart';
import 'package:glider/pages/account_page.dart';
import 'package:glider/providers/item_provider.dart';
import 'package:glider/providers/persistence_provider.dart';
import 'package:glider/providers/repository_provider.dart';
import 'package:glider/repositories/auth_repository.dart';
import 'package:glider/utils/date_time_extension.dart';
import 'package:glider/utils/formatting_util.dart';
import 'package:glider/utils/scaffold_messenger_state_extension.dart';
import 'package:glider/widgets/items/item_tile_data.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final StateProvider<int> _previewIdStateProvider =
    StateProvider<int>((ProviderReference ref) => -1);

class ReplyBody extends HookWidget {
  const ReplyBody({Key key, @required this.replyToItem}) : super(key: key);

  final Item replyToItem;

  @override
  Widget build(BuildContext context) {
    final GlobalKey<FormState> formKey =
        useMemoized(() => GlobalKey<FormState>());

    final ValueNotifier<String> commentTextState = useState('');
    final TextEditingController commentController = useTextEditingController();
    useEffect(
      () {
        void onScrollForwardListener() =>
            commentTextState.value = commentController.text;
        commentController.addListener(onScrollForwardListener);
        return () => commentController.removeListener(onScrollForwardListener);
      },
      <Object>[commentController],
    );

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
                  TextFormField(
                    controller: commentController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Comment',
                    ),
                    validator: (String value) {
                      if (value.isEmpty) {
                        return 'Comment must not be empty';
                      }
                      return null;
                    },
                    maxLines: null,
                    keyboardType: TextInputType.multiline,
                    textCapitalization: TextCapitalization.sentences,
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      if (replyToItem.text != null) ...<Widget>[
                        OutlinedButton(
                          onPressed: () =>
                              _handleQuoteParent(commentController),
                          child: const Text('Insert parent quote'),
                        ),
                        const SizedBox(width: 16),
                      ],
                      ElevatedButton(
                        onPressed: () async {
                          if (formKey.currentState.validate()) {
                            await _handleReply(context,
                                text: commentController.text);
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Comment preview',
                  style: Theme.of(context).textTheme.subtitle1,
                ),
              ],
            ),
          ),
          ItemTileData(
            _buildItem(
              id: context.read(_previewIdStateProvider).state,
              username: useProvider(usernameProvider).maybeWhen(
                data: (String username) => username,
                orElse: () => null,
              ),
              text: commentTextState.value,
            ),
          )
        ],
      ),
    );
  }

  void _handleQuoteParent(TextEditingController commentController) {
    final String quotedParent =
        FormattingUtil.convertHtmlToHackerNews(replyToItem.text)
            .replaceAllMapped(
      RegExp('^.+', multiLine: true),
      (Match match) => '> ${match[0]}',
    );
    commentController.text = '$quotedParent\n\n${commentController.text}';
  }

  Future<void> _handleReply(BuildContext context,
      {@required String text}) async {
    final AuthRepository authRepository = context.read(authRepositoryProvider);

    if (await authRepository.loggedIn) {
      final bool success = await authRepository.reply(
        parentId: replyToItem.id,
        text: text,
      );

      if (success) {
        final StateController<int> previewIdstateController =
            context.read(_previewIdStateProvider);
        final int previewId = previewIdstateController.state;

        // Make comment preview available.
        context.read(itemCacheStateProvider(previewId)).state = _buildItem(
          id: previewId,
          username: await authRepository.username,
          text: text,
        );

        // Add comment preview to parent's list of children.
        context.read(itemCacheStateProvider(replyToItem.id)).state =
            replyToItem.copyWith(
          kids: <int>[
            previewId,
            if (replyToItem.kids != null) ...replyToItem.kids,
          ],
        );

        // Decrement preview ID to prevent duplicates.
        previewIdstateController.state--;

        Navigator.of(context).pop(true);
      } else {
        ScaffoldMessenger.of(context).showSnackBarQuickly(
          const SnackBar(content: Text('Something went wrong')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBarQuickly(
        SnackBar(
          content: const Text('Log in to reply'),
          action: SnackBarAction(
            label: 'Log in',
            onPressed: () => Navigator.of(context).push<void>(
              MaterialPageRoute<void>(
                builder: (_) => const AccountPage(),
              ),
            ),
          ),
        ),
      );
    }
  }

  Item _buildItem({int id, String username, String text}) => Item(
        id: id,
        type: ItemType.comment,
        by: username,
        time: DateTime.now().secondsSinceEpoch,
        text: text.isNotEmpty
            ? FormattingUtil.convertHackerNewsToHtml(text)
            : null,
      );
}
