import 'package:flutter/foundation.dart';

/// Note entity model dengan enkripsi
@immutable
class Note {
  final String id;
  final String encryptedTitle;
  final String encryptedContent;
  final String titleSalt;
  final String contentSalt;
  final String titleIV;
  final String contentIV;
  final bool hasIndependentPassword;
  final String? independentPasswordHash;
  final String? categoryId;
  final List<String> tagIds;
  final bool ispinned;
  final bool isPinned;
  final String colorCode;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? lastAccessedAt;
  final int version;
  final int wordCount;
  final int characterCount;
  final int estimatedReadingTime;
  final List<String> attachmentIds;

  const Note({
    required this.id,
    required this.encryptedTitle,
    required this.encryptedContent,
    required this.titleSalt,
    required this.contentSalt,
    required this.titleIV,
    required this.contentIV,
    this.hasIndependentPassword = false,
    this.independentPasswordHash,
    this.categoryId,
    this.tagIds = const [],
    this.ispinned = false,
    this.isPinned = false,
    this.colorCode = '#00BCD4',
    required this.createdAt,
    required this.updatedAt,
    this.lastAccessedAt,
    this.version = 1,
    this.wordCount = 0,
    this.characterCount = 0,
    this.estimatedReadingTime = 0,
    this.attachmentIds = const [],
  });

  Note copyWith({
    String? id,
    String? encryptedTitle,
    String? encryptedContent,
    String? titleSalt,
    String? contentSalt,
    String? titleIV,
    String? contentIV,
    bool? hasIndependentPassword,
    String? independentPasswordHash,
    String? categoryId,
    List<String>? tagIds,
    bool? ispinned,
    bool? isPinned,
    String? colorCode,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? lastAccessedAt,
    int? version,
    int? wordCount,
    int? characterCount,
    int? estimatedReadingTime,
    List<String>? attachmentIds,
  }) {
    return Note(
      id: id ?? this.id,
      encryptedTitle: encryptedTitle ?? this.encryptedTitle,
      encryptedContent: encryptedContent ?? this.encryptedContent,
      titleSalt: titleSalt ?? this.titleSalt,
      contentSalt: contentSalt ?? this.contentSalt,
      titleIV: titleIV ?? this.titleIV,
      contentIV: contentIV ?? this.contentIV,
      hasIndependentPassword: hasIndependentPassword ?? this.hasIndependentPassword,
      independentPasswordHash: independentPasswordHash ?? this.independentPasswordHash,
      categoryId: categoryId ?? this.categoryId,
      tagIds: tagIds ?? this.tagIds,
      ispinned: ispinned ?? this.ispinned,
      isPinned: isPinned ?? this.isPinned,
      colorCode: colorCode ?? this.colorCode,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      lastAccessedAt: lastAccessedAt ?? this.lastAccessedAt,
      version: version ?? this.version,
      wordCount: wordCount ?? this.wordCount,
      characterCount: characterCount ?? this.characterCount,
      estimatedReadingTime: estimatedReadingTime ?? this.estimatedReadingTime,
      attachmentIds: attachmentIds ?? this.attachmentIds,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'encryptedTitle': encryptedTitle,
      'encryptedContent': encryptedContent,
      'titleSalt': titleSalt,
      'contentSalt': contentSalt,
      'titleIV': titleIV,
      'contentIV': contentIV,
      'hasIndependentPassword': hasIndependentPassword,
      'independentPasswordHash': independentPasswordHash,
      'categoryId': categoryId,
      'tagIds': tagIds,
      'ispinned': ispinned,
      'isPinned': isPinned,
      'colorCode': colorCode,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'lastAccessedAt': lastAccessedAt?.toIso8601String(),
      'version': version,
      'wordCount': wordCount,
      'characterCount': characterCount,
      'estimatedReadingTime': estimatedReadingTime,
      'attachmentIds': attachmentIds,
    };
  }

  factory Note.fromJson(Map<String, dynamic> json) {
    return Note(
      id: json['id'] as String,
      encryptedTitle: json['encryptedTitle'] as String,
      encryptedContent: json['encryptedContent'] as String,
      titleSalt: json['titleSalt'] as String,
      contentSalt: json['contentSalt'] as String,
      titleIV: json['titleIV'] as String,
      contentIV: json['contentIV'] as String,
      hasIndependentPassword: json['hasIndependentPassword'] as bool? ?? false,
      independentPasswordHash: json['independentPasswordHash'] as String?,
      categoryId: json['categoryId'] as String?,
      tagIds: (json['tagIds'] as List<dynamic>?)?.map((e) => e as String).toList() ?? [],
      ispinned: json['ispinned'] as bool? ?? false,
      isPinned: json['isPinned'] as bool? ?? false,
      colorCode: json['colorCode'] as String? ?? '#00BCD4',
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      lastAccessedAt: json['lastAccessedAt'] != null
          ? DateTime.parse(json['lastAccessedAt'] as String)
          : null,
      version: json['version'] as int? ?? 1,
      wordCount: json['wordCount'] as int? ?? 0,
      characterCount: json['characterCount'] as int? ?? 0,
      estimatedReadingTime: json['estimatedReadingTime'] as int? ?? 0,
      attachmentIds: (json['attachmentIds'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Note &&
        other.id == id &&
        other.encryptedTitle == encryptedTitle &&
        other.encryptedContent == encryptedContent &&
        other.version == version;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        encryptedTitle.hashCode ^
        encryptedContent.hashCode ^
        version.hashCode;
  }

  @override
  String toString() {
    return 'Note(id: $id, ispinned: $ispinned, isPinned: $isPinned, createdAt: $createdAt)';
  }
}
