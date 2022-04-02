import 'package:diffutil_dart/diffutil.dart';
import 'package:flutter/widgets.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

typedef DiffUtilWidgetBuilder<T> = Widget Function(BuildContext, T, int);
typedef AnimatedDiffUtilWidgetBuilder = Widget Function(
    BuildContext, Animation<double>, Widget);
typedef EqualityChecker<T> = bool Function(T, T);

class DiffUtilSliverList<T> extends StatefulHookConsumerWidget {
  const DiffUtilSliverList({
    Key? key,
    required this.items,
    required this.builder,
    required this.animationBuilder,
    required this.animationDuration,
    this.equalityChecker,
  }) : super(key: key);

  final List<T> items;
  final DiffUtilWidgetBuilder<T> builder;
  final AnimatedDiffUtilWidgetBuilder animationBuilder;
  final Duration animationDuration;
  final EqualityChecker<T>? equalityChecker;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _DiffUtilSliverListState<T>();
}

class _DiffUtilSliverListState<T> extends ConsumerState<DiffUtilSliverList<T>> {
  final GlobalKey<SliverAnimatedListState> listKey =
      GlobalKey<SliverAnimatedListState>();

  late List<T?> tempList;

  @override
  void didUpdateWidget(DiffUtilSliverList<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    final List<T> tempList = oldWidget.items;
    final List<T> newList = widget.items;
    this.tempList = List<T?>.of(tempList);
    calculateListDiff<T>(
      tempList,
      newList,
      detectMoves: false,
      equalityChecker: widget.equalityChecker,
    ).getUpdates().forEach(_onDiffUpdate);
  }

  @override
  Widget build(BuildContext context) {
    return SliverAnimatedList(
      key: listKey,
      itemBuilder:
          (BuildContext context, int index, Animation<double> animation) =>
              widget.animationBuilder(
        context,
        animation,
        widget.builder(context, widget.items[index], index),
      ),
      initialItemCount: widget.items.length,
    );
  }

  void _onDiffUpdate(DiffUpdate update) {
    update.when<void>(
      insert: _onInserted,
      remove: _onRemoved,
      change: _onChanged,
      move: _onMoved,
    );
  }

  void _onInserted(int position, int count) {
    for (int index = position; index < position + count; index++) {
      listKey.currentState!.insertItem(
        index,
        duration: widget.animationDuration,
      );
    }
    tempList.insertAll(position, List<T?>.filled(count, null));
  }

  void _onRemoved(int position, int count) {
    for (int index = position; index < position + count; index++) {
      final T oldItem = tempList[index] as T;
      listKey.currentState!.removeItem(
        position,
        (BuildContext context, Animation<double> animation) =>
            widget.animationBuilder(
          context,
          animation,
          widget.builder(context, oldItem, index),
        ),
        duration: widget.animationDuration,
      );
    }
    tempList.removeRange(position, position + count);
  }

  void _onChanged(int position, Object? payload) {
    listKey.currentState!.removeItem(
      position,
      (BuildContext context, Animation<double> animation) =>
          const SizedBox.shrink(),
      duration: Duration.zero,
    );
    _onInserted(position, 1);
  }

  void _onMoved(int from, int to) =>
      throw UnimplementedError('moves are currently not supported');
}
