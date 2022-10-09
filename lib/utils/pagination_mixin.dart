import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:glider/providers/persistence_provider.dart';
import 'package:glider/widgets/common/sliver_smooth_animated_list.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

mixin PaginationMixin {
  static const int initialPage = 1;
  static const int pageSize = 30;

  AutoDisposeStateProvider<int> get paginationStateProvider;

  Iterable<Widget> buildPaginationSlivers<T extends Object>(
    BuildContext context,
    WidgetRef ref, {
    required Iterable<T> items,
    required Widget Function(BuildContext, T, int) builder,
  }) {
    useMemoized(() => resetPagination(ref));

    final bool useInfiniteScroll =
        ref.watch(useInfiniteScrollProvider).value ?? true;
    final StateController<int> paginationStateController =
        ref.watch(paginationStateProvider.state);

    return <Widget>[
      SliverSmoothAnimatedList<T>(
        items: useInfiniteScroll
            ? items
            : items.toList(growable: false).sublist(
                  0,
                  min(paginationStateController.state * pageSize, items.length),
                ),
        builder: builder,
      ),
      if (!useInfiniteScroll &&
          paginationStateController.state * pageSize < items.length)
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          sliver: SliverToBoxAdapter(
            child: OutlinedButton(
              onPressed: () =>
                  paginationStateController.update((int state) => state + 1),
              child: Text(
                AppLocalizations.of(context)
                    .loadNextPage(paginationStateController.state + 1),
              ),
            ),
          ),
        ),
    ];
  }

  void resetPagination(WidgetRef ref) =>
      ref.read(paginationStateProvider.state).update((_) => initialPage);
}
