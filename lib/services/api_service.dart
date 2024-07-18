// ignore_for_file: non_constant_identifier_names
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:jwt_auth/data/api_config.dart';
import 'package:jwt_auth/data/features_config.dart';
import 'package:jwt_auth/data/history_config.dart';
import 'package:jwt_auth/main.dart';
import 'package:jwt_auth/screens/login.dart';
import 'package:jwt_auth/services/auth_service.dart';

class ApiService {
  static Future<http.Response> submitHeartData(
    BuildContext context,
    TextEditingController sexController,
    TextEditingController patientNameController,
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
    final Heart data = Heart(
      name: patientNameController.text,
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
    final Uri url = Uri.parse(APIConfig.predictUrl);

    final Map<String, dynamic> requestBody = data.toJson();
    requestBody['prediction_type'] = 'heart';
    final response = await http.post(
      url,
      headers: <String, String>{
        'Authorization': 'Bearer $accessToken',
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(requestBody),
    );

    return response;
  }

  static int getPrediction(http.Response response) {
    Map<String, dynamic> responseBody = jsonDecode(response.body);
    return responseBody['prediction'];
  }

  Future<List<History>?> getHistory() async {
    final response = await _performGetRequest(APIConfig.historyUrl);
    if (response.statusCode == 200) {
      try {
        print('request body: ${response.body}');
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

  Future<void> sendPredictionResult(
      int patientHistoryId, bool predictionResult) async {
    final Map<String, dynamic> payload = {
      "patient_history_id": patientHistoryId,
      "prediction_result": predictionResult
    };

    try {
      final response =
          await _performRequest(APIConfig.feedbackUrl, 'POST', payload);
      if (response.statusCode == 200 || response.statusCode == 201) {
        // Handle successful response
        debugPrint('Prediction result sent successfully');
      } else {
        // Handle non-2xx status codes if needed
        debugPrint('Failed to send prediction result: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Error sending prediction result: $e');
    }
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
}
