class APIConfig {
  //* Base URL for the API
  static const String _baseUrl = 'http://192.168.1.102:8000/';

  // Paths for different API endpoints
  static const String _apiPath = 'api';

  // Method to build complete URLs from base URL and paths
  static String _buildUrl(String path) => '$_baseUrl$path';

  // URLs for specific API endpoints
  static String loginUrl = "http://192.168.1.102:8000/api/login/";
  static String signupUrl = "${_baseUrl}api/signup/";
  static String refreshUrl = "${_baseUrl}api/refresh_token";

  static String predictUrl = "${_baseUrl}api/predict/";
  static String historyUrl = "${_baseUrl}api/patient_history";

  static String ticketsUrl = _buildUrl('$_apiPath/list');
  static String solutionsUrl = _buildUrl('$_apiPath/solutions/list');
  static String problemsUrl = _buildUrl('$_apiPath/problems/list');
  static String addUrl = _buildUrl('$_apiPath/add');
  static String updateUrl = _buildUrl('$_apiPath/');

  static String timerUrl = _buildUrl(_apiPath);
  static String submitSurveyUrl = _buildUrl('$_apiPath/survey/submit/');
  static String getSurveyUrl = _buildUrl('$_apiPath/survey/');

  static String towerUrl = _buildUrl('tower/list');
  static String sectorsUrl = _buildUrl('tower/sectors/list');

  static String checkUpdates = 'http://165.16.36.4:8015/checkUpdate.php';

  static String version = '1.0.7';
}
