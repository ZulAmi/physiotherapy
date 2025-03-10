import 'package:flutter/material.dart';
import '../models/patient_model.dart';

class PatientFilterBar extends StatelessWidget {
  final TextEditingController searchController;
  final PatientStatus? statusFilter;
  final ValueChanged<PatientStatus?> onStatusChanged;
  final ValueChanged<String> onSearch;

  const PatientFilterBar({
    super.key,
    required this.searchController,
    required this.statusFilter,
    required this.onStatusChanged,
    required this.onSearch,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: 'Search patients...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onChanged: onSearch,
            ),
            const SizedBox(height: 8),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  FilterChip(
                    label: const Text('All'),
                    selected: statusFilter == null,
                    onSelected: (selected) {
                      if (selected) onStatusChanged(null);
                    },
                  ),
                  const SizedBox(width: 8),
                  ...PatientStatus.values.map(
                    (status) => FilterChip(
                      label: Text(status.name),
                      selected: statusFilter == status,
                      onSelected: (selected) {
                        onStatusChanged(selected ? status : null);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
