import 'package:cloud_firestore/cloud_firestore.dart';

enum AppointmentType {
  inPerson,
  video,
  phone,
}

enum AppointmentStatus {
  scheduled,
  confirmed,
  completed,
  cancelled,
  noShow,
}

class Appointment {
  final String id;
  final String patientId;
  final String therapistId;
  final DateTime dateTime;
  final int durationMinutes;
  final AppointmentType type;
  final AppointmentStatus status;
  final String? notes;
  final bool sendReminder;
  final DateTime createdAt;

  const Appointment({
    required this.id,
    required this.patientId,
    required this.therapistId,
    required this.dateTime,
    required this.durationMinutes,
    required this.type,
    required this.status,
    this.notes,
    required this.sendReminder,
    required this.createdAt,
  });

  factory Appointment.fromJson(Map<String, dynamic> json) {
    return Appointment(
      id: json['id'] as String,
      patientId: json['patientId'] as String,
      therapistId: json['therapistId'] as String,
      dateTime: (json['dateTime'] as Timestamp).toDate(),
      durationMinutes: json['durationMinutes'] as int,
      type: AppointmentType.values.firstWhere(
        (e) => e.toString() == json['type'],
        orElse: () => AppointmentType.inPerson,
      ),
      status: AppointmentStatus.values.firstWhere(
        (e) => e.toString() == json['status'],
        orElse: () => AppointmentStatus.scheduled,
      ),
      notes: json['notes'] as String?,
      sendReminder: json['sendReminder'] as bool,
      createdAt: (json['createdAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'patientId': patientId,
      'therapistId': therapistId,
      'dateTime': Timestamp.fromDate(dateTime),
      'durationMinutes': durationMinutes,
      'type': type.toString(),
      'status': status.toString(),
      'notes': notes,
      'sendReminder': sendReminder,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  Appointment copyWith({
    String? id,
    String? patientId,
    String? therapistId,
    DateTime? dateTime,
    int? durationMinutes,
    AppointmentType? type,
    AppointmentStatus? status,
    String? notes,
    bool? sendReminder,
    DateTime? createdAt,
  }) {
    return Appointment(
      id: id ?? this.id,
      patientId: patientId ?? this.patientId,
      therapistId: therapistId ?? this.therapistId,
      dateTime: dateTime ?? this.dateTime,
      durationMinutes: durationMinutes ?? this.durationMinutes,
      type: type ?? this.type,
      status: status ?? this.status,
      notes: notes ?? this.notes,
      sendReminder: sendReminder ?? this.sendReminder,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
