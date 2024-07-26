import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:jwt_auth/services/api_service.dart';
import 'package:jwt_auth/theme/colors.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

// ignore_for_file: use_build_context_synchronously

class DiabetesVIPScreen extends StatefulWidget {
  const DiabetesVIPScreen({Key? key}) : super(key: key);

  @override
  DiabetesVIPScreenState createState() => DiabetesVIPScreenState();
}

class DiabetesVIPScreenState extends State<DiabetesVIPScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController ureaController = TextEditingController();
  final TextEditingController crController = TextEditingController();
  final TextEditingController hbA1cController = TextEditingController();
  final TextEditingController cholController = TextEditingController();
  final TextEditingController tgController = TextEditingController();
  final TextEditingController hdlController = TextEditingController();
  final TextEditingController ldlController = TextEditingController();
  final TextEditingController vldlController = TextEditingController();
  final TextEditingController bmiController = TextEditingController();

  String? sex;

  @override
  void dispose() {
    nameController.dispose();
    ageController.dispose();
    ureaController.dispose();
    crController.dispose();
    hbA1cController.dispose();
    cholController.dispose();
    tgController.dispose();
    hdlController.dispose();
    ldlController.dispose();
    vldlController.dispose();
    bmiController.dispose();
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
              _buildInfoRow('Urea', ureaController.text,
                  'Blood urea nitrogen level, indicating kidney function.'),
              _buildInfoRow('Creatinine (CR)', crController.text,
                  'Creatinine level in blood, indicating kidney function.'),
              _buildInfoRow('HbA1c', hbA1cController.text,
                  'Glycated hemoglobin, reflecting average blood glucose levels over 2-3 months.'),
              _buildInfoRow('Cholesterol (Chol)', cholController.text,
                  'Total cholesterol level in blood.'),
              _buildInfoRow('Triglycerides (TG)', tgController.text,
                  'Level of triglycerides in blood, a type of fat.'),
              _buildInfoRow('HDL', hdlController.text,
                  'High-density lipoprotein, known as "good" cholesterol.'),
              _buildInfoRow('LDL', ldlController.text,
                  'Low-density lipoprotein, known as "bad" cholesterol.'),
              _buildInfoRow('VLDL', vldlController.text,
                  'Very low-density lipoprotein, another type of "bad" cholesterol.'),
              _buildInfoRow('BMI', bmiController.text,
                  'Body Mass Index, a measure of body fat based on weight and height.'),
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
                const SizedBox(width: 8.0), // Space between fields
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
                    controller: ureaController,
                    label: 'Urea',
                    hint: 'Enter your Urea level',
                  ),
                ),
                const SizedBox(width: 8.0), // Space between fields
                Expanded(
                  child: _buildTextField(
                    controller: crController,
                    label: 'Cr',
                    hint: 'Enter your Creatinine level',
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: _buildTextField(
                    controller: hbA1cController,
                    label: 'HbA1c',
                    hint: 'Enter your HbA1c level',
                  ),
                ),
                const SizedBox(width: 8.0), // Space between fields
                Expanded(
                  child: _buildTextField(
                    controller: cholController,
                    label: 'Chol',
                    hint: 'Enter your Cholesterol level',
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: _buildTextField(
                    controller: tgController,
                    label: 'TG',
                    hint: 'Enter your Triglycerides level',
                  ),
                ),
                const SizedBox(width: 8.0), // Space between fields
                Expanded(
                  child: _buildTextField(
                    controller: hdlController,
                    label: 'HDL',
                    hint: 'Enter your HDL level',
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: _buildTextField(
                    controller: ldlController,
                    label: 'LDL',
                    hint: 'Enter your LDL level',
                  ),
                ),
                const SizedBox(width: 8.0), // Space between fields
                Expanded(
                  child: _buildTextField(
                    controller: vldlController,
                    label: 'VLDL',
                    hint: 'Enter your VLDL level',
                  ),
                ),
              ],
            ),
            _buildTextField(
              controller: bmiController,
              label: 'BMI',
              hint: 'Enter your BMI',
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
                    ? "You don't have diabetes."
                    : "You have diabetes.",
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
    http.Response response = await ApiService().submitDiabetesVIPData(
      context: context,
      nameController: nameController,
      ageController: ageController,
      ureaController: ureaController,
      crController: crController,
      hbA1cController: hbA1cController,
      cholController: cholController,
      tgController: tgController,
      hdlController: hdlController,
      ldlController: ldlController,
      vldlController: vldlController,
      bmiController: bmiController,
      sex: sex,
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
