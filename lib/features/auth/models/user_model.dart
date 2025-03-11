import 'package:cloud_firestore/cloud_firestore.dart';

enum UserRole { therapist, admin, patient, assistant }

class AppUser {
  final String id;
  final String email;
  final String? displayName;
  final UserRole role;
  final String? photoUrl;
  final DateTime? createdAt;
  final Map<String, dynamic>? metadata;

  const AppUser({
    required this.id,
    required this.email,
    this.displayName,
    required this.role,
    this.photoUrl,
    this.createdAt,
    this.metadata,
  });

  factory AppUser.fromJson(Map<String, dynamic> json) {
    return AppUser(
      id: json['id'] as String,
      email: json['email'] as String,
      displayName: json['displayName'] as String?,
      role: _parseUserRole(json['role'] as String?),
      photoUrl: json['photoUrl'] as String?,
      createdAt: json['createdAt'] != null
          ? (json['createdAt'] as Timestamp).toDate()
          : null,
      metadata: json['metadata'] as Map<String, dynamic>?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'displayName': displayName,
      'role': role.toString().split('.').last,
      'photoUrl': photoUrl,
      'createdAt': createdAt != null ? Timestamp.fromDate(createdAt!) : null,
      'metadata': metadata,
    };
  }

  static UserRole _parseUserRole(String? role) {
    if (role == null) return UserRole.therapist;

    switch (role.toLowerCase()) {
      case 'admin':
        return UserRole.admin;
      case 'patient':
        return UserRole.patient;
      case 'assistant':
        return UserRole.assistant;
      case 'therapist':
      default:
        return UserRole.therapist;
    }
  }

  AppUser copyWith({
    String? id,
    String? email,
    String? displayName,
    UserRole? role,
    String? photoUrl,
    DateTime? createdAt,
    Map<String, dynamic>? metadata,
  }) {
    return AppUser(
      id: id ?? this.id,
      email: email ?? this.email,
      displayName: displayName ?? this.displayName,
      role: role ?? this.role,
      photoUrl: photoUrl ?? this.photoUrl,
      createdAt: createdAt ?? this.createdAt,
      metadata: metadata ?? this.metadata,
    );
  }

  bool get isAdmin => role == UserRole.admin;
  bool get isTherapist => role == UserRole.therapist || role == UserRole.admin;
  bool get isPatient => role == UserRole.patient;
}
