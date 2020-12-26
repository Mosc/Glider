import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:glider/widgets/common/end.dart';
import 'package:glider/widgets/common/error.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class RefreshableBody<T> extends HookWidget {
  const RefreshableBody({
    Key key,
    @required this.provider,
    this.onRefresh,
    @required this.loadingBuilder,
    @required this.dataBuilder,
  }) : super(key: key);

  final RootProvider<Object, AsyncValue<T>> provider;
  final Future<void> Function() onRefresh;
  final Widget Function() loadingBuilder;
  final Iterable<Widget> Function(T) dataBuilder;

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: onRefresh ?? () async => context.refresh(provider),
      child: CustomScrollView(
        slivers: <Widget>[
          ...useProvider(provider).when(
            loading: () => <Widget>[
              loadingBuilder(),
            ],
            error: (_, __) => <Widget>[
              const SliverFillRemaining(child: Error()),
            ],
            data: (T data) => <Widget>[
              ...dataBuilder(data),
              const SliverToBoxAdapter(child: End()),
            ],
          ),
        ],
      ),
    );
  }
}
