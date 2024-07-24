// ignore_for_file: non_constant_identifier_names
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:jwt_auth/screens/login.dart';
import 'package:jwt_auth/services/api_service.dart';
import 'package:jwt_auth/services/auth_service.dart';
import 'package:jwt_auth/theme/colors.dart';

class HeartScreen extends StatefulWidget {
  const HeartScreen({Key? key}) : super(key: key);

  @override
  State<HeartScreen> createState() => _HeartScreenState();
}

class _HeartScreenState extends State<HeartScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController totCholController = TextEditingController();
  final TextEditingController sysBPController = TextEditingController();
  final TextEditingController diaBPController = TextEditingController();
  final TextEditingController BMIController = TextEditingController();
  final TextEditingController heartRateController = TextEditingController();
  final TextEditingController glucoseController = TextEditingController();
  final TextEditingController cigsPerDayController =
      TextEditingController(text: '0');

  String? sex;
  String? currentSmoker;
  String? BPMeds;
  String? prevalentStroke;
  String? prevalentHyp;
  String? diabetes;

  @override
  void dispose() {
    ageController.dispose();
    cigsPerDayController.dispose();
    totCholController.dispose();
    sysBPController.dispose();
    diaBPController.dispose();
    BMIController.dispose();
    heartRateController.dispose();
    glucoseController.dispose();
    super.dispose();
  }

  Future<void> _submitData(BuildContext context) async {
    http.Response response = await ApiService.submitHeartData(
      context,
      TextEditingController(text: sex),
      nameController,
      ageController,
      TextEditingController(text: currentSmoker),
      cigsPerDayController,
      TextEditingController(text: BPMeds),
      TextEditingController(text: prevalentStroke),
      TextEditingController(text: prevalentHyp),
      TextEditingController(text: diabetes),
      totCholController,
      sysBPController,
      diaBPController,
      BMIController,
      heartRateController,
      glucoseController,
    );
    if (response.statusCode == 200) {
      int prediction = ApiService.getPrediction(response);
      _showPredictionDialog(context, prediction);
    } else {
      ApiService.handleError(response);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            _buildTextField(
                controller: nameController,
                label: 'Name',
                hint: "John Doe",
                isNumber: false),
            Row(
              children: [
                Expanded(
                  child: _buildDropdownField(
                    label: 'Sex',
                    value: sex,
                    items: const [
                      DropdownMenuItem(value: '0', child: Text('Female')),
                      DropdownMenuItem(value: '1', child: Text('Male')),
                    ],
                    onChanged: (value) => setState(() => sex = value),
                  ),
                ),
                Expanded(
                  child: _buildTextField(controller: ageController, label: 'Age'),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: _buildDropdownField(
                    label: 'Blood Pressure Medication (BPMeds)',
                    value: BPMeds,
                    items: const [
                      DropdownMenuItem(value: '0', child: Text('No')),
                      DropdownMenuItem(value: '1', child: Text('Yes')),
                    ],
                    onChanged: (value) => setState(() => BPMeds = value),
                  ),
                ),
                Expanded(
                  child: _buildDropdownField(
                    label: 'Prevalent Stroke',
                    value: prevalentStroke,
                    items: const [
                      DropdownMenuItem(value: '0', child: Text('No')),
                      DropdownMenuItem(value: '1', child: Text('Yes')),
                    ],
                    onChanged: (value) => setState(() => prevalentStroke = value),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: _buildDropdownField(
                    label: 'Prevalent Hypertension',
                    value: prevalentHyp,
                    items: const [
                      DropdownMenuItem(value: '0', child: Text('No')),
                      DropdownMenuItem(value: '1', child: Text('Yes')),
                    ],
                    onChanged: (value) => setState(() => prevalentHyp = value),
                  ),
                ),
                Expanded(
                  child: _buildDropdownField(
                    label: 'Diabetes',
                    value: diabetes,
                    items: const [
                      DropdownMenuItem(value: '0', child: Text('No')),
                      DropdownMenuItem(value: '1', child: Text('Yes')),
                    ],
                    onChanged: (value) => setState(() => diabetes = value),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: _buildDropdownField(
                    label: 'Current Smoker',
                    value: currentSmoker,
                    items: const [
                      DropdownMenuItem(value: '0', child: Text('No')),
                      DropdownMenuItem(value: '1', child: Text('Yes')),
                    ],
                    onChanged: (value) {
                      setState(() {
                        currentSmoker = value;
                        if (value == '0') {
                          cigsPerDayController.text = '0';
                        }
                      });
                    },
                  ),
                ),
                Expanded(
                  child: _buildTextField(
                      controller: heartRateController, label: 'Heart Rate'),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: _buildTextField(
                      controller: BMIController, label: 'Body Mass Index (BMI)'),
                ),
                Expanded(
                  child: _buildTextField(
                      controller: glucoseController, label: 'Glucose Level'),
                ),
              ],
            ),
            _buildTextField(
                controller: cigsPerDayController,
                label: 'Cigarettes Per Day',
                isVisible: currentSmoker == '1'),
            _buildTextField(
                controller: totCholController,
                label: 'Total Cholesterol (totChol)'),
            _buildTextField(
                controller: sysBPController,
                label: 'Systolic Blood Pressure (sysBP)'),
            _buildTextField(
                controller: diaBPController,
                label: 'Diastolic Blood Pressure (diaBP)'),
            ElevatedButton(
              onPressed: () => _submitData(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryColor,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12), // <-- Radius
                ),
              ),
              child: const Text('Submit'),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    bool isVisible = true,
    bool isNumber = true,
    String? hint,
  }) {
    return Visibility(
      visible: isVisible,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Align(
              alignment: Alignment.center,
              child: TextField(
                controller: controller,
                decoration: InputDecoration(
                  labelText: label,
                  hintText: hint ?? "",
                  border: InputBorder.none,
                ),
                keyboardType:
                    isNumber ? TextInputType.number : TextInputType.text,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDropdownField({
    required String label,
    required String? value,
    required List<DropdownMenuItem<String>> items,
    required void Function(String?) onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: DropdownButtonFormField<String>(
          decoration: InputDecoration(
            labelText: label,
            border: InputBorder.none,
          ),
          value: value,
          items: items,
          onChanged: onChanged,
        ),
      ),
    );
  }

  void _showPredictionDialog(BuildContext context, int prediction) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Prediction'),
          content: Text(
            prediction == 0
                ? "You don't heart disease"
                : "You have Heart disease",
            style: TextStyle(
              color: prediction == 0 ? Colors.green : Colors.red,
            ),
          ),
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
