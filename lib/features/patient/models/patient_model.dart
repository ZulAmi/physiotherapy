import 'package:cloud_firestore/cloud_firestore.dart';

class Patient {
  final String id;
  final String name;
  final String email;
  final String therapistId;
  final DateTime dateOfBirth;
  final String? phoneNumber;
  final String? emergencyContact;
  final String? condition;
  final String? diagnosis;
  final List<String> medications;
  final String? allergies;
  final String? notes;
  final DateTime lastVisit;
  final int totalSessions;
  final List<String> prescribedExercises;
  final PatientStatus status;

  Patient({
    required this.id,
    required this.name,
    required this.email,
    required this.therapistId,
    required this.dateOfBirth,
    this.phoneNumber,
    this.emergencyContact,
    this.condition,
    this.diagnosis,
    this.medications = const [],
    this.allergies,
    this.notes,
    required this.lastVisit,
    this.totalSessions = 0,
    this.prescribedExercises = const [],
    this.status = PatientStatus.active,
  });

  factory Patient.fromJson(Map<String, dynamic> json) {
    return Patient(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      therapistId: json['therapistId'],
      dateOfBirth: (json['dateOfBirth'] as Timestamp).toDate(),
      phoneNumber: json['phoneNumber'],
      emergencyContact: json['emergencyContact'],
      condition: json['condition'],
      diagnosis: json['diagnosis'],
      medications: List<String>.from(json['medications'] ?? []),
      allergies: json['allergies'],
      notes: json['notes'],
      lastVisit: (json['lastVisit'] as Timestamp).toDate(),
      totalSessions: json['totalSessions'] ?? 0,
      prescribedExercises: List<String>.from(json['prescribedExercises'] ?? []),
      status: PatientStatus.values.firstWhere(
        (e) => e.toString() == json['status'],
        orElse: () => PatientStatus.active,
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'therapistId': therapistId,
      'dateOfBirth': Timestamp.fromDate(dateOfBirth),
      'phoneNumber': phoneNumber,
      'emergencyContact': emergencyContact,
      'condition': condition,
      'diagnosis': diagnosis,
      'medications': medications,
      'allergies': allergies,
      'notes': notes,
      'lastVisit': Timestamp.fromDate(lastVisit),
      'totalSessions': totalSessions,
      'prescribedExercises': prescribedExercises,
      'status': status.toString(),
    };
  }

  Patient copyWith({
    String? id,
    String? name,
    String? email,
    String? therapistId,
    DateTime? dateOfBirth,
    String? phoneNumber,
    String? emergencyContact,
    String? condition,
    String? diagnosis,
    List<String>? medications,
    String? allergies,
    String? notes,
    DateTime? lastVisit,
    int? totalSessions,
    List<String>? prescribedExercises,
    PatientStatus? status,
  }) {
    return Patient(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      therapistId: therapistId ?? this.therapistId,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      emergencyContact: emergencyContact ?? this.emergencyContact,
      condition: condition ?? this.condition,
      diagnosis: diagnosis ?? this.diagnosis,
      medications: medications ?? this.medications,
      allergies: allergies ?? this.allergies,
      notes: notes ?? this.notes,
      lastVisit: lastVisit ?? this.lastVisit,
      totalSessions: totalSessions ?? this.totalSessions,
      prescribedExercises: prescribedExercises ?? this.prescribedExercises,
      status: status ?? this.status,
    );
  }
}

enum PatientStatus { active, inactive, discharged, onHold }
