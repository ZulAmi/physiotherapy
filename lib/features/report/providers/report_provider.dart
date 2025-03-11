import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/report_model.dart';

class ReportProvider with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<Report> _reports = [];
  bool _isLoading = false;
  String? _error;

  bool get isLoading => _isLoading;
  String? get error => _error;
  List<Report> get reports => _reports;

  Future<String> generatePatientReport(String patientId) async {
    _setLoading(true);
    try {
      // Create a new report entry in Firestore
      final reportRef = await _firestore.collection('reports').add({
        'patientId': patientId,
        'generatedAt': Timestamp.now(),
        'type': 'comprehensive',
        'status': 'processing',
      });

      // This would trigger a cloud function in a real app
      // to generate the report asynchronously
      
      // We'll simulate the processing and update the status
      await Future.delayed(const Duration(seconds: 1));
      
      // Update the report status to completed
      await reportRef.update({
        'status': 'completed',
        'downloadUrl': 'https://example.com/reports/$patientId.pdf',
      });
      
      // Return the download URL
      return 'https://example.com/reports/$patientId.pdf';
    } catch (e) {
      _setError('Failed to generate report: $e');
      throw Exception('Failed to generate report: $e');
    } finally {
      _setLoading(false);
    }
  }

  Future<void> loadPatientReports(String patientId) async {
    _setLoading(true);
    try {
      final snapshot = await _firestore// filepath: j:\Programming\FlutterProject\physioflow\lib\features\report\providers\report_provider.dart
import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/report_model.dart';

class ReportProvider with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<Report> _reports = [];
  bool _isLoading = false;
  String? _error;

  bool get isLoading => _isLoading;
  String? get error => _error;
  List<Report> get reports => _reports;

  Future<String> generatePatientReport(String patientId) async {
    _setLoading(true);
    try {
      // Create a new report entry in Firestore
      final reportRef = await _firestore.collection('reports').add({
        'patientId': patientId,
        'generatedAt': Timestamp.now(),
        'type': 'comprehensive',
        'status': 'processing',
      });

      // This would trigger a cloud function in a real app
      // to generate the report asynchronously
      
      // We'll simulate the processing and update the status
      await Future.delayed(const Duration(seconds: 1));
      
      // Update the report status to completed
      await reportRef.update({
        'status': 'completed',
        'downloadUrl': 'https://example.com/reports/$patientId.pdf',
      });
      
      // Return the download URL
      return 'https://example.com/reports/$patientId.pdf';
    } catch (e) {
      _setError('Failed to generate report: $e');
      throw Exception('Failed to generate report: $e');
    } finally {
      _setLoading(false);
    }
  }

  Future<void> loadPatientReports(String patientId) async {
    _setLoading(true);
    try {
      final snapshot = await _firestore