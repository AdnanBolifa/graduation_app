class APIConfig {
  //* Base URL for the API
  //static const String _baseUrl = 'http://165.16.36.4:8015/api/';

  //* Testing
  static const String _baseUrl = 'http://165.16.36.4:8877/api/';

  // Paths for different API endpoints
  static const String _vipPath = 'vip';
  static const String _ticketPath = 'ticket';
  static const String _v2Path = 'v2/ticket';

  // Method to build complete URLs from base URL and paths
  static String _buildUrl(String path) => '$_baseUrl$path';

  // URLs for specific API endpoints
  static String loginUrl = _buildUrl('$_vipPath/login');
  static String refreshUrl = _buildUrl('$_vipPath/refresh');
  static String reportsUrl = _buildUrl('$_ticketPath/list');
  static String solutionsUrl = _buildUrl('$_ticketPath/solutions/list');
  static String problemsUrl = _buildUrl('$_ticketPath/problems/list');
  static String addUrl = _buildUrl('$_ticketPath/add');
  static String updateUrl = _buildUrl('$_ticketPath/');

  static String timerUrl = _buildUrl(_v2Path);
  static String submitSurveyUrl = _buildUrl('$_v2Path/survey/submit/');
  static String getSurveyUrl = _buildUrl('$_v2Path/survey/');

  static String towerUrl = _buildUrl('tower/list');
  static String sectorsUrl = _buildUrl('tower/sectors/list');

  static String checkUpdates = 'http://192.168.100.108/update.php';
}
