import 'package:flutter/material.dart';
import 'package:jwt_auth/theme/colors.dart';

class HypertensionScreen extends StatefulWidget {
  const HypertensionScreen({Key? key}) : super(key: key);

  @override
  HypertensionScreenState createState() => HypertensionScreenState();
}

class HypertensionScreenState extends State<HypertensionScreen> {
  final TextEditingController currentSmokerController = TextEditingController();
  final TextEditingController cigsPerDayController = TextEditingController();
  final TextEditingController bpMedsController = TextEditingController();
  final TextEditingController diabetesController = TextEditingController();
  final TextEditingController totCholController = TextEditingController();
  final TextEditingController sysBPController = TextEditingController();
  final TextEditingController diaBPController = TextEditingController();
  final TextEditingController bmiController = TextEditingController();
  final TextEditingController heartRateController = TextEditingController();
  final TextEditingController glucoseController = TextEditingController();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController ageController = TextEditingController();

  String? sex;

  @override
  void dispose() {
    currentSmokerController.dispose();
    cigsPerDayController.dispose();
    bpMedsController.dispose();
    diabetesController.dispose();
    totCholController.dispose();
    sysBPController.dispose();
    diaBPController.dispose();
    bmiController.dispose();
    heartRateController.dispose();
    glucoseController.dispose();
    nameController.dispose();
    ageController.dispose();
    super.dispose();
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
              hint: 'Enter your name',
              isNumber: false,
            ),
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
                  child: _buildTextField(
                    controller: ageController,
                    label: 'Age',
                    hint: 'Enter your age',
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: _buildTextField(
                    controller: currentSmokerController,
                    label: 'Current Smoker',
                    hint: 'Yes/No',
                  ),
                ),
                Expanded(
                  child: _buildTextField(
                    controller: cigsPerDayController,
                    label: 'Cigs Per Day',
                    hint: 'Number of cigarettes smoked per day',
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: _buildTextField(
                    controller: bpMedsController,
                    label: 'BP Meds',
                    hint: 'Yes/No',
                  ),
                ),
                Expanded(
                  child: _buildTextField(
                    controller: diabetesController,
                    label: 'Diabetes',
                    hint: 'Yes/No',
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: _buildTextField(
                    controller: totCholController,
                    label: 'Total Cholesterol',
                    hint: 'Total cholesterol level',
                  ),
                ),
                Expanded(
                  child: _buildTextField(
                    controller: sysBPController,
                    label: 'Sys BP',
                    hint: 'Systolic blood pressure',
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: _buildTextField(
                    controller: diaBPController,
                    label: 'Dia BP',
                    hint: 'Diastolic blood pressure',
                  ),
                ),
                Expanded(
                  child: _buildTextField(
                    controller: bmiController,
                    label: 'BMI',
                    hint: 'Body Mass Index',
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: _buildTextField(
                    controller: heartRateController,
                    label: 'Heart Rate',
                    hint: 'Heart rate',
                  ),
                ),
                Expanded(
                  child: _buildTextField(
                    controller: glucoseController,
                    label: 'Glucose',
                    hint: 'Glucose level',
                  ),
                ),
              ],
            ),
            ElevatedButton(
              onPressed: () => _submitData(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryColor,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    String? hint,
    bool isNumber = true,
  }) {
    return Padding(
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
            prediction == 0 ? "You don't have diabetes" : "You have diabetes",
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

  Future<void> _submitData(BuildContext context) async {
    // Add your data submission logic here
  }
}
