// ignore_for_file: non_constant_identifier_names

class Heart {
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

  Heart({
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

class Diabetes {
  final String name;
  final int pregnancies;
  final int glucose;
  final int bloodPressure;
  final int skinThickness;
  final int insulin;
  final double bmi;
  final double diabetesPedigreeFunction;
  final int age;
  final int sex;

  Diabetes({
    required this.name,
    required this.sex,
    required this.pregnancies,
    required this.glucose,
    required this.bloodPressure,
    required this.skinThickness,
    required this.insulin,
    required this.bmi,
    required this.diabetesPedigreeFunction,
    required this.age,
  });
  Map<String, dynamic> toJson() {
    return {
      'patientName': name,
      'Pregnancies': pregnancies,
      'Glucose': glucose,
      'BloodPressure': bloodPressure,
      'SkinThickness': skinThickness,
      'Insulin': insulin,
      'BMI': bmi,
      'DiabetesPedigreeFunction': diabetesPedigreeFunction,
      'age': age,
      'sex': sex,
    };
  }
}

class DiabetesVip {
  final String name;
  final int sex;
  final int age;
  final double urea;
  final double cr;
  final double hbA1c;
  final double chol;
  final double tg;
  final double hdl;
  final double ldl;
  final double vldl;
  final double bmi;

  DiabetesVip({
    required this.name,
    required this.sex,
    required this.age,
    required this.urea,
    required this.cr,
    required this.hbA1c,
    required this.chol,
    required this.tg,
    required this.hdl,
    required this.ldl,
    required this.vldl,
    required this.bmi,
  });

  Map<String, dynamic> toJson() {
    return {
      'patientName': name,
      'sex': sex,
      'age': age,
      'Urea': urea,
      'Cr': cr,
      'HbA1c': hbA1c,
      'Chol': chol,
      'TG': tg,
      'HDL': hdl,
      'LDL': ldl,
      'VLDL': vldl,
      'BMI': bmi,
    };
  }
}

class Hypertension {
  final String name;
  final int sex;
  final int age;
  final int currentSmoker;
  final int cigsPerDay;
  final int BPMeds;
  final int diabetes;
  final int totChol;
  final int sysBP;
  final int diaBP;
  final double bmi;
  final int heartRate;
  final int glucose;

  Hypertension({
    required this.name,
    required this.sex,
    required this.age,
    required this.currentSmoker,
    required this.cigsPerDay,
    required this.BPMeds,
    required this.diabetes,
    required this.totChol,
    required this.sysBP,
    required this.diaBP,
    required this.bmi,
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
      'diabetes': diabetes,
      'totChol': totChol,
      'sysBP': sysBP,
      'diaBP': diaBP,
      'BMI': bmi,
      'heartRate': heartRate,
      'glucose': glucose,
    };
  }
}
