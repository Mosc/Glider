import 'package:equatable/equatable.dart';

class ItemDescendant with EquatableMixin {
  ItemDescendant({
    required this.id,
    this.ancestorIds = const [],
    this.isPart = false,
  });

  factory ItemDescendant.fromMap(Map<String, dynamic> json) => ItemDescendant(
        id: json['id'] as int,
        ancestorIds: (json['ancestorIds'] as List<dynamic>?)
                ?.map((e) => e as int)
                .toList(growable: false) ??
            const [],
        isPart: json['isPart'] as bool? ?? false,
      );

  Map<String, dynamic> toMap() => <String, dynamic>{
        'id': id,
        'ancestorIds': ancestorIds,
        'isPart': isPart,
      };

  final int id;
  final List<int> ancestorIds;
  final bool isPart;

  @override
  List<Object?> get props => [
        id,
        ancestorIds,
        isPart,
      ];
}

extension ItemDescendantExtension on ItemDescendant {
  int get depth => ancestorIds.length;
}
