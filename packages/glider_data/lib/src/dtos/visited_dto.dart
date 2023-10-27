class VisitedDto {
  const VisitedDto(this.itemId, this.time);

  factory VisitedDto.deserialize(String stored) {
    final parts = stored.split('|');
    if (parts.length == 1) {
      return VisitedDto(int.parse(parts[0]), null);
    } else if (parts.length == 2) {
      return VisitedDto(
        int.parse(parts[0]),
        DateTime.fromMillisecondsSinceEpoch(int.parse(parts[1]), isUtc: true)
            .toLocal(),
      );
    } else {
      throw Exception('Could not parse visited');
    }
  }

  final int itemId;
  final DateTime? time;

  String serialize() => (time == null)
      ? itemId.toString()
      : '$itemId|${time!.toUtc().millisecondsSinceEpoch}';
}
