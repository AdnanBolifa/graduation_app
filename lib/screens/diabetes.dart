// ignore_for_file: use_build_context_synchronously
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:jwt_auth/services/api_service.dart';
import 'package:jwt_auth/theme/colors.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

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

  Future<void> _generatePdf() async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) => pw.Padding(
          padding: const pw.EdgeInsets.all(16),
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                'Medical Test Report',
                style: pw.TextStyle(
                  fontSize: 36,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.SizedBox(height: 20),
              _buildInfoRow('Name', nameController.text, 'Patient\'s name.'),
              _buildInfoRow(
                  'Age', ageController.text, 'Patient\'s age in years.'),
              _buildInfoRow('Pregnancies', pregnanciesController.text,
                  'Number of times the patient has been pregnant.'),
              _buildInfoRow('Glucose', glucoseController.text,
                  'Plasma glucose concentration after 2 hours in an oral glucose tolerance test.'),
              _buildInfoRow('Blood Pressure', bloodPressureController.text,
                  'Diastolic blood pressure (mm Hg).'),
              _buildInfoRow('Skin Thickness', skinThicknessController.text,
                  'Triceps skin fold thickness (mm).'),
              _buildInfoRow('Insulin', insulinController.text,
                  '2-Hour serum insulin (mu U/ml).'),
              _buildInfoRow('BMI', bmiController.text,
                  'Body Mass Index, a measure of body fat based on weight and height.'),
              _buildInfoRow(
                  'Diabetes Pedigree Function',
                  diabetesPedigreeFunctionController.text,
                  'Likelihood of diabetes based on family history.'),
              _buildInfoRow(
                  'Sex', sex ?? 'Not provided', 'Gender of the patient.'),
            ],
          ),
        ),
      ),
    );

    final Uint8List pdfBytes = await pdf.save();
    Printing.layoutPdf(onLayout: (PdfPageFormat format) async => pdfBytes);
  }

  pw.Widget _buildInfoRow(String label, String value, String meaning) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            pw.Text(
              '$label:',
              style: pw.TextStyle(
                fontSize: 18,
                fontWeight: pw.FontWeight.bold,
              ),
            ),
            pw.Text(
              value,
              style: const pw.TextStyle(fontSize: 18),
            ),
          ],
        ),
        pw.SizedBox(height: 4),
        pw.Text(
          meaning,
          style: const pw.TextStyle(
            fontSize: 14,
          ),
        ),
        pw.SizedBox(height: 12),
      ],
    );
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
            ElevatedButton(
              onPressed: _generatePdf,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryColor,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text('Generate PDF'),
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

  void _showPredictionDialog(
      BuildContext context, int prediction, double probabilityPositive) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Prediction Result'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                prediction == 0
                    ? "You don't have Diabetes."
                    : "You have Diabetes.",
                style: TextStyle(
                  color: prediction == 0 ? Colors.green : Colors.red,
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                prediction == 0
                    ? "Probability: ${(100 - probabilityPositive).toStringAsFixed(2)}%"
                    : "Probability: ${probabilityPositive.toStringAsFixed(2)}%",
                style: const TextStyle(fontSize: 16),
              ),
            ],
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
    http.Response response = await ApiService().submitDiabetesBasicData(
      context: context,
      nameController: nameController,
      ageController: ageController,
      pregnanciesController: pregnanciesController,
      glucoseController: glucoseController,
      bloodPressureController: bloodPressureController,
      skinThicknessController: skinThicknessController,
      insulinController: insulinController,
      bmiController: bmiController,
      diabetesPedigreeFunctionController: diabetesPedigreeFunctionController,
      sexController: TextEditingController(text: sex),
    );
    if (response.statusCode == 200) {
      final result = ApiService.getPredictionAndProbability(response);
      final prediction = result['prediction'];
      final probabilityPositive = result['probability_positive'];
      _showPredictionDialog(context, prediction, probabilityPositive);
    } else {
      ApiService.handleError(response);
    }
  }
}
