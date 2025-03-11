import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/exercise_provider.dart';
import '../models/exercise_model.dart';
import '../../patient/providers/patient_provider.dart';
import '../../shared/widgets/custom_text_field.dart';

class AssignExerciseScreen extends StatefulWidget {
  final String patientId;

  const AssignExerciseScreen({
    super.key,
    required this.patientId,
  });

  @override
  State<AssignExerciseScreen> createState() => _AssignExerciseScreenState();
}

class _AssignExerciseScreenState extends State<AssignExerciseScreen> {
  final _searchController = TextEditingController();
  final List<Exercise> _selectedExercises = [];
  bool _isLoading = true;
  String? _searchQuery;
  String? _categoryFilter;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    try {
      await Future.wait([
        context.read<PatientProvider>().selectPatient(widget.patientId),
        context.read<ExerciseProvider>().loadExercises(),
      ]);

      // Get already assigned exercises
      final patient = context.read<PatientProvider>().selectedPatient;
      if (patient != null && patient.prescribedExercises.isNotEmpty) {
        final exercises = context.read<ExerciseProvider>().exercises;
        _selectedExercises.addAll(
          exercises.where((e) => patient.prescribedExercises.contains(e.id)),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading data: $e')),
        );
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Assign Exercises'),
        actions: [
          TextButton.icon(
            onPressed: _saveAssignedExercises,
            icon: const Icon(Icons.save),
            label: const Text('Save'),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                _buildPatientHeader(),
                _buildSearchAndFilters(),
                _buildExerciseList(),
                if (_selectedExercises.isNotEmpty) _buildSelectedExercises(),
              ],
            ),
    );
  }

  Widget _buildPatientHeader() {
    final patient = context.read<PatientProvider>().selectedPatient;
    if (patient == null) return const SizedBox();

    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: Theme.of(context).primaryColor,
              child: Text(patient.name[0].toUpperCase()),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    patient.name,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  Text(
                    'Assigning exercises for this patient',
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

  Widget _buildSearchAndFilters() {
    final categories = context.read<ExerciseProvider>().categories;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
      child: Column(
        children: [
          CustomTextField(
            controller: _searchController,
            label: '',
            hint: 'Search exercises',
            icon: Icons.search,
            onChanged: (value) {
              setState(() {
                _searchQuery = value.isNotEmpty ? value.toLowerCase() : null;
              });
            },
          ),
          const SizedBox(height: 8),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                FilterChip(
                  label: const Text('All'),
                  selected: _categoryFilter == null,
                  onSelected: (selected) {
                    if (selected) {
                      setState(() => _categoryFilter = null);
                    }
                  },
                ),
                const SizedBox(width: 8),
                ...categories.map(
                  (category) => Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: FilterChip(
                      label: Text(category),
                      selected: _categoryFilter == category,
                      onSelected: (selected) {
                        setState(() {
                          _categoryFilter = selected ? category : null;
                        });
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExerciseList() {
    final exercises = context.read<ExerciseProvider>().exercises;
    final filteredExercises = exercises.where((exercise) {
      // Apply search filter
      if (_searchQuery != null &&
          !exercise.name.toLowerCase().contains(_searchQuery!) &&
          !exercise.description.toLowerCase().contains(_searchQuery!)) {
        return false;
      }

      // Apply category filter
      if (_categoryFilter != null && exercise.category != _categoryFilter) {
        return false;
      }

      return true;
    }).toList();

    return Expanded(
      child: filteredExercises.isEmpty
          ? const Center(child: Text('No exercises found'))
          : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: filteredExercises.length,
              separatorBuilder: (_, __) => const Divider(),
              itemBuilder: (context, index) {
                final exercise = filteredExercises[index];
                final isSelected = _selectedExercises
                    .any((selected) => selected.id == exercise.id);

                return ListTile(
                  leading: CircleAvatar(
                    backgroundColor:
                        Theme.of(context).primaryColor.withOpacity(0.1),
                    child: Icon(
                      Icons.fitness_center,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  title: Text(exercise.name),
                  subtitle: Text(
                    '${exercise.category} • ${exercise.difficulty}',
                    style: TextStyle(color: Colors.grey.shade600),
                  ),
                  trailing: IconButton(
                    icon: Icon(
                      isSelected
                          ? Icons.check_circle
                          : Icons.add_circle_outline,
                      color: isSelected ? Colors.green : null,
                    ),
                    onPressed: () {
                      setState(() {
                        if (isSelected) {
                          _selectedExercises.removeWhere(
                            (e) => e.id == exercise.id,
                          );
                        } else {
                          _selectedExercises.add(exercise);
                        }
                      });
                    },
                  ),
                  onTap: () {
                    _showExerciseDetailDialog(exercise);
                  },
                );
              },
            ),
    );
  }

  Widget _buildSelectedExercises() {
    return Container(
      color: Theme.of(context).primaryColor.withOpacity(0.05),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Selected Exercises (${_selectedExercises.length})',
                style: Theme.of(context).textTheme.titleSmall,
              ),
              TextButton(
                onPressed: () {
                  setState(() => _selectedExercises.clear());
                },
                child: const Text('Clear All'),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _selectedExercises
                .map(
                  (exercise) => Chip(
                    label: Text(exercise.name),
                    deleteIcon: const Icon(Icons.cancel, size: 18),
                    onDeleted: () {
                      setState(() {
                        _selectedExercises.removeWhere(
                          (e) => e.id == exercise.id,
                        );
                      });
                    },
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }

  void _showExerciseDetailDialog(Exercise exercise) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(exercise.name),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 150,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Icon(
                  Icons.fitness_center,
                  size: 48,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text('Category: ${exercise.category}'),
            Text('Difficulty: ${exercise.difficulty}'),
            const SizedBox(height: 8),
            Text(exercise.description),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  Future<void> _saveAssignedExercises() async {
    if (_selectedExercises.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select at least one exercise')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final exerciseIds = _selectedExercises.map((e) => e.id).toList();
      await context.read<PatientProvider>().assignExercises(
            widget.patientId,
            exerciseIds,
          );

      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Exercises assigned successfully')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error assigning exercises: $e')),
        );
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
