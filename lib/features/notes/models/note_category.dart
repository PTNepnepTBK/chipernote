import 'package:flutter/foundation.dart';

/// Category model untuk mengorganisir notes
@immutable
class NoteCategory {
  final String id;
  final String name;
  final String colorCode;
  final String iconCode;
  final int noteCount;
  final DateTime createdAt;
  final int sortOrder;

  const NoteCategory({
    required this.id,
    required this.name,
    required this.colorCode,
    required this.iconCode,
    this.noteCount = 0,
    required this.createdAt,
    this.sortOrder = 0,
  });

  NoteCategory copyWith({
    String? id,
    String? name,
    String? colorCode,
    String? iconCode,
    int? noteCount,
    DateTime? createdAt,
    int? sortOrder,
  }) {
    return NoteCategory(
      id: id ?? this.id,
      name: name ?? this.name,
      colorCode: colorCode ?? this.colorCode,
      iconCode: iconCode ?? this.iconCode,
      noteCount: noteCount ?? this.noteCount,
      createdAt: createdAt ?? this.createdAt,
      sortOrder: sortOrder ?? this.sortOrder,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'colorCode': colorCode,
      'iconCode': iconCode,
      'noteCount': noteCount,
      'createdAt': createdAt.toIso8601String(),
      'sortOrder': sortOrder,
    };
  }

  factory NoteCategory.fromJson(Map<String, dynamic> json) {
    return NoteCategory(
      id: json['id'] as String,
      name: json['name'] as String,
      colorCode: json['colorCode'] as String,
      iconCode: json['iconCode'] as String,
      noteCount: json['noteCount'] as int? ?? 0,
      createdAt: DateTime.parse(json['createdAt'] as String),
      sortOrder: json['sortOrder'] as int? ?? 0,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is NoteCategory && other.id == id && other.name == name;
  }

  @override
  int get hashCode {
    return id.hashCode ^ name.hashCode;
  }

  @override
  String toString() {
    return 'NoteCategory(id: $id, name: $name, noteCount: $noteCount)';
  }
}
