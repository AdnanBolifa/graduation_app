import 'package:flutter/material.dart';
import 'package:jwt_auth/services/auth_service.dart';
import 'package:jwt_auth/widgets/inhert.dart';

class SettingsPage extends StatefulWidget {
  final Function(String) updateDataset;
  const SettingsPage({super.key, required this.updateDataset});

  @override
  SettingsPageState createState() => SettingsPageState();
}

class SettingsPageState extends State<SettingsPage> {
  String? _selectedDataset;
  bool _notificationsEnabled = true; // Example setting
  bool _darkMode = false; // Dark mode setting
  String _language = 'English'; // Language setting

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _selectedDataset ??=
        SettingsProvider.of(context)?.selectedDataset ?? 'Basic';
  }

  void _selectDataset(String dataset) {
    setState(() {
      _selectedDataset = dataset;
    });
    widget.updateDataset(dataset);
  }

  // Method to handle logout
  void _logout() {
    AuthService().logout();
    Navigator.pushNamed(context, '/login'); // Go back to the previous screen
  }

  // Method to toggle notifications
  void _toggleNotifications(bool value) {
    setState(() {
      _notificationsEnabled = value;
    });
    // Save the notification setting preference
  }

  // Method to toggle dark mode
  void _toggleDarkMode(bool value) {
    setState(() {
      _darkMode = value;
    });
    // Save the dark mode setting preference
  }

  // Method to select language
  void _selectLanguage(String language) {
    setState(() {
      _language = language;
    });
    // Save the selected language preference
  }

  void _showDatasetBottomSheet() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: const Text('Complex Dataset'),
                onTap: () {
                  _selectDataset('complex');
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: const Text('Basic Dataset'),
                onTap: () {
                  _selectDataset('Basic');
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            // Dataset Selection with BottomSheet
            ListTile(
              contentPadding: const EdgeInsets.symmetric(vertical: 12.0),
              title: const Text(
                'Select Diabetes Dataset',
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
              subtitle: Text('Current: ${_selectedDataset ?? 'Basic'}'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: _showDatasetBottomSheet,
            ),
            const Divider(),
            // Notifications Toggle
            SwitchListTile(
              title: const Text('Enable Notifications'),
              subtitle: const Text(
                  'Receive notifications about health tips and updates.'),
              value: _notificationsEnabled,
              onChanged: _toggleNotifications,
              activeColor: Colors.blueAccent,
            ),
            const Divider(),
            // Dark Mode Toggle
            SwitchListTile(
              title: const Text('Dark Mode'),
              subtitle: const Text(
                  'Enable dark mode for better visibility at night.'),
              value: _darkMode,
              onChanged: _toggleDarkMode,
              activeColor: Colors.blueAccent,
            ),
            const Divider(),
            // Language Selection
            ListTile(
              title: const Text('Language'),
              subtitle: Text('Current language: $_language'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('Choose Language'),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ListTile(
                            title: const Text('Arabic'),
                            onTap: () {
                              _selectLanguage('Arabic');
                              Navigator.pop(context);
                            },
                          ),
                          ListTile(
                            title: const Text('English'),
                            onTap: () {
                              _selectLanguage('English');
                              Navigator.pop(context);
                            },
                          ),
                          ListTile(
                            title: const Text('Spanish'),
                            onTap: () {
                              _selectLanguage('Spanish');
                              Navigator.pop(context);
                            },
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
            const Divider(),
            // About Section
            const Divider(),
            // Privacy Policy Section
            ListTile(
              title: const Text('Privacy Policy'),
              subtitle:
                  const Text('Read our privacy policy and terms of service.'),
              trailing: const Icon(Icons.lock),
              onTap: () {
                // Navigate to privacy policy page or show policy
              },
            ),
            ListTile(
              title: const Text('About'),
              subtitle:
                  const Text('Learn more about this app and its features.'),
              trailing: const Icon(Icons.info_outline),
              onTap: () {
                // Navigate to about page or show info
              },
            ),
            const Divider(),
            // Logout Button
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _logout,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                padding: const EdgeInsets.symmetric(vertical: 15.0),
                textStyle: const TextStyle(
                    fontSize: 16.0, fontWeight: FontWeight.bold),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
              ),
              child: const Text(
                'Logout',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
