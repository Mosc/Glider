part of 'item_tree_cubit.dart';

class ItemTreeState with DataMixin<List<ItemDescendant>>, EquatableMixin {
  ItemTreeState({
    this.status = Status.initial,
    this.data,
    this.previousData,
    this.collapsedIds = const {},
    this.exception,
  });

  factory ItemTreeState.fromJson(Map<String, dynamic> json) => ItemTreeState(
        status: Status.values.byName(json['status'] as String),
        data: (json['data'] as List<dynamic>?)
            ?.map((e) => ItemDescendant.fromJson(e as Map<String, dynamic>))
            .toList(growable: false),
        previousData: (json['previousData'] as List<dynamic>?)
            ?.map((e) => ItemDescendant.fromJson(e as Map<String, dynamic>))
            .toList(growable: false),
        collapsedIds: (json['collapsedIds'] as List<dynamic>)
            .map((e) => e as int)
            .toSet(),
      );

  Map<String, dynamic> toJson() => <String, dynamic>{
        'status': status.name,
        'data': data?.map((e) => e.toJson()).toList(growable: false),
        'previousData':
            previousData?.map((e) => e.toJson()).toList(growable: false),
        'collapsedIds': collapsedIds.toList(growable: false),
      };

  @override
  final Status status;
  @override
  final List<ItemDescendant>? data;
  final List<ItemDescendant>? previousData;
  final Set<int> collapsedIds;
  @override
  final Object? exception;

  late final List<ItemDescendant>? viewableData = data
      ?.where((e) => !e.ancestorIds.any(collapsedIds.contains))
      .toList(growable: false);

  late int newDescendantsCount = data != null && previousData != null
      ? {...?data}.difference({...?previousData}).length
      : 0;

  ItemTreeState copyWith({
    Status Function()? status,
    List<ItemDescendant>? Function()? data,
    List<ItemDescendant>? Function()? previousData,
    Set<int> Function()? collapsedIds,
    Object? Function()? exception,
  }) =>
      ItemTreeState(
        status: status != null ? status() : this.status,
        data: data != null ? data() : this.data,
        previousData: previousData != null ? previousData() : this.previousData,
        collapsedIds: collapsedIds != null ? collapsedIds() : this.collapsedIds,
        exception: exception != null ? exception() : this.exception,
      );

  @override
  List<Object?> get props => [
        status,
        data,
        previousData,
        collapsedIds,
        exception,
      ];
}

extension ItemTreeStateExtension on ItemTreeState {
  List<ItemDescendant>? getDescendants(ItemDescendant descendant) => data
      ?.where((e) => e.ancestorIds.contains(descendant.id))
      .toList(growable: false);

  int? getPreviousRootChildIndex({required int index}) => viewableData?.indexed
      .take(index)
      .lastWhereOrNull((indexed) => indexed.$2.depth == 1)
      ?.$1;

  int? getNextRootChildIndex({required int index}) => viewableData?.indexed
      .skip(index + 1)
      .firstWhereOrNull((indexed) => indexed.$2.depth == 1)
      ?.$1;
}
