import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:glider/models/item_type.dart';
import 'package:timeago/timeago.dart' as timeago;

part 'item.freezed.dart';
part 'item.g.dart';

@freezed
abstract class Item with _$Item {
  factory Item({
    int id,
    bool deleted,
    ItemType type,
    String by,
    int time,
    String text,
    bool dead,
    int parent,
    int poll,
    Iterable<int> kids,
    String url,
    int score,
    String title,
    Iterable<int> parts,
    int descendants,
    Iterable<int> ancestors,
  }) = _Item;

  factory Item.fromJson(Map<String, dynamic> json) => _$ItemFromJson(json);
}

extension ItemExtension on Item {
  String get urlHost => Uri.parse(url)?.host;

  String get timeAgo =>
      timeago.format(DateTime.fromMillisecondsSinceEpoch(time * 1000));

  String get thumbnailUrl =>
      localOnly ? null : 'https://drcs9k8uelb9s.cloudfront.net/$id.png';

  bool get localOnly => id != null && id < 0;

  Item addKid(int kidId) =>
      copyWith(kids: <int>[kidId, if (kids != null) ...kids]);

  Item incrementDescendants() =>
      copyWith(descendants: descendants != null ? descendants + 1 : null);
}
