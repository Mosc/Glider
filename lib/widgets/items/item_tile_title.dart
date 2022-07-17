import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:glider/models/item.dart';
import 'package:glider/models/item_type.dart';
import 'package:glider/providers/persistence_provider.dart';
import 'package:glider/utils/text_style_extension.dart';
import 'package:glider/widgets/common/fade_hero.dart';
import 'package:glider/widgets/common/smooth_animated_size.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ItemTileTitle extends HookConsumerWidget {
  const ItemTileTitle(
    this.item, {
    super.key,
    this.dense = false,
    this.interactive = false,
  });

  final Item item;
  final bool dense;
  final bool interactive;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FadeHero(
      tag: 'item_${item.id}_title',
      child: SmoothAnimatedSize(
        child: _buildTitleText(context, ref, dense: dense),
      ),
    );
  }

  Widget _buildTitleText(BuildContext context, WidgetRef ref,
      {required bool dense}) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final bool showDomain = ref.watch(showDomainProvider).value ?? false;

    return Text.rich(
      TextSpan(
        children: <InlineSpan>[
          if (item.type == ItemType.job)
            ..._buildIconSpans(context, FluentIcons.briefcase_24_regular)
          else if (item.type == ItemType.poll)
            ..._buildIconSpans(context, FluentIcons.poll_24_regular),
          if (item.hasVideo)
            ..._buildIconSpans(context, FluentIcons.video_clip_24_regular),
          if (item.hasAudio)
            ..._buildIconSpans(context, FluentIcons.headphones_24_regular),
          if (item.hasPdf)
            ..._buildIconSpans(context, FluentIcons.document_24_regular),
          TextSpan(
            text: item.formattedTitle,
            style: textTheme.titleMedium,
          ),
          if (item.urlHost != null && showDomain) ...<InlineSpan>[
            TextSpan(
              text: '​ ',
              style: textTheme.titleMedium,
            ),
            TextSpan(
              text: '(${item.urlHost})',
              style: textTheme.bodySmall,
            ),
            // Attach zero-width space of title style to enforce height.
            TextSpan(
              text: '​\u200b',
              style: textTheme.titleMedium,
            ),
          ],
        ],
      ),
      key: ValueKey<String>('item_${item.id}_dense_$dense'),
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
          size: textTheme.titleMedium?.scaledFontSize(context),
        ),
      ),
      TextSpan(text: ' ', style: textTheme.titleMedium),
    ];
  }
}
