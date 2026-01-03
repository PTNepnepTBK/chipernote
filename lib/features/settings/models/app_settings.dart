import 'package:flutter/foundation.dart';

/// App settings model
@immutable
class AppSettings {
  final String userId;
  final String themeMode; // dark, light, system
  final String accentColor;
  final String fontSize; // small, medium, large, xlarge
  final String fontFamily;
  final bool autoLockEnabled;
  final int autoLockDuration; // in seconds
  final bool biometricEnabled;
  final bool screenProtectionEnabled;
  final bool customKeyboardEnabled;
  final int failedLoginLimit;
  final int failedLoginCount;
  final DateTime? lastFailedLoginAt;
  final bool selfDestructEnabled;
  final String? decoyPasswordHash;
  final bool backupEnabled;
  final String backupFrequency; // daily, weekly, manual
  final DateTime? lastBackupAt;
  final bool analyticsEnabled;
  final bool showTutorials;
  final String defaultNoteColor;
  final String sortNotesBy; // dateModified, dateCreated, title, manual
  final String sortOrder; // ascending, descending
  final int gridColumns;
  final int previewLines;

  const AppSettings({
    required this.userId,
    this.themeMode = 'dark',
    this.accentColor = '#00BCD4',
    this.fontSize = 'medium',
    this.fontFamily = 'Inter',
    this.autoLockEnabled = true,
    this.autoLockDuration = 300, // 5 minutes
    this.biometricEnabled = false,
    this.screenProtectionEnabled = true,
    this.customKeyboardEnabled = true,
    this.failedLoginLimit = 10,
    this.failedLoginCount = 0,
    this.lastFailedLoginAt,
    this.selfDestructEnabled = false,
    this.decoyPasswordHash,
    this.backupEnabled = false,
    this.backupFrequency = 'manual',
    this.lastBackupAt,
    this.analyticsEnabled = false,
    this.showTutorials = true,
    this.defaultNoteColor = '#00BCD4',
    this.sortNotesBy = 'dateModified',
    this.sortOrder = 'descending',
    this.gridColumns = 2,
    this.previewLines = 3,
  });

  AppSettings copyWith({
    String? userId,
    String? themeMode,
    String? accentColor,
    String? fontSize,
    String? fontFamily,
    bool? autoLockEnabled,
    int? autoLockDuration,
    bool? biometricEnabled,
    bool? screenProtectionEnabled,
    bool? customKeyboardEnabled,
    int? failedLoginLimit,
    int? failedLoginCount,
    DateTime? lastFailedLoginAt,
    bool? selfDestructEnabled,
    String? decoyPasswordHash,
    bool? backupEnabled,
    String? backupFrequency,
    DateTime? lastBackupAt,
    bool? analyticsEnabled,
    bool? showTutorials,
    String? defaultNoteColor,
    String? sortNotesBy,
    String? sortOrder,
    int? gridColumns,
    int? previewLines,
  }) {
    return AppSettings(
      userId: userId ?? this.userId,
      themeMode: themeMode ?? this.themeMode,
      accentColor: accentColor ?? this.accentColor,
      fontSize: fontSize ?? this.fontSize,
      fontFamily: fontFamily ?? this.fontFamily,
      autoLockEnabled: autoLockEnabled ?? this.autoLockEnabled,
      autoLockDuration: autoLockDuration ?? this.autoLockDuration,
      biometricEnabled: biometricEnabled ?? this.biometricEnabled,
      screenProtectionEnabled: screenProtectionEnabled ?? this.screenProtectionEnabled,
      customKeyboardEnabled: customKeyboardEnabled ?? this.customKeyboardEnabled,
      failedLoginLimit: failedLoginLimit ?? this.failedLoginLimit,
      failedLoginCount: failedLoginCount ?? this.failedLoginCount,
      lastFailedLoginAt: lastFailedLoginAt ?? this.lastFailedLoginAt,
      selfDestructEnabled: selfDestructEnabled ?? this.selfDestructEnabled,
      decoyPasswordHash: decoyPasswordHash ?? this.decoyPasswordHash,
      backupEnabled: backupEnabled ?? this.backupEnabled,
      backupFrequency: backupFrequency ?? this.backupFrequency,
      lastBackupAt: lastBackupAt ?? this.lastBackupAt,
      analyticsEnabled: analyticsEnabled ?? this.analyticsEnabled,
      showTutorials: showTutorials ?? this.showTutorials,
      defaultNoteColor: defaultNoteColor ?? this.defaultNoteColor,
      sortNotesBy: sortNotesBy ?? this.sortNotesBy,
      sortOrder: sortOrder ?? this.sortOrder,
      gridColumns: gridColumns ?? this.gridColumns,
      previewLines: previewLines ?? this.previewLines,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'themeMode': themeMode,
      'accentColor': accentColor,
      'fontSize': fontSize,
      'fontFamily': fontFamily,
      'autoLockEnabled': autoLockEnabled,
      'autoLockDuration': autoLockDuration,
      'biometricEnabled': biometricEnabled,
      'screenProtectionEnabled': screenProtectionEnabled,
      'customKeyboardEnabled': customKeyboardEnabled,
      'failedLoginLimit': failedLoginLimit,
      'failedLoginCount': failedLoginCount,
      'lastFailedLoginAt': lastFailedLoginAt?.toIso8601String(),
      'selfDestructEnabled': selfDestructEnabled,
      'decoyPasswordHash': decoyPasswordHash,
      'backupEnabled': backupEnabled,
      'backupFrequency': backupFrequency,
      'lastBackupAt': lastBackupAt?.toIso8601String(),
      'analyticsEnabled': analyticsEnabled,
      'showTutorials': showTutorials,
      'defaultNoteColor': defaultNoteColor,
      'sortNotesBy': sortNotesBy,
      'sortOrder': sortOrder,
      'gridColumns': gridColumns,
      'previewLines': previewLines,
    };
  }

