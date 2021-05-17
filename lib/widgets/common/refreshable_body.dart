import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:glider/providers/repository_provider.dart';
import 'package:glider/widgets/common/end.dart';
import 'package:glider/widgets/common/error.dart';
import 'package:glider/widgets/common/offline.dart';
import 'package:glider/widgets/common/smooth_animated_switcher.dart';
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
  final Iterable<Widget> Function() loadingBuilder;
  final Iterable<Widget> Function(T) dataBuilder;

  @override
  Widget build(BuildContext context) {
    final Stream<ConnectivityResult> connectivityStream = useMemoized(
      () => context.read(connectivityProvider).onConnectivityChanged,
    );
    useEffect(
      () => connectivityStream
          .listen(
            (ConnectivityResult event) => context.refresh(connectedProvider),
          )
          .cancel,
      <Object?>[connectivityStream],
    );

    final EdgeInsets padding = MediaQuery.of(context).padding;
    return RefreshIndicator(
      onRefresh: onRefresh ?? () async => context.refresh(provider),
      child: CustomScrollView(
        slivers: useProvider(provider)
            .when(
              loading: () => <Widget>[
                _buildSliverOffline(),
                ...loadingBuilder(),
                _buildSliverEnd(padding),
              ],
              data: (T data) => <Widget>[
                _buildSliverOffline(),
                ...dataBuilder(data),
                _buildSliverEnd(padding),
              ],
              error: (_, __) => <Widget>[
                _buildSliverOffline(),
                const SliverFillRemaining(
                  child: Error(),
                ),
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

  Widget _buildSliverOffline() {
    return SliverToBoxAdapter(
      child: SmoothAnimatedSwitcher.vertical(
        condition: useProvider(connectedProvider).data?.value == false,
        child: const Offline(),
      ),
    );
  }
}
