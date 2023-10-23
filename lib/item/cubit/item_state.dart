part of 'item_cubit.dart';

class ItemState with DataMixin<Item>, EquatableMixin {
  const ItemState({
    this.status = Status.initial,
    this.data,
    this.visited = false,
    this.upvoted = false,
    this.favorited = false,
    this.flagged = false,
    this.blocked = false,
    this.cached = false,
    this.exception,
  });

  factory ItemState.fromJson(Map<String, dynamic> json) => ItemState(
        status: Status.values.byName(json['status'] as String),
        data: Item.fromJson(json['data'] as Map<String, dynamic>),
        visited: json['visited'] as bool? ?? false,
        upvoted: json['upvoted'] as bool? ?? false,
        favorited: json['favorited'] as bool? ?? false,
        flagged: json['flagged'] as bool? ?? false,
        blocked: json['blocked'] as bool? ?? false,
        cached: true,
      );

  Map<String, dynamic> toJson() => <String, dynamic>{
        'status': status.name,
        'data': data?.toJson(),
        'upvoted': upvoted,
        'favorited': favorited,
        'flagged': flagged,
        'blocked': blocked,
      };

  @override
  final Status status;
  @override
  final Item? data;
  final bool visited;
  final bool upvoted;
  final bool favorited;
  final bool flagged;
  final bool blocked;
  final bool cached;
  @override
  final Object? exception;

  ItemState copyWith({
    Status Function()? status,
    Item? Function()? data,
    bool Function()? visited,
    bool Function()? upvoted,
    bool Function()? favorited,
    bool Function()? flagged,
    bool Function()? blocked,
    bool Function()? cached,
    bool Function()? highlighted,
    Object? Function()? exception,
  }) =>
      ItemState(
        status: status != null ? status() : this.status,
        data: data != null ? data() : this.data,
        visited: visited != null ? visited() : this.visited,
        upvoted: upvoted != null ? upvoted() : this.upvoted,
        favorited: favorited != null ? favorited() : this.favorited,
        flagged: flagged != null ? flagged() : this.flagged,
        blocked: blocked != null ? blocked() : this.blocked,
        cached: cached != null ? cached() : this.cached,
        exception: exception != null ? exception() : this.exception,
      );

  @override
  List<Object?> get props => [
        status,
        data,
        visited,
        upvoted,
        favorited,
        flagged,
        blocked,
        cached,
        exception,
      ];
}
