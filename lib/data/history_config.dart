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
  final int prediction_result;

  History(
      {required this.id,
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
      required this.prediction_result});

  factory History.fromJson(Map<String, dynamic> json) {
    return History(
        id: json['id'],
        patientName: json['patientName'] ?? 'Unknown',
        sex: json['sex'],
        age: json['age'],
        currentSmoker: json['currentSmoker'],
        cigsPerDay: json['cigsPerDay'],
        BPMeds: json['BPMeds'],
        prevalentStroke: json['prevalentStroke'],
        prevalentHyp: json['prevalentHyp'],
        diabetes: json['diabetes'],
        totChol: json['totChol'],
        sysBP: json['sysBP'],
        diaBP: json['diaBP'],
        BMI: json['BMI'].toDouble(),
        heartRate: json['heartRate'],
        glucose: json['glucose'],
        status: json['doctor_feedback'],
        prediction_result: json['TenYearCHD']);
  }
}
