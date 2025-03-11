import 'package:cloud_firestore/cloud_firestore.dart';
import '../../auth/models/user_model.dart';

class Therapist extends AppUser {
  final String? specialization;
  final String? phone;
  final String? address;
  final String? biography;
  final String? licenseNumber;
  final String? education;
  final List<String>? certifications;
  final int? experienceYears;
  final bool active;
  final Map<String, dynamic>? schedule;

  const Therapist({
    required super.id,
    required super.email,
    required super.displayName,
    super.role = UserRole.therapist,
    super.photoUrl,
    super.createdAt,
    super.metadata,
    this.specialization,
    this.phone,
    this.address,
    this.biography,
    this.licenseNumber,
    this.education,
    this.certifications,
    this.experienceYears,
    this.active = true,
    this.schedule,
  });

  factory Therapist.fromJson(Map<String, dynamic> json) {
    return Therapist(
      id: json['id'] as String,
      email: json['email'] as String,
      displayName: json['displayName'] as String? ?? '',
      role: _parseUserRole(json['role'] as String?),
      photoUrl: json['photoUrl'] as String?,
      createdAt: json['createdAt'] != null
          ? (json['createdAt'] as Timestamp).toDate()
          : null,
      metadata: json['metadata'] as Map<String, dynamic>?,
      specialization: json['specialization'] as String?,
      phone: json['phone'] as String?,
      address: json['address'] as String?,
      biography: json['biography'] as String?,
      licenseNumber: json['licenseNumber'] as String?,
      education: json['education'] as String?,
      certifications: json['certifications'] != null
          ? List<String>.from(json['certifications'])
          : null,
      experienceYears: json['experienceYears'] as int?,
      active: json['active'] as bool? ?? true,
      schedule: json['schedule'] as Map<String, dynamic>?,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      ...super.toJson(),
      'specialization': specialization,
      'phone': phone,
      'address': address,
      'biography': biography,
      'licenseNumber': licenseNumber,
      'education': education,
      'certifications': certifications,
      'experienceYears': experienceYears,
      'active': active,
      'schedule': schedule,
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

  Therapist copyWith({
    String? id,
    String? email,
    String? displayName,
    UserRole? role,
    String? photoUrl,
    DateTime? createdAt,
    Map<String, dynamic>? metadata,
    String? specialization,
    String? phone,
    String? address,
    String? biography,
    String? licenseNumber,
    String? education,
    List<String>? certifications,
    int? experienceYears,
    bool? active,
    Map<String, dynamic>? schedule,
  }) {
    return Therapist(
      id: id ?? this.id,
      email: email ?? this.email,
      displayName: displayName ?? this.displayName,
      role: role ?? this.role,
      photoUrl: photoUrl ?? this.photoUrl,
      createdAt: createdAt ?? this.createdAt,
      metadata: metadata ?? this.metadata,
      specialization: specialization ?? this.specialization,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      biography: biography ?? this.biography,
      licenseNumber: licenseNumber ?? this.licenseNumber,
      education: education ?? this.education,
      certifications: certifications ?? this.certifications,
      experienceYears: experienceYears ?? this.experienceYears,
      active: active ?? this.active,
      schedule: schedule ?? this.schedule,
    );
  }

  // Factory for creating a new therapist with minimal info
  factory Therapist.create({
    required String email,
    required String displayName,
    String? specialization,
    String? phone,
    String? licenseNumber,
  }) {
    return Therapist(
      id: '', // Will be set during registration
      email: email,
      displayName: displayName,
      specialization: specialization,
      phone: phone,
      licenseNumber: licenseNumber,
    );
  }
}
