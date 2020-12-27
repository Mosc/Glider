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

  @late
  String get urlHost => Uri.parse(url)?.host;

  @late
  String get timeAgo =>
      timeago.format(DateTime.fromMillisecondsSinceEpoch(time * 1000));

  @late
  String get thumbnailUrl => 'https://drcs9k8uelb9s.cloudfront.net/$id.png';

  @late
  bool get localOnly => id != null && id < 0;
}
