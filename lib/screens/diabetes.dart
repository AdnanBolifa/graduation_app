import 'package:flutter/material.dart';
import 'package:jwt_auth/theme/colors.dart';

class DiabetesScreen extends StatefulWidget {
  const DiabetesScreen({Key? key}) : super(key: key);

  @override
  DiabetesScreenState createState() => DiabetesScreenState();
}

class DiabetesScreenState extends State<DiabetesScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController pregnanciesController = TextEditingController();
  final TextEditingController glucoseController = TextEditingController();
  final TextEditingController bloodPressureController = TextEditingController();
  final TextEditingController skinThicknessController = TextEditingController();
  final TextEditingController insulinController = TextEditingController();
  final TextEditingController bmiController = TextEditingController();
  final TextEditingController diabetesPedigreeFunctionController =
      TextEditingController();

  String? sex;

  @override
  void dispose() {
    nameController.dispose();
    ageController.dispose();
    pregnanciesController.dispose();
    glucoseController.dispose();
    bloodPressureController.dispose();
    skinThicknessController.dispose();
    insulinController.dispose();
    bmiController.dispose();
    diabetesPedigreeFunctionController.dispose();
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
                    controller: pregnanciesController,
                    label: 'Pregnancies',
                    hint: 'Number of times the patient has been pregnant',
                  ),
                ),
                Expanded(
                  child: _buildTextField(
                    controller: glucoseController,
                    label: 'Glucose',
                    hint:
                        'Plasma glucose concentration after 2 hours in an oral glucose tolerance test',
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: _buildTextField(
                    controller: bloodPressureController,
                    label: 'Blood Pressure',
                    hint: 'Diastolic blood pressure (mm Hg)',
                  ),
                ),
                Expanded(
                  child: _buildTextField(
                    controller: skinThicknessController,
                    label: 'Skin Thickness',
                    hint: 'Triceps skin fold thickness (mm)',
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: _buildTextField(
                    controller: insulinController,
                    label: 'Insulin',
                    hint: '2-Hour serum insulin (mu U/ml)',
                  ),
                ),
                Expanded(
                  child: _buildTextField(
                    controller: bmiController,
                    label: 'BMI',
                    hint: 'Body Mass Index (weight in kg/(height in m)^2)',
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: _buildTextField(
                    controller: diabetesPedigreeFunctionController,
                    label: 'Diabetes Pedigree Function',
                    hint: 'Likelihood of diabetes based on family history',
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
    // http.Response response = await ApiService.submitDiabetesData(
    //   context,
    //   nameController,
    //   TextEditingController(text: sex),
    //   ageController,
    //   pregnanciesController,
    //   glucoseController,
    //   bloodPressureController,
    //   skinThicknessController,
    //   insulinController,
    //   bmiController,
    //   diabetesPedigreeFunctionController,
    // );
    // if (response.statusCode == 200) {
    //   int prediction = ApiService.getPrediction(response);
    //   _showPredictionDialog(context, prediction);
    // } else {
    //   ApiService.handleError(response);
    // }
  }
}
