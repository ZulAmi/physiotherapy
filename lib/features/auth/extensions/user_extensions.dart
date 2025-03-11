import '../models/user_model.dart';

extension UserDisplayExtension on AppUser {
  // Safely get display name with fallback
  String get displayNameSafe => displayName ?? email.split('@').first;

  // Get formatted name with title based on role
  String get formalName {
    final baseName = displayNameSafe;

    switch (role) {
      case UserRole.therapist:
        return 'Dr. $baseName';
      case UserRole.admin:
        return 'Admin $baseName';
      case UserRole.assistant:
        return 'Assistant $baseName';
      case UserRole.patient:
      default:
        return baseName;
    }
  }
}
