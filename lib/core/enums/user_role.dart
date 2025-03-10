enum UserRole {
  patient,
  therapist,
  admin;

  bool get isHealthcareProfessional =>
      this == UserRole.therapist || this == UserRole.admin;
}
