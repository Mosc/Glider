class ItemDto {
  const ItemDto({
    required this.id,
    this.deleted,
    this.type,
    this.by,
    this.time,
    this.text,
    this.dead,
    this.parent,
    this.poll,
    this.kids,
    this.url,
    this.score,
    this.title,
    this.parts,
    this.descendants,
  });

  factory ItemDto.fromJson(Map<String, dynamic> json) => ItemDto(
        id: json['id'] as int,
        deleted: json['deleted'] as bool?,
        type: json['type'] as String?,
        by: json['by'] as String?,
        time: json['time'] as int?,
        text: json['text'] as String?,
        dead: json['dead'] as bool?,
        parent: json['parent'] as int?,
        poll: json['poll'] as int?,
        kids: (json['kids'] as List<dynamic>?)
            ?.map((e) => e as int)
            .toList(growable: false),
        url: json['url'] as String?,
        score: json['score'] as int?,
        title: json['title'] as String?,
        parts: (json['parts'] as List<dynamic>?)
            ?.map((e) => e as int)
            .toList(growable: false),
        descendants: json['descendants'] as int?,
      );

  final int id;
  final bool? deleted;
  final String? type;
  final String? by;
  final int? time;
  final String? text;
  final bool? dead;
  final int? parent;
  final int? poll;
  final List<int>? kids;
  final String? url;
  final int? score;
  final String? title;
  final List<int>? parts;
  final int? descendants;
}
