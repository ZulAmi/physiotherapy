import 'dart:convert';
import 'package:http/http.dart' as http;

class LlamaService {
  final String baseUrl;

  LlamaService({required this.baseUrl});

  Future<String> generateFeedback(
      String exerciseName, Map<String, double> angles) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/generate'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'prompt':
              'Provide feedback for $exerciseName exercise with joint angles: $angles',
          'max_tokens': 150,
          'temperature': 0.7
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['generated_text'];
      } else {
        throw Exception('Failed to generate feedback: ${response.body}');
      }
    } catch (e) {
      return 'Unable to generate feedback: $e';
    }
  }

  Future<String> analyzeExerciseForm(
      String exerciseName,
      Map<String, double> currentAngles,
      Map<String, double> targetAngles) async {
    try {
      final prompt = '''
      Exercise: $exerciseName
      Current joint angles: $currentAngles
      Target joint angles: $targetAngles
      
      Analyze form and provide corrective feedback:
      ''';

      final response = await http.post(
        Uri.parse('$baseUrl/analyze_exercise'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'prompt': prompt,
          'max_tokens': 200,
          'temperature': 0.3 // Lower temperature for more precise feedback
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['analysis'];
      } else {
        throw Exception('Failed to analyze exercise: ${response.body}');
      }
    } catch (e) {
      return 'Unable to analyze exercise form: $e';
    }
  }
}
