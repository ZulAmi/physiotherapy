import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/appointment_provider.dart';
import '../models/appointment_model.dart';
import '../../patient/providers/patient_provider.dart';
import '../../shared/widgets/custom_text_field.dart';
import '../../shared/widgets/date_picker_field.dart';

class AppointmentBookingScreen extends StatefulWidget {
  final String patientId;
  final Appointment? existingAppointment;

  const AppointmentBookingScreen({
    super.key,
    required this.patientId,
    this.existingAppointment,
  });

  @override
  State<AppointmentBookingScreen> createState() =>
      _AppointmentBookingScreenState();
}

class _AppointmentBookingScreenState extends State<AppointmentBookingScreen> {
  final _formKey = GlobalKey<FormState>();
  DateTime? _date;
  TimeOfDay? _time;
  AppointmentType _appointmentType = AppointmentType.inPerson;
  int _durationMinutes = 30;
  final _notesController = TextEditingController();
  bool _sendReminder = true;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadPatientData();

    // Pre-fill form if editing an existing appointment
    if (widget.existingAppointment != null) {
      final appointment = widget.existingAppointment!;
      _date = appointment.dateTime;
      _time = TimeOfDay.fromDateTime(appointment.dateTime);
      _appointmentType = appointment.type;
      _durationMinutes = appointment.durationMinutes;
      _notesController.text = appointment.notes ?? '';
      _sendReminder = appointment.sendReminder;
    } else {
      // Default time for new appointment is 9:00 AM tomorrow
      _date = DateTime.now().add(const Duration(days: 1));
      _time = const TimeOfDay(hour: 9, minute: 0);
    }
  }

  Future<void> _loadPatientData() async {
    try {
      await context.read<PatientProvider>().selectPatient(widget.patientId);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading patient data: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.existingAppointment == null
            ? 'Schedule Appointment'
            : 'Edit Appointment'),
        actions: [
          TextButton.icon(
            onPressed: _isLoading ? null : _submitForm,
            icon: const Icon(Icons.save),
            label: const Text('Save'),
          ),
        ],
      ),
      body: Consumer<PatientProvider>(
        builder: (context, provider, child) {
          final patient = provider.selectedPatient;

          return Form(
            key: _formKey,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (patient != null) _buildPatientHeader(patient),
                  const SizedBox(height: 20),
                  _buildAppointmentDetailsCard(),
                  const SizedBox(height: 16),
                  _buildAppointmentOptionsCard(),
                  const SizedBox(height: 24),
                  _buildSubmitButton(),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildPatientHeader(patient) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            CircleAvatar(
              radius: 24,
              backgroundColor: Theme.of(context).primaryColor,
              child: Text(
                patient.name.substring(0, 1).toUpperCase(),
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    patient.name,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  Text(
                    'Scheduling appointment for this patient',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppointmentDetailsCard() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Appointment Details',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: DatePickerField(
                    label: 'Date',
                    selectedDate: _date,
                    isRequired: true,
                    firstDate: DateTime.now(),
                    onDateSelected: (date) => setState(() => _date = date),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildTimeSelector(),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildAppointmentTypeSelector(),
            const SizedBox(height: 16),
            _buildDurationSelector(),
            const SizedBox(height: 16),
            CustomTextField(
              controller: _notesController,
              label: 'Notes',
              hint: 'Add any notes or special instructions',
              icon: Icons.note,
              maxLines: 3,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeSelector() {
    final timeString = _time != null
        ? '${_time!.hour.toString().padLeft(2, '0')}:${_time!.minute.toString().padLeft(2, '0')}'
        : '';

    return CustomTextField(
      label: 'Time',
      isRequired: true,
      readOnly: true,
      controller: TextEditingController(text: timeString),
      icon: Icons.access_time,
      onTap: () async {
        final pickedTime = await showTimePicker(
          context: context,
          initialTime: _time ?? TimeOfDay.now(),
        );
        if (pickedTime != null) {
          setState(() {
            _time = pickedTime;
          });
        }
      },
      validator: (value) {
        if (_time == null) {
          return 'Please select a time';
        }
        return null;
      },
    );
  }

  Widget _buildAppointmentTypeSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Appointment Type',
          style: const TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 8),
        SegmentedButton<AppointmentType>(
          segments: const [
            ButtonSegment<AppointmentType>(
              value: AppointmentType.inPerson,
              icon: Icon(Icons.person),
              label: Text('In Person'),
            ),
            ButtonSegment<AppointmentType>(
              value: AppointmentType.video,
              icon: Icon(Icons.video_call),
              label: Text('Video Call'),
            ),
            ButtonSegment<AppointmentType>(
              value: AppointmentType.phone,
              icon: Icon(Icons.phone),
              label: Text('Phone Call'),
            ),
          ],
          selected: {_appointmentType},
          onSelectionChanged: (newSelection) {
            setState(() {
              _appointmentType = newSelection.first;
            });
          },
        ),
      ],
    );
  }

  Widget _buildDurationSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Duration',
          style: const TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<int>(
          value: _durationMinutes,
          decoration: InputDecoration(
            prefixIcon: const Icon(Icons.timer),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          items: [
            DropdownMenuItem(
              value: 15,
              child: const Text('15 minutes'),
            ),
            DropdownMenuItem(
              value: 30,
              child: const Text('30 minutes'),
            ),
            DropdownMenuItem(
              value: 45,
              child: const Text('45 minutes'),
            ),
            DropdownMenuItem(
              value: 60,
              child: const Text('1 hour'),
            ),
            DropdownMenuItem(
              value: 90,
              child: const Text('1.5 hours'),
            ),
          ],
          onChanged: (value) {
            if (value != null) {
              setState(() {
                _durationMinutes = value;
              });
            }
          },
        ),
      ],
    );
  }

  Widget _buildAppointmentOptionsCard() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Options',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            SwitchListTile(
              title: const Text('Send Reminder'),
              subtitle: const Text('Notify patient 24 hours before'),
              value: _sendReminder,
              onChanged: (value) {
                setState(() {
                  _sendReminder = value;
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: _isLoading ? null : _submitForm,
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: _isLoading
            ? const CircularProgressIndicator()
            : const Text(
                'Save Appointment',
                style: TextStyle(fontSize: 16),
              ),
      ),
    );
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate() || _date == null || _time == null) {
      return;
    }

    setState(() => _isLoading = true);

    try {
      // Combine the selected date and time
      final dateTime = DateTime(
        _date!.year,
        _date!.month,
        _date!.day,
        _time!.hour,
        _time!.minute,
      );

      final appointment = Appointment(
        id: widget.existingAppointment?.id ?? '',
        patientId: widget.patientId,
        therapistId:
            context.read<PatientProvider>().selectedPatient!.therapistId,
        dateTime: dateTime,
        durationMinutes: _durationMinutes,
        type: _appointmentType,
        status:
            widget.existingAppointment?.status ?? AppointmentStatus.scheduled,
        notes: _notesController.text.isNotEmpty ? _notesController.text : null,
        sendReminder: _sendReminder,
        createdAt: widget.existingAppointment?.createdAt ?? DateTime.now(),
      );

      if (widget.existingAppointment != null) {
        await context
            .read<AppointmentProvider>()
            .updateAppointment(appointment);
      } else {
        await context
            .read<AppointmentProvider>()
            .createAppointment(appointment);
      }

      if (mounted) {
        Navigator.pop(context, true);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              widget.existingAppointment == null
                  ? 'Appointment scheduled successfully'
                  : 'Appointment updated successfully',
            ),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error saving appointment: $e')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }
}
