import 'package:flutter/material.dart';
import 'package:glider/common/constants/app_spacing.dart';
import 'package:glider/common/models/status.dart';
import 'package:glider/common/widgets/empty_widget.dart';
import 'package:glider/common/widgets/failure_widget.dart';
import 'package:glider/common/widgets/loading_widget.dart';

Widget _sliverWrap({required Widget child}) => SliverFillRemaining(
      hasScrollBody: false,
      child: child,
    );

mixin DataMixin<T> {
  Status get status;

  T? get data;

  Object? get exception;
}

extension DataMixinExtension<T> on DataMixin<T> {
  Widget whenOrDefaultWidgets({
    Widget Function()? loading,
    required Widget Function() success,
    Widget Function()? failure,
    VoidCallback? onRetry,
  }) {
    return switch (status) {
      Status.initial ||
      Status.loading =>
        data != null ? success() : loading?.call() ?? const LoadingWidget(),
      Status.success => success(),
      Status.failure => data != null
          ? success()
          : failure?.call() ??
              FailureWidget(
                exception: exception,
                onRetry: onRetry,
                compact: true,
              ),
    };
  }

  Widget whenOrDefaultSlivers({
    Widget Function()? loading,
    required Widget Function() success,
    Widget Function()? failure,
    VoidCallback? onRetry,
  }) {
    return switch (status) {
      Status.initial || Status.loading => data != null
          ? success()
          : loading?.call() ?? _sliverWrap(child: const LoadingWidget()),
      Status.success => success(),
      Status.failure => data != null
          ? SliverMainAxisGroup(
              slivers: [
                if (onRetry != null)
                  SliverPadding(
                    padding: AppSpacing.defaultTilePadding,
                    sliver: SliverToBoxAdapter(
                      child: Card(
                        child: FailureWidget(
                          exception: exception,
                          onRetry: onRetry,
                          compact: true,
                          // compact: true,
                        ),
                      ),
                    ),
                  ),
                success(),
              ],
            )
          : failure?.call() ??
              _sliverWrap(
                child: FailureWidget(
                  exception: exception,
                  onRetry: onRetry,
                ),
              ),
    };
  }
}

extension ListDataMixinExtension<T> on DataMixin<List<T>> {
  Widget whenOrDefaultSlivers({
    Widget Function()? loading,
    Widget Function()? empty,
    required Widget Function() nonEmpty,
    Widget Function()? failure,
    VoidCallback? onRetry,
  }) {
    return DataMixinExtension(this).whenOrDefaultSlivers(
      loading: loading,
      success: () => switch (data) {
        final data when data == null || data.isEmpty =>
          empty?.call() ?? _sliverWrap(child: const EmptyWidget()),
        _ => nonEmpty(),
      },
      failure: failure,
      onRetry: onRetry,
    );
  }
}
