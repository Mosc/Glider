import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:glider/models/item.dart';
import 'package:glider/models/item_type.dart';
import 'package:glider/utils/text_style_extension.dart';
import 'package:glider/widgets/common/smooth_animated_cross_fade.dart';

class ItemTileTitle extends HookWidget {
  const ItemTileTitle(this.item, {Key? key, this.dense = false})
      : super(key: key);

  final Item item;
  final bool dense;

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: 'item_title_${item.id}',
      child: Material(
        type: MaterialType.transparency,
        child: SmoothAnimatedCrossFade(
          condition: dense,
          trueChild: _buildTitleText(context, dense: true),
          falseChild: _buildTitleText(context, dense: false),
        ),
      ),
    );
  }

  Widget _buildTitleText(BuildContext context, {required bool dense}) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Text.rich(
      TextSpan(
        children: <InlineSpan>[
          if (item.type == ItemType.job)
            ..._buildIconSpans(context, FluentIcons.briefcase_24_regular)
          else if (item.type == ItemType.poll)
            ..._buildIconSpans(context, FluentIcons.poll_24_regular),
          if (item.hasVideo)
            ..._buildIconSpans(context, FluentIcons.video_clip_24_regular),
          if (item.hasPdf)
            ..._buildIconSpans(context, FluentIcons.document_24_regular),
          TextSpan(
            text: item.taglessTitle,
            style: textTheme.subtitle1,
          ),
          if (item.url != null) ...<InlineSpan>[
            TextSpan(text: ' ', style: textTheme.subtitle1),
            TextSpan(
              text: '(${item.urlHost})',
              style: textTheme.caption?.copyWith(height: 1.6),
            ),
          ]
        ],
      ),
      key: ValueKey<bool>(dense),
      maxLines: dense ? 2 : null,
      overflow: dense ? TextOverflow.ellipsis : null,
    );
  }

  Iterable<InlineSpan> _buildIconSpans(BuildContext context, IconData icon) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return <InlineSpan>[
      WidgetSpan(
        alignment: PlaceholderAlignment.aboveBaseline,
        baseline: TextBaseline.ideographic,
        child: Icon(
          icon,
          size: textTheme.subtitle1?.scaledFontSize(context),
        ),
      ),
      TextSpan(text: ' ', style: textTheme.subtitle1),
    ];
  }
}
