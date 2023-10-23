import 'package:flutter/widgets.dart';
import 'package:glider/common/extensions/text_style_extension.dart';
import 'package:glider/common/widgets/loading_block.dart';

class LoadingTextBlock extends StatelessWidget {
  const LoadingTextBlock({
    super.key,
    this.width,
    this.style,
    this.hasLeading = true,
  });

  final double? width;
  final TextStyle? style;
  final bool hasLeading;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (hasLeading) SizedBox(height: style?.leading(context)),
        LoadingBlock(
          width: width,
          height: style?.scaledFontSize(context),
        ),
      ],
    );
  }
}
