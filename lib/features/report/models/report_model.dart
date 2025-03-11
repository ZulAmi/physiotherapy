import 'package:cloud_firestore/cloud_firestore.dart';

enum ReportType { comprehensive, progress, assessment, discharge }

enum ReportStatus { processing, completed, failed }

class Report {
  final String id;
  final String patientId;
  final DateTime generatedAt;
  final ReportType type;
  final ReportStatus status;
  final String? downloadUrl;
  final String? errorMessage;

  const Report({
    required this.id,
    required this.patientId,
    required this.generatedAt,
    required this.type,
    required this.status,
    this.downloadUrl,
    this.errorMessage,
  });

  factory Report.fromJson(Map<String, dynamic> json) {
    return Report(
      id: json['id'] as String,
      patientId: json['patientId'] as String,
      generatedAt: (json['generatedAt'] as Timestamp).toDate(),
      type: _parseReportType(json['type'] as String),
      status: _parseReportStatus(json['status'] as String),
      downloadUrl: json['downloadUrl'] as String?,
      errorMessage: json['errorMessage'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'patientId': patientId,
      'generatedAt': Timestamp.fromDate(generatedAt),
      'type': type.toString().split('.').last,
      'status': status.toString().split('.').last,
      'downloadUrl': downloadUrl,
      'errorMessage': errorMessage,
    };
  }

  static ReportType _parseReportType(String type) {
    switch (type) {
      case 'comprehensive':
        return ReportType.comprehensive;
      case 'progress':
        return ReportType.progress;
      case 'assessment':
        return ReportType.assessment;
      case 'discharge':
        return ReportType.discharge;
      default:
        return ReportType.comprehensive;
    }
  }

  static ReportStatus _parseReportStatus(String status) {
    switch (status) {
      case 'processing':
        return ReportStatus.processing;
      case 'completed':
        return ReportStatus.completed;
      case 'failed':
        return ReportStatus.failed;
      default:
        return ReportStatus.processing;
    }
  }
}