  factory AppSettings.fromJson(Map<String, dynamic> json) {
    return AppSettings(
      userId: json['userId'] as String,
      themeMode: json['themeMode'] as String? ?? 'dark',
      accentColor: json['accentColor'] as String? ?? '#00BCD4',
      fontSize: json['fontSize'] as String? ?? 'medium',
      fontFamily: json['fontFamily'] as String? ?? 'Inter',
      autoLockEnabled: json['autoLockEnabled'] as bool? ?? true,
      autoLockDuration: json['autoLockDuration'] as int? ?? 300,
      biometricEnabled: json['biometricEnabled'] as bool? ?? false,
      screenProtectionEnabled: json['screenProtectionEnabled'] as bool? ?? true,
      customKeyboardEnabled: json['customKeyboardEnabled'] as bool? ?? true,
      failedLoginLimit: json['failedLoginLimit'] as int? ?? 10,
      failedLoginCount: json['failedLoginCount'] as int? ?? 0,
      lastFailedLoginAt: json['lastFailedLoginAt'] != null
          ? DateTime.parse(json['lastFailedLoginAt'] as String)
          : null,
      selfDestructEnabled: json['selfDestructEnabled'] as bool? ?? false,
      decoyPasswordHash: json['decoyPasswordHash'] as String?,
      backupEnabled: json['backupEnabled'] as bool? ?? false,
      backupFrequency: json['backupFrequency'] as String? ?? 'manual',
      lastBackupAt: json['lastBackupAt'] != null
          ? DateTime.parse(json['lastBackupAt'] as String)
          : null,
      analyticsEnabled: json['analyticsEnabled'] as bool? ?? false,
      showTutorials: json['showTutorials'] as bool? ?? true,
      defaultNoteColor: json['defaultNoteColor'] as String? ?? '#00BCD4',
      sortNotesBy: json['sortNotesBy'] as String? ?? 'dateModified',
      sortOrder: json['sortOrder'] as String? ?? 'descending',
      gridColumns: json['gridColumns'] as int? ?? 2,
      previewLines: json['previewLines'] as int? ?? 3,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is AppSettings && other.userId == userId;
  }

  @override
  int get hashCode {
    return userId.hashCode;
  }

  @override
  String toString() {
    return 'AppSettings(userId: $userId, themeMode: $themeMode, biometric: $biometricEnabled)';
  }
}
