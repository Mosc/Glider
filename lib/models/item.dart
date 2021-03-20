import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:glider/models/item_type.dart';
import 'package:jiffy/jiffy.dart';

part 'item.freezed.dart';
part 'item.g.dart';

@freezed
class Item with _$Item {
  factory Item({
    required int id,
    bool? deleted,
    ItemType? type,
    String? by,
    int? time,
    String? text,
    bool? dead,
    int? parent,
    int? poll,
    @Default(<int>[]) Iterable<int> kids,
    String? url,
    int? score,
    String? title,
    @Default(<int>[]) Iterable<int> parts,
    int? descendants,
    @Default(<int>[]) Iterable<int> ancestors,
  }) = _Item;

  factory Item.fromJson(Map<String, dynamic> json) => _$ItemFromJson(json);
}

extension ItemExtension on Item {
  static final RegExp _videoRegExp = RegExp(r'\s+\[video\]$');
  static final RegExp _pdfRegExp = RegExp(r'\s+\[pdf\]$');
  static final RegExp _yearRegExp = RegExp(r'\s+\((\d+)\)');

  String? get taglessTitle => title
      ?.replaceAll(_videoRegExp, '')
      .replaceAll(_pdfRegExp, '')
      .replaceAll(_yearRegExp, '');

  String? get urlHost {
    final String? url = this.url;
    return url != null ? Uri.parse(url).host : null;
  }

  String? get timeAgo => time != null ? Jiffy.unix(time!).fromNow() : null;

  String? get thumbnailUrl =>
      localOnly ? null : 'https://drcs9k8uelb9s.cloudfront.net/$id.png';

  bool get localOnly => id < 0;

  bool get hasVideo => title != null && _videoRegExp.hasMatch(title!);

  bool get hasPdf => title != null && _pdfRegExp.hasMatch(title!);

  bool get hasOriginalYear => title != null && _yearRegExp.hasMatch(title!);

  String? get originalYear =>
      title != null ? _yearRegExp.firstMatch(title!)?.group(1) : null;

  Item addKid(int kidId) => copyWith(kids: <int>[kidId, ...kids]);

  Item incrementDescendants() =>
      copyWith(descendants: descendants != null ? descendants! + 1 : null);
}
