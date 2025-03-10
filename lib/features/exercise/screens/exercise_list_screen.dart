import 'package:flutter/material.dart';
import '../models/exercise_model.dart';
import './exercise_detail_screen.dart';

class ExerciseListScreen extends StatelessWidget {
  const ExerciseListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Physiotherapy Exercises')),
      body: ListView.builder(
        itemCount: dummyExercises.length,
        itemBuilder: (context, index) {
          final exercise = dummyExercises[index];
          return ExerciseCard(exercise: exercise);
        },
      ),
    );
  }
}

class ExerciseCard extends StatelessWidget {
  final Exercise exercise;

  const ExerciseCard({super.key, required this.exercise});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8.0),
      child: ListTile(
        leading: Icon(Icons.fitness_center),
        title: Text(exercise.name),
        subtitle: Text(exercise.description),
        onTap:
            () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ExerciseDetailScreen(exercise: exercise),
              ),
            ),
      ),
    );
  }
}
