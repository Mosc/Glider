import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:glider/models/item.dart';
import 'package:glider/models/item_type.dart';
import 'package:glider/pages/account_page.dart';
import 'package:glider/providers/auth_provider.dart';
import 'package:glider/providers/item_provider.dart';
import 'package:glider/providers/repository_provider.dart';
import 'package:glider/repositories/auth_repository.dart';
import 'package:glider/utils/formatting_util.dart';
import 'package:glider/widgets/items/item_tile_data.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ReplyBody extends HookWidget {
  const ReplyBody({Key key, this.replyToItem}) : super(key: key);

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

    return ListView(children: <Widget>[
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
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  if (replyToItem.text != null) ...<Widget>[
                    OutlineButton(
                      onPressed: () => _handleQuoteParent(commentController),
                      child: const Text('Insert parent quote'),
                    ),
                    const SizedBox(width: 16),
                  ],
                  RaisedButton(
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
            const SizedBox(height: 12),
            Text(
              'Note: this preview may not accurately depict what the comment '
              'will look like once it has been submitted.',
              style: Theme.of(context).textTheme.caption,
            ),
          ],
        ),
      ),
      ItemTileData(
        Item(
          by: useProvider(usernameProvider).maybeWhen(
            data: (String username) => username,
            orElse: () => null,
          ),
          time: DateTime.now().millisecondsSinceEpoch,
          text: commentTextState.value.isNotEmpty
              ? FormattingUtil.convertHackerNewsToHtml(commentTextState.value)
              : null,
          type: ItemType.comment,
        ),
      )
    ]);
  }

  void _handleQuoteParent(TextEditingController commentController) {
    final String quotedParent =
        FormattingUtil.convertHtmlToHackerNews(replyToItem.text)
            .replaceAllMapped(
      RegExp('^.*', multiLine: true),
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
        Navigator.of(context).pop();
        await context.refresh(itemProvider(replyToItem.id));
      } else {
        Scaffold.of(context).showSnackBar(
          const SnackBar(
            content: Text('Something went wrong'),
          ),
        );
      }
    } else {
      Scaffold.of(context).showSnackBar(
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
}
