class APIConfig {
  //* Base URL for the API
  static const String _baseUrl = 'http://193.23.160.141:6969/api/';

  // URLs for specific API endpoints
  static String loginUrl = "${_baseUrl}login/";
  static String signupUrl = "${_baseUrl}signup/";

  static String refreshUrl = "${_baseUrl}refresh_token/";

  static String predictUrl = "${_baseUrl}predict/";
  static String historyUrl = "${_baseUrl}patient_history/";

  static String feedbackUrl = "${_baseUrl}feedback/";

  static String version = '1.0.0';
}
