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
  bool _isLoading = true;
  List<Exercise> _selectedExercises = [];
  final _searchController = TextEditingController();
  String _searchQuery = '';
  ExerciseCategory? _selectedCategory;

  @override
  void initState() {
    super.initState();
    // Use postFrameCallback to ensure the widget is fully built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadData();
    });
  }

  Future<void> _loadData() async {
    if (!mounted) return;

    setState(() => _isLoading = true);

    try {
      final patientProvider =
          Provider.of<PatientProvider>(context, listen: false);
      final exerciseProvider =
          Provider.of<ExerciseProvider>(context, listen: false);

      // First load the patient and exercise library
      await Future.wait([
        patientProvider.selectPatient(widget.patientId),
        exerciseProvider.loadExercises(),
      ]);

      // Then load patient-specific exercises (which may depend on the exercise library)
      await exerciseProvider.loadPatientExercises(widget.patientId);

      // Make sure the widget is still mounted after all async operations
      if (!mounted) return;

      // Get the patient's exercises - place it HERE, after loading and before setState
      final assignedExercises =
          exerciseProvider.getPatientExercises(widget.patientId);

      setState(() {
        _selectedExercises = List.from(assignedExercises);
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading data: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Assign Exercises'),
        actions: [
          TextButton.icon(
            onPressed: _isLoading ? null : _saveAssignedExercises,
            icon: const Icon(Icons.check),
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
                Expanded(
                  child: _buildExerciseList(),
                ),
              ],
            ),
    );
  }

  Widget _buildPatientHeader() {
    final patient = Provider.of<PatientProvider>(context).selectedPatient;
    if (patient == null) return const SizedBox();

    return Container(
      padding: const EdgeInsets.all(16),
      color: Theme.of(context).primaryColor.withOpacity(0.1),
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
                  'Assigning exercises for this patient',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 6,
            ),
            decoration: BoxDecoration(
              color: Colors.green.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.green.withOpacity(0.5)),
            ),
            child: Text(
              '${_selectedExercises.length} selected',
              style: const TextStyle(
                color: Colors.green,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchAndFilters() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomTextField(
            controller: _searchController,
            label: '',
            hint: 'Search exercises...',
            icon: Icons.search,
            onChanged: (value) {
              setState(() {
                _searchQuery = value;
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
                  selected: _selectedCategory == null,
                  onSelected: (selected) {
                    if (selected) {
                      setState(() {
                        _selectedCategory = null;
                      });
                    }
                  },
                ),
                const SizedBox(width: 8),
                ...ExerciseCategory.values.map(
                  (category) => Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: FilterChip(
                      label: Text(category.toString().split('.').last),
                      selected: _selectedCategory == category,
                      onSelected: (selected) {
                        setState(() {
                          _selectedCategory = selected ? category : null;
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
    final exerciseProvider = Provider.of<ExerciseProvider>(context);
    final allExercises = exerciseProvider.exercises;

    // Apply filters
    final filteredExercises = allExercises.where((exercise) {
      bool matchesSearch = _searchQuery.isEmpty ||
          exercise.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          exercise.description
              .toLowerCase()
              .contains(_searchQuery.toLowerCase());

      bool matchesCategory =
          _selectedCategory == null || exercise.category == _selectedCategory;

      return matchesSearch && matchesCategory;
    }).toList();

    if (filteredExercises.isEmpty) {
      return const Center(
        child: Text('No exercises found matching your criteria'),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: filteredExercises.length,
      itemBuilder: (context, index) {
        final exercise = filteredExercises[index];
        final isSelected = _selectedExercises.any((e) => e.id == exercise.id);

        return _buildExerciseCard(exercise, isSelected);
      },
    );
  }

  Widget _buildExerciseCard(Exercise exercise, bool isSelected) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color:
              isSelected ? Theme.of(context).primaryColor : Colors.transparent,
          width: isSelected ? 2 : 0,
        ),
      ),
      child: InkWell(
        onTap: () {
          setState(() {
            if (isSelected) {
              _selectedExercises.removeWhere((e) => e.id == exercise.id);
            } else {
              _selectedExercises.add(exercise);
            }
          });
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  exercise.imageUrl ?? 'https://via.placeholder.com/80',
                  width: 80,
                  height: 80,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    width: 80,
                    height: 80,
                    color: Colors.grey[200],
                    child: Icon(
                      Icons.fitness_center,
                      color: Colors.grey[500],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            exercise.name,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Checkbox(
                          value: isSelected,
                          onChanged: (_) {
                            setState(() {
                              if (isSelected) {
                                _selectedExercises
                                    .removeWhere((e) => e.id == exercise.id);
                              } else {
                                _selectedExercises.add(exercise);
                              }
                            });
                          },
                        ),
                      ],
                    ),
                    Text(
                      exercise.description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Chip(
                          label: Text(
                            exercise.category.toString().split('.').last,
                            style: const TextStyle(fontSize: 12),
                          ),
                          backgroundColor:
                              Theme.of(context).primaryColor.withOpacity(0.1),
                          padding: EdgeInsets.zero,
                          labelPadding:
                              const EdgeInsets.symmetric(horizontal: 8),
                        ),
                        const SizedBox(width: 8),
                        Chip(
                          label: Text(
                            '${exercise.difficulty}/5 difficulty',
                            style: const TextStyle(fontSize: 12),
                          ),
                          backgroundColor: Colors.orange.withOpacity(0.1),
                          padding: EdgeInsets.zero,
                          labelPadding:
                              const EdgeInsets.symmetric(horizontal: 8),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _saveAssignedExercises() async {
    setState(() => _isLoading = true);

    try {
      await Provider.of<ExerciseProvider>(context, listen: false)
          .assignExercisesToPatient(widget.patientId, _selectedExercises);

      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Exercises assigned successfully'),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error assigning exercises: $e')),
      );
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
