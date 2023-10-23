class AlgoliaSearchDto {
  const AlgoliaSearchDto({required this.hits});

  factory AlgoliaSearchDto.fromJson(Map<String, dynamic> json) =>
      AlgoliaSearchDto(
        hits: (json['hits'] as List<dynamic>)
            .map(
              (e) => AlgoliaSearchHitDto.fromJson(e as Map<String, dynamic>),
            )
            .toList(growable: false),
      );

  final List<AlgoliaSearchHitDto> hits;
}

class AlgoliaSearchHitDto {
  const AlgoliaSearchHitDto({
    required this.objectId,
    this.title,
    this.url,
    this.author,
    this.points,
    this.storyText,
    this.commentText,
    this.numComments,
    this.parentId,
    this.createdAtI,
  });

  factory AlgoliaSearchHitDto.fromJson(Map<String, dynamic> json) =>
      AlgoliaSearchHitDto(
        objectId: json['objectID'] as String,
        title: json['title'] as String?,
        url: json['url'] as String?,
        author: json['author'] as String?,
        points: json['points'] as int?,
        storyText: json['story_text'] as String?,
        commentText: json['comment_text'] as String?,
        numComments: json['num_comments'] as int?,
        parentId: json['parent_id'] as int?,
        createdAtI: json['created_at_i'] as int?,
      );

  final String objectId;
  final String? title;
  final String? url;
  final String? author;
  final int? points;
  final String? storyText;
  final String? commentText;
  final int? numComments;
  final int? parentId;
  final int? createdAtI;
}
