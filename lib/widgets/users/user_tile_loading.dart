import 'package:flutter/material.dart';
import 'package:glider/widgets/common/loading.dart';
import 'package:glider/widgets/common/loading_block.dart';

class UserTileLoading extends StatelessWidget {
  const UserTileLoading({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Loading(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const SizedBox(height: 3),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                LoadingBlock(
                  width: 160,
                  height: textTheme.caption.fontSize,
                ),
                const Spacer(),
                LoadingBlock(
                  width: 80,
                  height: textTheme.caption.fontSize,
                ),
              ],
            ),
            const SizedBox(height: 13),
            for (int _ in List<int>(2)) ...<Widget>[
              const SizedBox(height: 2),
              LoadingBlock(height: textTheme.bodyText2.fontSize),
            ],
            const SizedBox(height: 2),
            LoadingBlock(
              width: 120,
              height: textTheme.bodyText2.fontSize,
            ),
          ],
        ),
      ),
    );
  }
}
