import 'dart:async';

import 'package:flutter/material.dart';
import 'package:glider/widgets/common/end.dart';
import 'package:glider/widgets/common/error.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class RefreshableBody<T> extends HookConsumerWidget {
  const RefreshableBody({
    Key? key,
    required this.provider,
    this.onRefresh,
    required this.loadingBuilder,
    required this.dataBuilder,
  }) : super(key: key);

  final ProviderBase<AsyncValue<T>> provider;
  final Future<void> Function()? onRefresh;
  final Iterable<Widget> Function() loadingBuilder;
  final Iterable<Widget> Function(T) dataBuilder;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final EdgeInsets padding = MediaQuery.of(context).padding;
    return RefreshIndicator(
      onRefresh: onRefresh ?? () async => ref.refresh(provider),
      child: CustomScrollView(
        slivers: ref.watch(provider).when(
              data: (T data) => <Widget>[
                ...dataBuilder(data),
                _buildSliverEnd(padding),
              ],
              loading: () => <Widget>[
                ...loadingBuilder(),
                _buildSliverEnd(padding),
              ],
              error: (_, __) => <Widget>[
                const SliverFillRemaining(
                  child: Error(),
                ),
              ],
            ),
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
