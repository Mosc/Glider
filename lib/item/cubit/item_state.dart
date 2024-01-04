part of 'item_cubit.dart';

class ItemState with DataMixin<Item>, EquatableMixin {
  const ItemState({
    this.status = Status.initial,
    this.data,
    this.parsedText,
    this.visited = false,
    this.vote,
    this.favorited = false,
    this.flagged = false,
    this.blocked = false,
    this.exception,
  });

  factory ItemState.fromMap(Map<String, dynamic> json) => ItemState(
        status: Status.values.byName(json['status'] as String),
        data: Item.fromMap(json['data'] as Map<String, dynamic>),
        visited: json['visited'] as bool? ?? false,
        vote: json['voted'] != null
            ? VoteType.values.byName(json['voted'] as String)
            : null,
        favorited: json['favorited'] as bool? ?? false,
        flagged: json['flagged'] as bool? ?? false,
        blocked: json['blocked'] as bool? ?? false,
      );

  Map<String, dynamic> toMap() => <String, dynamic>{
        'status': status.name,
        'data': data?.toMap(),
        'voted': vote?.name,
        'favorited': favorited,
        'flagged': flagged,
        'blocked': blocked,
      };

  @override
  final Status status;
  @override
  final Item? data;
  final ParsedData? parsedText;
  final bool visited;
  final VoteType? vote;
  final bool favorited;
  final bool flagged;
  final bool blocked;
  @override
  final Object? exception;

  ItemState copyWith({
    Status Function()? status,
    Item? Function()? data,
    ParsedData? Function()? parsedText,
    bool Function()? visited,
    VoteType? Function()? vote,
    bool Function()? favorited,
    bool Function()? flagged,
    bool Function()? blocked,
    bool Function()? highlighted,
    Object? Function()? exception,
  }) =>
      ItemState(
        status: status != null ? status() : this.status,
        data: data != null ? data() : this.data,
        parsedText: parsedText != null ? parsedText() : this.parsedText,
        visited: visited != null ? visited() : this.visited,
        vote: vote != null ? vote() : this.vote,
        favorited: favorited != null ? favorited() : this.favorited,
        flagged: flagged != null ? flagged() : this.flagged,
        blocked: blocked != null ? blocked() : this.blocked,
        exception: exception != null ? exception() : this.exception,
      );

  @override
  List<Object?> get props => [
        status,
        data,
        parsedText,
        visited,
        vote,
        favorited,
        flagged,
        blocked,
        exception,
      ];
}
