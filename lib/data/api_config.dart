class APIConfig {
  //* Base URL for the API
  static const String _baseUrl = 'http://192.168.1.102:8080/api/';

  // URLs for specific API endpoints
  static String loginUrl = "${_baseUrl}login/";
  static String signupUrl = "${_baseUrl}signup/";

  static String refreshUrl = "${_baseUrl}refresh_token/";

  static String predictUrl = "${_baseUrl}predict/";
  static String historyUrl = "${_baseUrl}patient_history/";

  static String feedbackUrl = "${_baseUrl}feedback/";
  static String isDoctorUrl = "${_baseUrl}is-doctor/";

  static String version = '1.0.0';
}
