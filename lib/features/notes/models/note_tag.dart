import 'package:flutter/foundation.dart';

/// Tag model untuk organizing dan filtering notes
@immutable
class NoteTag {
  final String id;
  final String name;
  final String colorCode;
  final int noteCount;
  final DateTime createdAt;

  const NoteTag({
    required this.id,
    required this.name,
    required this.colorCode,
    this.noteCount = 0,
    required this.createdAt,
  });

  NoteTag copyWith({
    String? id,
    String? name,
    String? colorCode,
    int? noteCount,
    DateTime? createdAt,
  }) {
    return NoteTag(
      id: id ?? this.id,
      name: name ?? this.name,
      colorCode: colorCode ?? this.colorCode,
      noteCount: noteCount ?? this.noteCount,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'colorCode': colorCode,
      'noteCount': noteCount,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory NoteTag.fromJson(Map<String, dynamic> json) {
    return NoteTag(
      id: json['id'] as String,
      name: json['name'] as String,
      colorCode: json['colorCode'] as String,
      noteCount: json['noteCount'] as int? ?? 0,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is NoteTag && other.id == id && other.name == name;
  }

  @override
  int get hashCode {
    return id.hashCode ^ name.hashCode;
  }

  @override
  String toString() {
    return 'NoteTag(id: $id, name: $name, noteCount: $noteCount)';
  }
}
