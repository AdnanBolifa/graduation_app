// ignore_for_file: non_constant_identifier_names

class Features {
  final String name;
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

  Features({
    required this.name,
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
  });

  Map<String, dynamic> toJson() {
    return {
      'patientName': name,
      'sex': sex,
      'age': age,
      'currentSmoker': currentSmoker,
      'cigsPerDay': cigsPerDay,
      'BPMeds': BPMeds,
      'prevalentStroke': prevalentStroke,
      'prevalentHyp': prevalentHyp,
      'diabetes': diabetes,
      'totChol': totChol,
      'sysBP': sysBP,
      'diaBP': diaBP,
      'BMI': BMI,
      'heartRate': heartRate,
      'glucose': glucose,
    };
  }
}
