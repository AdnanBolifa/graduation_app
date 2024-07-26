import 'dart:typed_data';
import 'package:flutter/material.dart';
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
        build: (pw.Context context) => pw.Center(
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text('Name: ${nameController.text}'),
              pw.Text('Age: ${ageController.text}'),
              pw.Text('Sex: ${sex == '0' ? 'Female' : 'Male'}'),
              pw.Text('Pregnancies: ${pregnanciesController.text}'),
              pw.Text('Glucose: ${glucoseController.text}'),
              pw.Text('Blood Pressure: ${bloodPressureController.text}'),
              pw.Text('Skin Thickness: ${skinThicknessController.text}'),
              pw.Text('Insulin: ${insulinController.text}'),
              pw.Text('BMI: ${bmiController.text}'),
              pw.Text(
                  'Diabetes Pedigree Function: ${diabetesPedigreeFunctionController.text}'),
            ],
          ),
        ),
      ),
    );

    final Uint8List pdfBytes = await pdf.save();
    Printing.layoutPdf(onLayout: (PdfPageFormat format) async => pdfBytes);
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
            // Other fields here...
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
              child: const Text('Export to PDF'),
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
                    ? "You don't have heart disease."
                    : "You have heart disease.",
                style: TextStyle(
                  color: prediction == 0 ? Colors.green : Colors.red,
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                "Probability: ${probabilityPositive.toStringAsFixed(2)}%",
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
