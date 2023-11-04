class APIConfig {
  static const String baseUrl = 'http://165.16.36.4:8877/api/';

  static const String loginUrl = '${baseUrl}vip/login';
  static const String refreshUrl = '${baseUrl}vip/refresh';

  static const String reportsUrl = '${baseUrl}ticket/list';
  static const String solutionsUrl = '${baseUrl}ticket/solutions/list';
  static const String problemsUrl = '${baseUrl}ticket/problems/list';
  static const String addUrl = '${baseUrl}ticket/add';
  static const String updateUrl = '${baseUrl}ticket/';
  static const String timer = '${baseUrl}v2/ticket/';
  static const String submitSurvey = '${baseUrl}v2/ticket/survey/submit/';
}
