import 'package:flutter/material.dart';

// This value happens to fit a page worth of items (30) with the standard height
// of an item in the stories overview (92). It does not appear to have a
// significant negative impact on initial load performance, while making
// scrolling noticably smoother on most affected pages compared to the default.
const _cacheExtent = 2760.0;

class RefreshableScrollView extends StatelessWidget {
  const RefreshableScrollView({
    super.key,
    this.scrollController,
    required this.slivers,
    required this.onRefresh,
    this.toolbarHeight,
    this.edgeOffset,
  });

  final ScrollController? scrollController;
  final List<Widget> slivers;
  final RefreshCallback onRefresh;
  final double? toolbarHeight;
  final double? edgeOffset;

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: onRefresh,
      displacement: toolbarHeight ?? kToolbarHeight,
      edgeOffset: edgeOffset ?? MediaQuery.paddingOf(context).top,
      child: CustomScrollView(
        controller: scrollController,
        physics: const AlwaysScrollableScrollPhysics(),
        cacheExtent: _cacheExtent,
        slivers: slivers,
      ),
    );
  }
}
