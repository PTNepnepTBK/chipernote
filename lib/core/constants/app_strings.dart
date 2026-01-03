/// Text constants untuk reusability di seluruh aplikasi
class AppStrings {
  AppStrings._();

  // ========== APP INFO ==========
  static const String appName = 'SecureNotes';
  static const String appTagline = 'Your thoughts, encrypted forever';
  static const String appVersion = '1.0.0';
  static const String madeWith = 'Made with encryption ❤️';

  // ========== ONBOARDING ==========
  static const String onboardingTitle1 = 'Bank-Grade Encryption';
  static const String onboardingDesc1 =
      'AES-256 encryption keeps your notes safer than Fort Knox. Not even we can read them.';

  static const String onboardingTitle2 = 'Built-in Secure Keyboard';
  static const String onboardingDesc2 =
      'Type without fear. Our custom keyboard bypasses keyloggers and clipboard hijackers completely.';

  static const String onboardingTitle3 = 'Stealth Mode Protection';
  static const String onboardingDesc3 =
      'Screen recording? Screenshots? They\'ll only capture black screens. Your secrets stay secret.';

  static const String getStarted = 'Get Started';

  // ========== AUTHENTICATION ==========
  static const String createMasterPassword = 'Create Master Password';
  static const String masterPasswordSubtitle =
      'This password encrypts all your notes. Choose wisely - it cannot be recovered.';
  static const String masterPassword = 'Master Password';
  static const String confirmPassword = 'Confirm Password';
  static const String passwordStrength = 'Password Strength';
  static const String weak = 'Weak';
  static const String medium = 'Medium';
  static const String strong = 'Strong';
  static const String createAndSecure = 'Create & Secure';
  static const String enableBiometric = 'Enable biometric unlock';
  static const String unlock = 'Unlock';
  static const String forgotPassword = 'Forgot Password?';
  static const String or = 'or';

  // Password Requirements
  static const String requirementMinLength = 'Minimum 8 characters';
  static const String requirementUpperLower = 'Contains uppercase and lowercase';
  static const String requirementNumber = 'Contains number';
  static const String requirementSpecial = 'Contains special character';

  // ========== NOTES ==========
  static const String myNotes = 'My Notes';
  static const String notesEncrypted = 'notes • All encrypted';
  static const String searchNotes = 'Search encrypted notes...';
  static const String noteTitle = 'Note title';
  static const String newNote = 'New Note';
  static const String noNotesYet = 'No notes yet';
  static const String noNotesSubtitle = 'Tap + to create your first encrypted note';
  static const String words = 'words';
  static const String chars = 'chars';
  static const String minRead = 'min read';
  static const String editing = 'Editing';
  static const String allSaved = 'All saved';
  static const String encrypting = 'Encrypting...';
  static const String saving = 'Saving...';

  // Note Actions
  static const String edit = 'Edit';
  static const String duplicate = 'Duplicate';
  static const String lock = 'Lock';
  static const String unlockNote = 'Unlock';
  static const String moveToFolder = 'Move to Folder';
  static const String share = 'Share';
  static const String delete = 'Delete';

  // Filters
  static const String filterAll = 'All';
  static const String filterFavorites = 'Favorites';
  static const String filterLocked = 'Locked';
  static const String filterRecent = 'Recent';
  static const String filterTags = 'Tags';

  // Empty States
  static const String noSearchResults = 'No notes found';
  static const String tryDifferentSearch = 'Try a different search term';
  static const String clearSearch = 'Clear search';
  static const String noFavorites = 'No favorites yet';
  static const String noFavoritesSubtitle = 'Tap star on notes to add them here';
  static const String noTags = 'No tags created';
  static const String createTag = 'Create tag';

  // ========== EDITOR ==========
  static const String thisNoteIsLocked = 'This note is locked';
  static const String enterNotePassword = 'Enter Note Password';
  static const String tapToUnlock = 'Tap to unlock';
  static const String insertLink = 'Insert link';
  static const String insertImage = 'Insert image';

  // ========== SETTINGS ==========
  static const String settings = 'Settings';

