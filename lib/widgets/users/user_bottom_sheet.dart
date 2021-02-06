import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:glider/models/user.dart';
import 'package:glider/repositories/website_repository.dart';
import 'package:glider/utils/scaffold_messenger_state_extension.dart';
import 'package:share/share.dart';

class UserBottomSheet extends StatelessWidget {
  const UserBottomSheet(this.user, {Key key}) : super(key: key);

  final User user;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Wrap(
        children: <Widget>[
          if (user.about != null)
            ListTile(
              title: const Text('Copy text'),
              onTap: () async {
                await Clipboard.setData(ClipboardData(text: user.about));
                ScaffoldMessenger.of(context).showSnackBarQuickly(
                  const SnackBar(content: Text('Text has been copied')),
                );
                Navigator.of(context).pop();
              },
            ),
          ListTile(
            title: const Text('Share user link'),
            onTap: () async {
              await Share.share(
                Uri.https(
                  WebsiteRepository.authority,
                  'user',
                  <String, String>{'id': user.id},
                ).toString(),
              );
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }
}
