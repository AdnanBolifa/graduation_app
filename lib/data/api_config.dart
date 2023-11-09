class APIConfig {
  static const String baseUrl = 'http://165.16.36.4:8015/api/';

  //* Testing
  //static const String baseUrl = 'http://165.16.36.4:8877/api/';

  static const String vipPath = 'vip/';
  static const String ticketPath = 'ticket/';
  static const String v2Path = 'v2/ticket/';

  static String buildUrl(String path) => '$baseUrl$path';

  static String loginUrl = buildUrl('${vipPath}login');
  static String refreshUrl = buildUrl('${vipPath}refresh');

  static String reportsUrl = buildUrl('${ticketPath}list');
  static String solutionsUrl = buildUrl('${ticketPath}solutions/list');
  static String problemsUrl = buildUrl('${ticketPath}problems/list');
  static String addUrl = buildUrl('${ticketPath}add');
  static String updateUrl = buildUrl(ticketPath);

  static String timerUrl = buildUrl(v2Path);
  static String submitSurveyUrl = buildUrl('${v2Path}survey/submit/');
  static String getSurveyUrl = buildUrl('${v2Path}survey/');
}
