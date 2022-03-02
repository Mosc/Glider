import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:glider/models/item_type.dart';
import 'package:glider/utils/date_time_extension.dart';
import 'package:html_unescape/html_unescape_small.dart';
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
    @Default(0) int indentation,
    @Default(false) bool cache,
    @Default(false) bool preview,
  }) = _Item;

  Item._();

  factory Item.fromJson(Map<String, dynamic> json) => _$ItemFromJson(json);

  static final RegExp _videoRegExp = RegExp(r'\s+\[video\]');
  static final RegExp _audioRegExp = RegExp(r'\s+\[audio\]');
  static final RegExp _pdfRegExp = RegExp(r'\s+\[pdf\]');
  static final RegExp _yearRegExp = RegExp(r'\s+\((\d+)\)');

  late final String? formattedTitle = title != null
      ? HtmlUnescape()
          .convert(title!)
          .replaceAll(_videoRegExp, '')
          .replaceAll(_audioRegExp, '')
          .replaceAll(_pdfRegExp, '')
          .replaceAll(_yearRegExp, '')
      : null;

  late final String? urlHost = url != null ? Uri.parse(url!).host : null;

  late final DateTime? timeDate =
      time != null ? DateTimeExtension.fromSecondsSinceEpoch(time!) : null;

  late final String? timeAgo =
      timeDate != null ? Jiffy(timeDate).fromNow() : null;

  String? faviconUrl(int size) => urlHost != null
      ? Uri.https(
          'icons.viter.nl',
          'icon',
          <String, String>{
            'url': urlHost!,
            'size': '0..$size..500',
            'formats': 'gif,ico,jpg,png',
          },
        ).toString()
      : null;

  late final bool hasVideo = title != null && _videoRegExp.hasMatch(title!);

  late final bool hasAudio = title != null && _audioRegExp.hasMatch(title!);

  late final bool hasPdf = title != null && _pdfRegExp.hasMatch(title!);

  late final bool hasOriginalYear =
      title != null && _yearRegExp.hasMatch(title!);

  late final String? originalYear =
      title != null ? _yearRegExp.firstMatch(title!)?.group(1) : null;

  late final bool active = deleted != true && preview != true;

  late final bool votable = active && type != ItemType.job;

  late final bool replyable =
      active && type != ItemType.job && type != ItemType.pollopt;

  late final bool favoritable =
      active && type != ItemType.job && type != ItemType.pollopt;

  late final bool flaggable =
      active && type != ItemType.job && type != ItemType.pollopt;

  bool get editable {
    final num? timeAgoHours = _timeAgoHours;
    return active &&
        type != ItemType.job &&
        type != ItemType.poll &&
        type != ItemType.pollopt &&
        timeAgoHours != null &&
        timeAgoHours < 2;
  }

  bool get deletable {
    final num? timeAgoHours = _timeAgoHours;
    return active &&
        type != ItemType.job &&
        type != ItemType.poll &&
        type != ItemType.pollopt &&
        timeAgoHours != null &&
        timeAgoHours < 2 &&
        kids.isEmpty;
  }

  num? get _timeAgoHours =>
      timeDate != null ? DateTime.now().difference(timeDate!).inHours : null;

  Item addKid(int kidId) => copyWith(kids: <int>[kidId, ...kids]);

  Item incrementDescendants() =>
      copyWith(descendants: descendants != null ? descendants! + 1 : null);
}
