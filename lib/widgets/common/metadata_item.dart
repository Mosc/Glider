import 'package:flutter/material.dart';

class MetadataItem extends StatelessWidget {
  const MetadataItem({Key key, @required this.icon, this.text})
      : super(key: key);

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 1),
      child: Row(
        children: <Widget>[
          Icon(icon, size: textTheme.bodyText2.fontSize),
          if (text != null) ...<Widget>[
            const SizedBox(width: 4),
            Text(
              text,
              style:
                  textTheme.caption.copyWith(color: textTheme.bodyText2.color),
            ),
          ],
          const SizedBox(width: 8),
        ],
      ),
    );
  }
}
