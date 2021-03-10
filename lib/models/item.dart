import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:glider/models/item_type.dart';
import 'package:jiffy/jiffy.dart';

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
  static final RegExp _videoRegExp = RegExp(r'\s+\[video\]$');
  static final RegExp _pdfRegExp = RegExp(r'\s+\[pdf\]$');
  static final RegExp _yearRegExp = RegExp(r'\s+\((\d+)\)');

  String get taglessTitle => title
      ?.replaceAll(_videoRegExp, '')
      ?.replaceAll(_pdfRegExp, '')
      ?.replaceAll(_yearRegExp, '');

  String get urlHost => Uri.parse(url)?.host;

  String get timeAgo => Jiffy.unix(time).fromNow();

  String get thumbnailUrl =>
      localOnly ? null : 'https://drcs9k8uelb9s.cloudfront.net/$id.png';

  bool get localOnly => id != null && id < 0;

  bool get hasVideo => title != null ? _videoRegExp.hasMatch(title) : null;

  bool get hasPdf => title != null ? _pdfRegExp.hasMatch(title) : null;

  bool get hasOriginalYear =>
      title != null ? _yearRegExp.hasMatch(title) : null;

  String get originalYear =>
      title != null ? _yearRegExp.firstMatch(title)?.group(1) : null;

  Item addKid(int kidId) =>
      copyWith(kids: <int>[kidId, if (kids != null) ...kids]);

  Item incrementDescendants() =>
      copyWith(descendants: descendants != null ? descendants + 1 : null);
}
