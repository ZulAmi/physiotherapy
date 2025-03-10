enum UserRole { patient, therapist, admin }

class UserModel {
  final String id;
  final String email;
  final String? name;
  final UserRole role;
  final String? specialization;
  final String? licenseNumber;
  final List<String>? patientIds;

  UserModel({
    required this.id,
    required this.email,
    this.name,
    required this.role,
    this.specialization,
    this.licenseNumber,
    this.patientIds,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      email: json['email'],
      name: json['name'],
      role: UserRole.values.firstWhere(
        (role) => role.toString() == json['role'],
        orElse: () => UserRole.patient,
      ),
      specialization: json['specialization'],
      licenseNumber: json['licenseNumber'],
      patientIds: List<String>.from(json['patientIds'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'role': role.toString(),
      'specialization': specialization,
      'licenseNumber': licenseNumber,
      'patientIds': patientIds,
    };
  }
}
