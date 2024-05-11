import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:jwt_auth/screens/login.dart';
import 'package:jwt_auth/services/api_service.dart';
import 'package:jwt_auth/services/auth_service.dart';

class HomeScreen extends StatelessWidget {
  final TextEditingController ageController = TextEditingController();
  final TextEditingController sexController = TextEditingController();
  final TextEditingController cpController = TextEditingController();
  final TextEditingController trestbpsController = TextEditingController();
  final TextEditingController cholController = TextEditingController();
  final TextEditingController fbsController = TextEditingController();
  final TextEditingController restecgController = TextEditingController();
  final TextEditingController thalachController = TextEditingController();
  final TextEditingController exangController = TextEditingController();
  final TextEditingController oldpeakController = TextEditingController();
  final TextEditingController slopeController = TextEditingController();
  final TextEditingController caController = TextEditingController();
  final TextEditingController thalController = TextEditingController();

  HomeScreen({Key? key}) : super(key: key);
  void main() {
    runApp(MaterialApp(
      home: HomeScreen(),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Heart Disease Predictor'),
      ),
      endDrawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text(
                'Menu',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.account_circle),
              title: const Text('Profile'),
              onTap: () {
                // Navigate to profile page
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Settings'),
              onTap: () {
                // Navigate to settings page
              },
            ),
            ListTile(
              leading: const Icon(Icons.history),
              title: const Text('History'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/history');
              },
            ),
            ListTile(
              leading: const Icon(Icons.info),
              title: const Text('Logout'),
              onTap: () {
                AuthService().logout();
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => const LoginPage()));
              },
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: HomeForm(
          ageController: ageController,
          sexController: sexController,
          cpController: cpController,
          trestbpsController: trestbpsController,
          cholController: cholController,
          fbsController: fbsController,
          restecgController: restecgController,
          thalachController: thalachController,
          exangController: exangController,
          oldpeakController: oldpeakController,
          slopeController: slopeController,
          caController: caController,
          thalController: thalController,
        ),
      ),
    );
  }
}

class HomeForm extends StatelessWidget {
  final TextEditingController ageController;
  final TextEditingController sexController;
  final TextEditingController cpController;
  final TextEditingController trestbpsController;
  final TextEditingController cholController;
  final TextEditingController fbsController;
  final TextEditingController restecgController;
  final TextEditingController thalachController;
  final TextEditingController exangController;
  final TextEditingController oldpeakController;
  final TextEditingController slopeController;
  final TextEditingController caController;
  final TextEditingController thalController;

  const HomeForm({
    super.key,
    required this.ageController,
    required this.sexController,
    required this.cpController,
    required this.trestbpsController,
    required this.cholController,
    required this.fbsController,
    required this.restecgController,
    required this.thalachController,
    required this.exangController,
    required this.oldpeakController,
    required this.slopeController,
    required this.caController,
    required this.thalController,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        TextField(
          controller: ageController,
          decoration: const InputDecoration(labelText: 'Age'),
          keyboardType: TextInputType.number,
        ),
        TextField(
          controller: sexController,
          decoration: const InputDecoration(labelText: 'Sex'),
          keyboardType: TextInputType.number,
        ),
        TextField(
          controller: cpController,
          decoration: const InputDecoration(labelText: 'Chest Pain Type (cp)'),
          keyboardType: TextInputType.number,
        ),
        TextField(
          controller: trestbpsController,
          decoration: const InputDecoration(
              labelText: 'Resting Blood Pressure (trestbps)'),
          keyboardType: TextInputType.number,
        ),
        TextField(
          controller: cholController,
          decoration:
              const InputDecoration(labelText: 'Serum Cholesterol (chol)'),
          keyboardType: TextInputType.number,
        ),
        TextField(
          controller: fbsController,
          decoration:
              const InputDecoration(labelText: 'Fasting Blood Sugar (fbs)'),
          keyboardType: TextInputType.number,
        ),
        TextField(
          controller: restecgController,
          decoration: const InputDecoration(
              labelText: 'Resting Electrocardiographic Results (restecg)'),
          keyboardType: TextInputType.number,
        ),
        TextField(
          controller: thalachController,
          decoration: const InputDecoration(
              labelText: 'Maximum Heart Rate Achieved (thalach)'),
          keyboardType: TextInputType.number,
        ),
        TextField(
          controller: exangController,
          decoration: const InputDecoration(
              labelText: 'Exercise Induced Angina (exang)'),
          keyboardType: TextInputType.number,
        ),
        TextField(
          controller: oldpeakController,
          decoration: const InputDecoration(
              labelText:
                  'ST Depression Induced by Exercise Relative to Rest (oldpeak)'),
          keyboardType: TextInputType.number,
        ),
        TextField(
          controller: slopeController,
          decoration: const InputDecoration(
              labelText: 'Slope of the Peak Exercise ST Segment (slope)'),
          keyboardType: TextInputType.number,
        ),
        TextField(
          controller: caController,
          decoration: const InputDecoration(
              labelText: 'Number of Major Vessels Colored by Flourosopy (ca)'),
          keyboardType: TextInputType.number,
        ),
        TextField(
          controller: thalController,
          decoration: const InputDecoration(labelText: 'Thalassemia (thal)'),
          keyboardType: TextInputType.number,
        ),
        ElevatedButton(
          onPressed: () async {
            await _submitData(context);
          },
          child: const Text('Submit'),
        ),
      ],
    );
  }

  Future<void> _submitData(BuildContext context) async {
    http.Response response = await ApiService.submitData(
      context,
      ageController,
      sexController,
      cpController,
      trestbpsController,
      cholController,
      fbsController,
      restecgController,
      thalachController,
      exangController,
      oldpeakController,
      slopeController,
      caController,
      thalController,
    );

    if (response.statusCode == 200) {
      int prediction = ApiService.getPrediction(response);
      _showPredictionDialog(context, prediction);
    } else {
      ApiService.handleError(response);
    }
  }

  void _showPredictionDialog(BuildContext context, int prediction) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Prediction'),
          content: Text('Prediction: $prediction'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
