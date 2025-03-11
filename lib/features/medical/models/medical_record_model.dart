import 'package:cloud_firestore/cloud_firestore.dart';

class MedicalRecord {
  final String id;
  final String patientId;
  final String therapistId;
  final String title;
  final String description;
  final String recordType;
  final DateTime date;
  final List<String> attachments;
  final DateTime createdAt;
  final DateTime? updatedAt;

  const MedicalRecord({
    required this.id,
    required this.patientId,
    required this.therapistId,
    required this.title,
    required this.description,
    required this.recordType,
    required this.date,
    required this.attachments,
    required this.createdAt,
    this.updatedAt,
  });

  factory MedicalRecord.fromJson(Map<String, dynamic> json) {
    return MedicalRecord(
      id: json['id'] as String,
      patientId: json['patientId'] as String,
      therapistId: json['therapistId'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      recordType: json['recordType'] as String,
      date: (json['date'] as Timestamp).toDate(),
      attachments: List<String>.from(json['attachments'] ?? []),
      createdAt: (json['createdAt'] as Timestamp).toDate(),
      updatedAt: json['updatedAt'] != null
          ? (json['updatedAt'] as Timestamp).toDate()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'patientId': patientId,
      'therapistId': therapistId,
      'title': title,
      'description': description,
      'recordType': recordType,
      'date': Timestamp.fromDate(date),
      'attachments': attachments,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': updatedAt != null ? Timestamp.fromDate(updatedAt!) : null,
    };
  }

  MedicalRecord copyWith({
    String? id,
    String? patientId,
    String? therapistId,
    String? title,
    String? description,
    String? recordType,
    DateTime? date,
    List<String>? attachments,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return MedicalRecord(
      id: id ?? this.id,
      patientId: patientId ?? this.patientId,
      therapistId: therapistId ?? this.therapistId,
      title: title ?? this.title,
      description: description ?? this.description,
      recordType: recordType ?? this.recordType,
      date: date ?? this.date,
      attachments: attachments ?? this.attachments,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
