import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:glider/widgets/common/end.dart';
import 'package:glider/widgets/common/error.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class RefreshableBody<T> extends HookWidget {
  const RefreshableBody({
    Key? key,
    required this.provider,
    this.onRefresh,
    required this.loadingBuilder,
    required this.dataBuilder,
  }) : super(key: key);

  final RootProvider<Object, AsyncValue<T>> provider;
  final Future<void> Function()? onRefresh;
  final Widget Function() loadingBuilder;
  final Iterable<Widget> Function(T) dataBuilder;

  @override
  Widget build(BuildContext context) {
    final EdgeInsets padding = MediaQuery.of(context).padding;
    return RefreshIndicator(
      onRefresh: onRefresh ?? () async => context.refresh(provider),
      child: CustomScrollView(
        slivers: useProvider(provider)
            .when(
              loading: () => <Widget>[
                loadingBuilder(),
                _buildSliverEnd(padding),
              ],
              error: (_, __) => <Widget>[
                const SliverFillRemaining(
                  child: Error(),
                ),
              ],
              data: (T data) => <Widget>[
                ...dataBuilder(data),
                _buildSliverEnd(padding),
              ],
            )
            .map(
              (Widget sliver) => SliverPadding(
                padding: padding.copyWith(top: 0, bottom: 0),
                sliver: sliver,
              ),
            )
            .toList(growable: false),
      ),
    );
  }

  Widget _buildSliverEnd(EdgeInsets padding) {
    return SliverPadding(
      padding: padding.copyWith(top: 0),
      sliver: const SliverToBoxAdapter(
        child: End(),
      ),
    );
  }
}
