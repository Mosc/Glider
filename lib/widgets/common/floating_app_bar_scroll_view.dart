import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class FloatingAppBarScrollView extends HookConsumerWidget {
  const FloatingAppBarScrollView({
    Key? key,
    this.controller,
    this.title,
    this.actions,
    this.bottom,
    required this.body,
  }) : super(key: key);

  final ScrollController? controller;
  final Widget? title;
  final List<Widget>? actions;
  final PreferredSizeWidget? bottom;
  final Widget body;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return NestedScrollView(
      controller: controller,
      headerSliverBuilder: (_, bool innerBoxIsScrolled) => <Widget>[
        SliverAppBar(
          leading: _buildFluentIconsLeading(context),
          title: title,
          actions: actions,
          bottom: bottom,
          forceElevated: innerBoxIsScrolled,
          floating: true,
        ),
      ],
      floatHeaderSlivers: true,
      body: body,
    );
  }

  static Widget? _buildFluentIconsLeading(BuildContext context) {
    final ModalRoute<dynamic>? parentRoute = ModalRoute.of(context);

    final bool canPop = parentRoute?.canPop ?? false;
    final bool useCloseButton =
        parentRoute is PageRoute<dynamic> && parentRoute.fullscreenDialog;

    if (canPop) {
      if (useCloseButton) {
        return IconButton(
          icon: const Icon(FluentIcons.dismiss_24_regular),
          tooltip: MaterialLocalizations.of(context).closeButtonTooltip,
          onPressed: () => Navigator.of(context).maybePop(),
        );
      } else {
        return IconButton(
          icon: const Icon(FluentIcons.arrow_left_24_regular),
          tooltip: MaterialLocalizations.of(context).backButtonTooltip,
          onPressed: () => Navigator.of(context).maybePop(),
        );
      }
    }

    return null;
  }
}