  // Security Section
  static const String security = 'Security';
  static const String changeMasterPassword = 'Change Master Password';
  static const String biometricUnlock = 'Biometric Unlock';
  static const String biometricSubtitle = 'Use fingerprint or face ID';
  static const String autoLock = 'Auto-lock timeout';
  static const String screenProtection = 'Screen Protection';
  static const String screenProtectionSubtitle =
      'Prevent screenshots and screen recording';

  // Auto-lock options
  static const String immediately = 'Immediately';
  static const String oneMinute = '1 minute';
  static const String fiveMinutes = '5 minutes';
  static const String fifteenMinutes = '15 minutes';
  static const String thirtyMinutes = '30 minutes';
  static const String never = 'Never';

  // Data & Storage
  static const String dataStorage = 'Data & Storage';
  static const String exportBackup = 'Export encrypted backup';
  static const String importBackup = 'Import backup';
  static const String storageUsage = 'Storage Usage';
  static const String backupSize = 'Backup size';

  // Appearance
  static const String appearance = 'Appearance';
  static const String theme = 'Theme';
  static const String themeDark = 'Dark';
  static const String themeLight = 'Light';
  static const String themeAuto = 'Auto';
  static const String accentColor = 'Accent Color';
  static const String fontSize = 'Font Size';
  static const String fontSizeSmall = 'Small';
  static const String fontSizeMedium = 'Medium';
  static const String fontSizeLarge = 'Large';
  static const String fontSizeXLarge = 'XLarge';

  // Advanced
  static const String advanced = 'Advanced';
  static const String setupDecoyPassword = 'Setup Decoy Password';
  static const String decoyPasswordSubtitle =
      'Opens empty vault with fake password';
  static const String proFeature = 'Pro Feature';
  static const String selfDestruct = 'Failed Login Limit';
  static const String selfDestructSubtitle = 'Delete all data after X attempts';
  static const String wipeDataNow = 'Emergency Wipe';
  static const String wipeDataSubtitle = 'Immediately delete all encrypted data';
  static const String attempts = 'attempts';

  // About
  static const String about = 'About';
  static const String version = 'Version';
  static const String checkUpdates = 'Tap to check for updates';
  static const String privacyPolicy = 'Privacy Policy';
  static const String termsOfService = 'Terms of Service';
  static const String openSourceLicenses = 'Open Source Licenses';

  // ========== DIALOGS ==========
  static const String deleteNote = 'Delete Note?';
  static const String deleteNoteMessage =
      'This note will be permanently deleted. This action cannot be undone.';
  static const String dontAskAgain = 'Don\'t ask again';
  static const String cancel = 'Cancel';
  static const String confirm = 'Confirm';

  // ========== TOASTS ==========
  static const String noteSavedSuccessfully = 'Note saved successfully';
  static const String failedToEncryptNote = 'Failed to encrypt note';
  static const String noteLockedWithPassword = 'Note locked with password';
  static const String weakPasswordDetected = 'Weak password detected';
  static const String incorrectPassword = 'Incorrect password';
  static const String attemptsRemaining = 'attempts remaining';

  // ========== SCREEN PROTECTION ==========
  static const String screenRecordingDetected =
      'Screen recording detected - content hidden';
  static const String screenshotBlocked = 'Screenshot blocked';

  // ========== ERRORS ==========
  static const String encryptionFailed = 'Encryption failed';
  static const String decryptionFailed = 'Decryption failed';
  static const String pleaseRestartApp = 'Please restart the app';
  static const String contactSupport = 'Contact support';
  static const String networkError = 'Offline - changes saved locally';
  static const String tryToRecover = 'Try to recover';
  static const String corruptedNote = 'Note cannot be decrypted';

  // ========== MISC ==========
  static const String loading = 'Loading...';
  static const String loadingMore = 'Loading more...';
  static const String gotIt = 'Got it';
  static const String skipTutorial = 'Skip tutorial';
  static const String restart = 'Restart';
  static const String retry = 'Retry';
  static const String estimatedTime = 'Estimated time remaining';
  static const String secondsLeft = 'seconds left';
}
