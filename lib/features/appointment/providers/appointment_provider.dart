import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/appointment_model.dart';

class AppointmentProvider with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<Appointment> _appointments = [];
  bool _isLoading = false;
  String? _error;

  bool get isLoading => _isLoading;
  String? get error => _error;
  List<Appointment> get appointments => _appointments;

  Future<void> loadAppointmentsByTherapist(String therapistId) async {
    _setLoading(true);
    try {
      final snapshot = await _firestore
          .collection('appointments')
          .where('therapistId', isEqualTo: therapistId)
          .orderBy('dateTime')
          .get();

      _appointments = snapshot.docs
          .map((doc) => Appointment.fromJson({'id': doc.id, ...doc.data()}))
          .toList();

      notifyListeners();
    } catch (e) {
      _setError('Failed to load appointments: $e');
    } finally {
      _setLoading(false);
    }
  }

  Future<void> loadAppointmentsByPatient(String patientId) async {
    _setLoading(true);
    try {
      final snapshot = await _firestore
          .collection('appointments')
          .where('patientId', isEqualTo: patientId)
          .orderBy('dateTime')
          .get();

      _appointments = snapshot.docs
          .map((doc) => Appointment.fromJson({'id': doc.id, ...doc.data()}))
          .toList();

      notifyListeners();
    } catch (e) {
      _setError('Failed to load appointments: $e');
    } finally {
      _setLoading(false);
    }
  }

  Future<Appointment> createAppointment(Appointment appointment) async {
    try {
      final docRef =
          await _firestore.collection('appointments').add(appointment.toJson());

      final newAppointment = appointment.copyWith(id: docRef.id);
      _appointments.add(newAppointment);
      notifyListeners();
      return newAppointment;
    } catch (e) {
      _setError('Failed to create appointment: $e');
      throw Exception('Failed to create appointment: $e');
    }
  }

  Future<void> updateAppointment(Appointment appointment) async {
    try {
      await _firestore
          .collection('appointments')
          .doc(appointment.id)
          .update(appointment.toJson());

      final index = _appointments.indexWhere((a) => a.id == appointment.id);
      if (index != -1) {
        _appointments[index] = appointment;
        notifyListeners();
      }
    } catch (e) {
      _setError('Failed to update appointment: $e');
      throw Exception('Failed to update appointment: $e');
    }
  }

  Future<void> cancelAppointment(String appointmentId) async {
    try {
      final index = _appointments.indexWhere((a) => a.id == appointmentId);
      if (index != -1) {
        final appointment = _appointments[index];
        final updatedAppointment = appointment.copyWith(
          status: AppointmentStatus.cancelled,
        );

        await _firestore
            .collection('appointments')
            .doc(appointmentId)
            .update({'status': AppointmentStatus.cancelled.toString()});

        _appointments[index] = updatedAppointment;
        notifyListeners();
      }
    } catch (e) {
      _setError('Failed to cancel appointment: $e');
      throw Exception('Failed to cancel appointment: $e');
    }
  }

  void _setLoading(bool isLoading) {
    _isLoading = isLoading;
    notifyListeners();
  }

  void _setError(String? error) {
    _error = error;
    notifyListeners();
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}
