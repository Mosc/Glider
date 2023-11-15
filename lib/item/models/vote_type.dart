enum VoteType {
  upvote,
  downvote;
}

extension NullableVoteTypeExtension on VoteType? {
  bool get upvoted => this == VoteType.upvote;

  bool get downvoted => this == VoteType.downvote;
}
