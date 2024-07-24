// ignore_for_file: non_constant_identifier_names

class History {
  final int id;
  final String patientName;
  final int sex; // Male
  final int age; // Age in years
  final int currentSmoker; // Currently smoking
  final int cigsPerDay; // Number of cigarettes smoked per day
  final int BPMeds; // Taking blood pressure medication
  final int prevalentStroke; // No history of stroke
  final int prevalentHyp; // Prevalent hypertension
  final int diabetes; // Diabetic
  final int totChol; // Total cholesterol level in mg/dL
  final int sysBP; // Systolic blood pressure in mmHg
  final int diaBP; // Diastolic blood pressure in mmHg
  final double BMI; // Body mass index
  final int heartRate; // Heart rate in beats per minute
  final int glucose; // Glucose level in mg/dL
  final bool? status;
  final double prediction_result;

  History({
    required this.id,
    required this.patientName,
    required this.sex,
    required this.age,
    required this.currentSmoker,
    required this.cigsPerDay,
    required this.BPMeds,
    required this.prevalentStroke,
    required this.prevalentHyp,
    required this.diabetes,
    required this.totChol,
    required this.sysBP,
    required this.diaBP,
    required this.BMI,
    required this.heartRate,
    required this.glucose,
    required this.status,
    required this.prediction_result,
  });

  factory History.fromJson(Map<String, dynamic> json) {
    return History(
      id: json['id'] ?? 0,
      patientName: json['patientName'] ?? 'Unknown',
      sex: json['sex'] ?? 0,
      age: json['age'] ?? 0,
      currentSmoker: json['currentSmoker'] ?? 0,
      cigsPerDay: json['cigsPerDay'] ?? 0,
      BPMeds: json['BPMeds'] ?? 0,
      prevalentStroke: json['prevalentStroke'] ?? 0,
      prevalentHyp: json['prevalentHyp'] ?? 0,
      diabetes: json['diabetes'] ?? 0,
      totChol: json['totChol'] ?? 0,
      sysBP: json['sysBP'] ?? 0,
      diaBP: json['diaBP'] ?? 0,
      BMI: (json['BMI'] ?? 0).toDouble(),
      heartRate: json['heartRate'] ?? 0,
      glucose: json['glucose'] ?? 0,
      status: json['doctor_feedback'],
      prediction_result: json['Prediction'] ?? 0,
    );
  }
}
