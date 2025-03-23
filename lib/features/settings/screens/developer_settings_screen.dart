// lib/features/settings/screens/developer_settings_screen.dart
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LlamaSettingsScreen extends StatefulWidget {
  const LlamaSettingsScreen({super.key});

  @override
  State<LlamaSettingsScreen> createState() => _LlamaSettingsScreenState();
}

class _LlamaSettingsScreenState extends State<LlamaSettingsScreen> {
  final _formKey = GlobalKey<FormState>();
  final _serverController = TextEditingController();
  bool _isLocalMode = true;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _serverController.text =
          prefs.getString('llama_server_url') ?? 'http://localhost:8000';
      _isLocalMode = prefs.getBool('llama_local_mode') ?? true;
    });
  }

  Future<void> _saveSettings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('llama_server_url', _serverController.text);
    await prefs.setBool('llama_local_mode', _isLocalMode);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Settings saved')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Me-LLaMA Settings'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            SwitchListTile(
              title: const Text('Use Local Mode'),
              subtitle: const Text(
                  'Run model on device (requires more storage space)'),
              value: _isLocalMode,
              onChanged: (value) {
                setState(() {
                  _isLocalMode = value;
                });
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _serverController,
              decoration: const InputDecoration(
                labelText: 'Server URL',
                hintText: 'http://your-server:8000',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter server URL';
                }
                if (!value.startsWith('http://') &&
                    !value.startsWith('https://')) {
                  return 'URL must start with http:// or https://';
                }
                return null;
              },
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  _saveSettings();
                }
              },
              child: const Text('Save Settings'),
            ),
          ],
        ),
      ),
    );
  }
}
