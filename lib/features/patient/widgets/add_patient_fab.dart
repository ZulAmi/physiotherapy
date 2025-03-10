import 'package:flutter/material.dart';
import '../screens/add_patient_screen.dart';

class AddPatientFAB extends StatefulWidget {
  const AddPatientFAB({super.key});

  @override
  State<AddPatientFAB> createState() => _AddPatientFABState();
}

class _AddPatientFABState extends State<AddPatientFAB>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        _buildSpeedDialChild(
          tooltip: 'Import Patient Records',
          icon: Icons.file_upload,
          onTap: () => _handleImportPatient(context),
          visible: _isExpanded,
        ),
        _buildSpeedDialChild(
          tooltip: 'Quick Add Patient',
          icon: Icons.person_add,
          onTap: () => _handleQuickAdd(context),
          visible: _isExpanded,
        ),
        FloatingActionButton.extended(
          onPressed: () => _handleAddPatient(context),
          icon: const Icon(Icons.add),
          label: const Text('Add Patient'),
          tooltip: 'Add New Patient',
        ),
      ],
    );
  }

  Widget _buildSpeedDialChild({
    required String tooltip,
    required IconData icon,
    required VoidCallback onTap,
    required bool visible,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (visible)
            ScaleTransition(
              scale: _controller,
              child: Card(
                color: Theme.of(context).primaryColor.withOpacity(0.9),
                child: InkWell(
                  onTap: onTap,
                  borderRadius: BorderRadius.circular(16),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    child: Row(
                      children: [
                        Icon(icon, color: Colors.white, size: 20),
                        const SizedBox(width: 8),
                        Text(
                          tooltip,
                          style: const TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  void _handleAddPatient(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const AddPatientScreen(
          isQuickAdd: false,
        ),
      ),
    );
  }

  void _handleQuickAdd(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const AddPatientScreen(
          isQuickAdd: true,
        ),
      ),
    );
  }

  void _handleImportPatient(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => const ImportPatientSheet(),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

class ImportPatientSheet extends StatelessWidget {
  const ImportPatientSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Import Patient Records',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 16),
          ListTile(
            leading: const Icon(Icons.file_copy),
            title: const Text('Import from CSV'),
            onTap: () {
              // Handle CSV import
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.cloud_upload),
            title: const Text('Import from EMR'),
            subtitle: const Text('Electronic Medical Records'),
            onTap: () {
              // Handle EMR import
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}
