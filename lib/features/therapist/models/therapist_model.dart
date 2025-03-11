import '../../auth/models/user_model.dart';

class Therapist extends AppUser {
  final String specialization;
  final String phone;
  final String licenseNumber;
  final String? biography;
  final bool active; // Add this field if not already present

  Therapist({
    required String id,
    required String email,
    required String? displayName,
    required this.specialization,
    required this.phone,
    required this.licenseNumber,
    this.biography,
    this.active = true, // Default to active
  }) : super(
          id: id,
          email: email,
          displayName: displayName,
          role: UserRole.therapist,
        );

  // Factory constructor for creating new therapists (pre-registration)
  factory Therapist.create({
    required String email,
    required String displayName,
    required String specialization,
    required String phone,
    required String licenseNumber,
    String? biography,
  }) {
    return Therapist(
      id: '', // ID will be assigned after registration
      email: email,
      displayName: displayName,
      specialization: specialization,
      phone: phone,
      licenseNumber: licenseNumber,
      biography: biography,
    );
  }

  // Add this copyWith method
  @override
  Therapist copyWith({
    String? id,
    String? email,
    String? displayName,
    DateTime? createdAt,
    Map<String, dynamic>? metadata,
    String? photoUrl,
    UserRole? role,
    String? specialization,
    String? phone,
    String? licenseNumber,
    String? biography,
    bool? active,
  }) {
    return Therapist(
      id: id ?? this.id,
      email: email ?? this.email,
      displayName: displayName ?? this.displayName,
      specialization: specialization ?? this.specialization,
      phone: phone ?? this.phone,
      licenseNumber: licenseNumber ?? this.licenseNumber,
      biography: biography ?? this.biography,
      active: active ?? this.active,
    );
  }

  // Create Therapist from JSON (for fetching from database)
  factory Therapist.fromJson(Map<String, dynamic> json) {
    return Therapist(
      id: json['id'] ?? '',
      email: json['email'] ?? '',
      displayName: json['displayName'],
      specialization: json['specialization'] ?? '',
      phone: json['phone'] ?? '',
      licenseNumber: json['licenseNumber'] ?? '',
      biography: json['biography'],
      active: json['active'] ?? true, // Default to true if not specified
    );
  }

  // Convert to JSON for storing in database
  @override
  Map<String, dynamic> toJson() {
    final baseJson = super.toJson(); // Get base user properties
    return {
      ...baseJson,
      'specialization': specialization,
      'phone': phone,
      'licenseNumber': licenseNumber,
      if (biography != null) 'biography': biography,
      'active': active,
    };
  }
}
