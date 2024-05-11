class History {
  final int id;
  final int age;
  final int sex;
  final int cp;
  final int trestbps;
  final int chol;
  final int fbs;
  final int restecg;
  final int thalach;
  final int exang;
  final double oldpeak;
  final int slope;
  final int ca;
  final int thal;
  final String createdAt;
  final int user;

  History({
    required this.id,
    required this.age,
    required this.sex,
    required this.cp,
    required this.trestbps,
    required this.chol,
    required this.fbs,
    required this.restecg,
    required this.thalach,
    required this.exang,
    required this.oldpeak,
    required this.slope,
    required this.ca,
    required this.thal,
    required this.createdAt,
    required this.user,
  });

  factory History.fromJson(Map<String, dynamic> json) {
    return History(
      id: json['id'],
      age: json['age'],
      sex: json['sex'],
      cp: json['cp'],
      trestbps: json['trestbps'],
      chol: json['chol'],
      fbs: json['fbs'],
      restecg: json['restecg'],
      thalach: json['thalach'],
      exang: json['exang'],
      oldpeak: json['oldpeak'],
      slope: json['slope'],
      ca: json['ca'],
      thal: json['thal'],
      createdAt: json['created_at'],
      user: json['user'],
    );
  }
}
