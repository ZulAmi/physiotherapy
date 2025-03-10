import 'package:cloud_firestore/cloud_firestore.dart';

class Patient {
  final String id;
  final String name;
  final String email;
  final String therapistId;
  final DateTime dateOfBirth;
  final String? phoneNumber;
  final String? condition;
  final String? notes;
  final DateTime lastVisit;
  final List<String> prescribedExercises;

  Patient({
    required this.id,
    required this.name,
    required this.email,
    required this.therapistId,
    required this.dateOfBirth,
    this.phoneNumber,
    this.condition,
    this.notes,
    required this.lastVisit,
    this.prescribedExercises = const [],
  });

  factory Patient.fromJson(Map<String, dynamic> json) {
    return Patient(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      therapistId: json['therapistId'],
      dateOfBirth: (json['dateOfBirth'] as Timestamp).toDate(),
      phoneNumber: json['phoneNumber'],
      condition: json['condition'],
      notes: json['notes'],
      lastVisit: (json['lastVisit'] as Timestamp).toDate(),
      prescribedExercises: List<String>.from(json['prescribedExercises'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'therapistId': therapistId,
      'dateOfBirth': Timestamp.fromDate(dateOfBirth),
      'phoneNumber': phoneNumber,
      'condition': condition,
      'notes': notes,
      'lastVisit': Timestamp.fromDate(lastVisit),
      'prescribedExercises': prescribedExercises,
    };
  }

  Patient copyWith({
    String? id,
    String? name,
    String? email,
    String? therapistId,
    DateTime? dateOfBirth,
    String? phoneNumber,
    String? condition,
    String? notes,
    DateTime? lastVisit,
    List<String>? prescribedExercises,
  }) {
    return Patient(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      therapistId: therapistId ?? this.therapistId,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      condition: condition ?? this.condition,
      notes: notes ?? this.notes,
      lastVisit: lastVisit ?? this.lastVisit,
      prescribedExercises: prescribedExercises ?? this.prescribedExercises,
    );
  }
}
