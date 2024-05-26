// ignore_for_file: non_constant_identifier_names

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:jwt_auth/data/api_config.dart';
import 'package:jwt_auth/data/features_config.dart';
import 'package:jwt_auth/data/history_config.dart';
import 'package:jwt_auth/data/location_config.dart';
import 'package:jwt_auth/data/multi_survey_config.dart';
import 'package:jwt_auth/data/problem_config.dart';
import 'package:jwt_auth/data/sectors_config.dart';
import 'package:jwt_auth/data/ticket_config.dart';
import 'package:jwt_auth/data/solution_config.dart';
import 'package:jwt_auth/data/towers_config.dart';
import 'package:jwt_auth/main.dart';
import 'package:jwt_auth/screens/login.dart';
import 'package:jwt_auth/services/auth_service.dart';

class ApiService {
  static Future<http.Response> submitData(
    BuildContext context,
    TextEditingController sexController,
    TextEditingController nameController,
    TextEditingController ageController,
    TextEditingController currentSmokerController,
    TextEditingController cigsPerDayController,
    TextEditingController BPMedsController,
    TextEditingController prevalentStrokeController,
    TextEditingController prevalentHypController,
    TextEditingController diabetesController,
    TextEditingController totCholController,
    TextEditingController sysBPController,
    TextEditingController diaBPController,
    TextEditingController BMIController,
    TextEditingController heartRateController,
    TextEditingController glucoseController,
  ) async {
    final Features data = Features(
      name: nameController.text,
      sex: int.parse(sexController.text),
      age: int.parse(ageController.text),
      currentSmoker: int.parse(currentSmokerController.text),
      cigsPerDay: int.parse(cigsPerDayController.text),
      BPMeds: int.parse(BPMedsController.text),
      prevalentStroke: int.parse(prevalentStrokeController.text),
      prevalentHyp: int.parse(prevalentHypController.text),
      diabetes: int.parse(diabetesController.text),
      totChol: int.parse(totCholController.text),
      sysBP: int.parse(sysBPController.text),
      diaBP: int.parse(diaBPController.text),
      BMI: double.parse(BMIController.text),
      heartRate: int.parse(heartRateController.text),
      glucose: int.parse(glucoseController.text),
    );
    final accessToken = await AuthService().getAccessToken();
    final Uri url = Uri.parse('http://192.168.1.102:8000/api/predict/');
    final response = await http.post(
      url,
      headers: <String, String>{
        'Authorization': 'Bearer $accessToken',
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(data.toJson()),
    );
    return response;
  }

  static int getPrediction(http.Response response) {
    Map<String, dynamic> responseBody = jsonDecode(response.body);
    return responseBody['prediction'];
  }

  static void handleError(http.Response response) {
    String responseBody = response.body;
    Map<String, dynamic>? parsedBody;

    try {
      // Attempt to parse the response body as JSON
      parsedBody = jsonDecode(responseBody);
    } catch (e) {
      // Parsing failed, treat it as plain text
    }

    debugPrint('Status Code: ${response.statusCode}');
    debugPrint('Response Body:');

    if (parsedBody != null) {
      debugPrint(const JsonEncoder.withIndent('  ').convert(parsedBody));
    } else {
      debugPrint(responseBody);
    }

    showDialog(
      context: navigatorKey.currentState!.context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Response Details'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Status Code: ${response.statusCode}'),
                const Text('Response Body:'),
                if (parsedBody != null)
                  Text(
                    const JsonEncoder.withIndent('  ').convert(parsedBody),
                    style: const TextStyle(fontFamily: 'monospace'),
                  ),
                if (parsedBody == null) Text(responseBody),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
            TextButton(
              onPressed: () {
                navigatorKey.currentState?.push(
                  MaterialPageRoute(
                    builder: (context) => const LoginPage(),
                  ),
                );
              },
              child: const Text('تسجيل الخروج'),
            ),
          ],
        );
      },
    );
  }

  Future<void> addReport(
      String name,
      acc,
      phone,
      place,
      sector,
      List<int> problems,
      List<int> solution,
      double longitude,
      double latitude) async {
    final requestBody = {
      'name': name,
      'phone': phone,
      'account': acc,
      'place': place,
      'sector': sector,
      'problem': problems,
      'solutions': solution,
      'longitude': longitude,
      'latitude': latitude
    };

    await _performPostRequest(APIConfig.addUrl, requestBody);
  }

  Future<void> updateReport({
    String? name,
    acc,
    phone,
    place,
    sector,
    int? id,
    String? comment,
    String? ticket,
    List<int>? problems,
    List<int>? solution,
    double? longitude,
    double? latitude,
  }) async {
    final requestBody = {
      if (name != null) 'name': name,
      if (acc != null) 'account': acc,
      if (phone != null) 'phone': phone,
      if (place != null) 'place': place,
      if (sector != null) 'sector': sector,
      if (comment != null) 'comment': comment,
      if (problems != null) 'problem': problems,
      if (solution != null) 'solutions': solution,
      if (longitude != null) 'longitude': longitude,
      if (latitude != null) 'latitude': latitude,
      'ticket': id
    };

    if (id == null) {
      throw 'Id not provided';
    } else if (comment == null) {
      //update data
      await _performPutRequest('${APIConfig.updateUrl}$id/edit', requestBody);
    } else {
      //add new comment
      await _performPostRequest('${APIConfig.updateUrl}update', requestBody);
    }
  }

  Future<List<Ticket>?> getReports() async {
    final response = await _performGetRequest(APIConfig.ticketsUrl);
    if (response.statusCode == 200) {
      try {
        final responseMap = jsonDecode(utf8.decode(response.bodyBytes));
        final List<dynamic> data = responseMap['results'];

        final users = data.map((user) => Ticket.fromJson(user)).toList();
        return users;
      } catch (e) {
        Fluttertoast.showToast(msg: 'Error parsing JSON: $e');
      }
    } else {
      //handleErrorMessage(response: response);
      debugPrint('Response content: ${response.body}');
    }

    return null;
  }

  Future<List<History>?> getHistory() async {
    final response = await _performGetRequest(APIConfig.historyUrl);
    if (response.statusCode == 200) {
      try {
        final List<dynamic> historyJson = jsonDecode(response.body);
        final List<History> history =
            historyJson.map((history) => History.fromJson(history)).toList();
        return history;
      } catch (e) {
        debugPrint('Error parsing JSON: $e');
        return null;
      }
    } else {
      debugPrint('Response content: ${response.body}');
      return null;
    }
  }

  Future<List<Problem>> fetchProblems() async {
    final response = await _performGetRequest(APIConfig.problemsUrl);
    return _parseProblemsResponse(response);
  }

  Future<List<Solution>> fetchSolutions() async {
    final response = await _performGetRequest(APIConfig.solutionsUrl);
    return _parseSolutionsResponse(response);
  }

  Future<void> startTimer(LocationData location, int ticket) async {
    final body = {
      "long": location.longitude,
      "lat": location.latitude,
    };
    await _performPostRequest('${APIConfig.timerUrl}/$ticket/start', body);
  }

  Future<List<MultiSurvey>> fetchSurvey() async {
    final response = await _performGetRequest(APIConfig.getSurveyUrl);
    return _parseSurveyResponse(response);
  }

  Future<void> submitSurvey(
      int id, List<Map<String, dynamic>> answersList) async {
    final body = {
      "ticket": id,
      "answers_list": answersList,
    };

    debugPrint(jsonEncode(body));

    await _performPostRequest(APIConfig.submitSurveyUrl, body);
  }

  Future<List<Tower>> fetchTowers() async {
    final responseTower = await _performGetRequest(APIConfig.towerUrl);
    final responseSec = await _performGetRequest(APIConfig.sectorsUrl);
    return _parseTowerResponse(responseTower, responseSec);
  }

  //API CALLS
  Future<http.Response> _performGetRequest(String url) async {
    return _performRequest(url, 'GET', null);
  }

  Future<void> _performPostRequest(String url, dynamic body) async {
    await _performRequest(url, 'POST', body);
  }

  Future<void> _performPutRequest(String url, dynamic body) async {
    await _performRequest(url, 'PUT', body);
  }

  //helper functions
  Future<http.Response> _performRequest(String url, String method, dynamic body,
      {int retryCount = 0}) async {
    try {
      final accessToken = await AuthService().getAccessToken();
      final Map<String, String> headers = {
        'Authorization': 'Bearer $accessToken',
        'Content-Type': 'application/json',
      };

      http.Response response;

      if (method == 'GET') {
        response = await http.get(
          Uri.parse(url),
          headers: headers,
        );
      } else if (method == 'POST') {
        response = await http.post(
          Uri.parse(url),
          body: (body != null) ? jsonEncode(body) : null,
          headers: headers,
        );
      } else if (method == 'PUT') {
        response = await http.put(
          Uri.parse(url),
          body: (body != null) ? jsonEncode(body) : null,
          headers: headers,
        );
      } else {
        throw Exception('Unsupported HTTP method: $method');
      }

      if (response.statusCode == 401) {
        // Token expired, attempt to refresh
        if (retryCount < 3) {
          await AuthService().getNewAccessToken();
          // Retry the original request with the new access token
          return _performRequest(url, method, body, retryCount: retryCount + 1);
        }
        // If token refresh fails after multiple attempts, log the user out
        navigatorKey.currentState?.push(
          MaterialPageRoute(
            builder: (context) => const LoginPage(),
          ),
        );
      } else if (response.statusCode != 200 &&
          response.statusCode != 201 &&
          response.statusCode != 204) {
        handleErrorMessage(response: response);
      }
      return response; // Return the response if you need it
    } catch (error) {
      handleErrorMessage(msg: 'انتهت الجلسة: $error');
      debugPrint('Request CATCH ERROR: $error');
      rethrow;
    }
  }

  //Parsing
  List<Problem> _parseProblemsResponse(http.Response response) {
    if (response.statusCode == 200) {
      final responseMap = jsonDecode(utf8.decode(response.bodyBytes));
      final List<dynamic> results = responseMap['results'];

      final problems = results.map((item) => Problem.fromJson(item)).toList();
      return problems;
    } else {
      throw Exception('Failed to fetch problems');
    }
  }

  List<Solution> _parseSolutionsResponse(http.Response response) {
    if (response.statusCode == 200) {
      final responseMap = jsonDecode(utf8.decode(response.bodyBytes));
      final List<dynamic> results = responseMap['results'];

      final solutions = results.map((item) => Solution.fromJson(item)).toList();
      return solutions;
    } else {
      throw Exception('Failed to fetch solutions');
    }
  }

  List<Tower> _parseTowerResponse(
      http.Response responseTower, http.Response responseSec) {
    if (responseSec.statusCode == 200) {
      final secResponseMap = jsonDecode(utf8.decode(responseSec.bodyBytes));
      final List<dynamic> secResults = secResponseMap['results'];
      final sectors = secResults.map((item) => Sector.fromJson(item)).toList();

      if (responseTower.statusCode == 200) {
        final towerResponseMap =
            jsonDecode(utf8.decode(responseTower.bodyBytes));
        final List<dynamic> towerResults = towerResponseMap['results'];
        final towers = towerResults.map((item) {
          final tower = Tower.fromJson(item);
          tower.sectors =
              sectors.where((sec) => sec.tower == tower.id).toList();
          return tower;
        }).toList();

        return towers;
      } else {
        throw Exception('Failed to fetch towers');
      }
    } else {
      throw Exception('Failed to fetch sectors');
    }
  }

  List<MultiSurvey> _parseSurveyResponse(http.Response response) {
    if (response.statusCode == 200) {
      final responseMap = jsonDecode(utf8.decode(response.bodyBytes));
      final List<dynamic> results = responseMap['results'];
      final survey = results.map((item) => MultiSurvey.fromJson(item)).toList();
      return survey;
    } else {
      throw Exception('Failed to fetch solutions');
    }
  }

  void handleErrorMessage({String? msg, http.Response? response}) {
    String responseBody = response?.body ?? '';
    Map<String, dynamic>? parsedBody;

    try {
      // Attempt to parse the response body as JSON
      parsedBody = jsonDecode(responseBody);
    } catch (e) {
      // Parsing failed, treat it as plain text
    }

    debugPrint('Status Code: ${response?.statusCode}');
    debugPrint('Response Body:');

    if (parsedBody != null) {
      debugPrint(const JsonEncoder.withIndent('  ').convert(parsedBody));
    } else {
      debugPrint(responseBody);
    }

    showDialog(
      context: navigatorKey.currentState!.context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Response Details'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Status Code: ${response?.statusCode}'),
                const Text('Response Body:'),
                if (parsedBody != null)
                  Text(
                    const JsonEncoder.withIndent('  ').convert(parsedBody),
                    style: const TextStyle(fontFamily: 'monospace'),
                  ),
                if (parsedBody == null) Text(responseBody),
                if (msg != null) Text(msg),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
            TextButton(
              onPressed: () {
                navigatorKey.currentState?.push(
                  MaterialPageRoute(
                    builder: (context) => const LoginPage(),
                  ),
                );
              },
              child: const Text('تسجيل الخروج'),
            ),
          ],
        );
      },
    );
  }
}
