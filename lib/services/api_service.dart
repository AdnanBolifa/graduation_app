import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:jwt_auth/data/api_config.dart';
import 'package:jwt_auth/data/comment_config.dart';
import 'package:jwt_auth/data/location_config.dart';
import 'package:jwt_auth/data/problem_config.dart';
import 'package:jwt_auth/data/ticket_config.dart';
import 'package:jwt_auth/data/solution_config.dart';
import 'package:jwt_auth/screens/login.dart';
import 'package:jwt_auth/services/auth_service.dart';

class ApiService {
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

  Future<List<Ticket>> getReports(context) async {
    final authService = AuthService();

    final response = await _performAuthenticatedGetRequest(
        APIConfig.reportsUrl, authService, context);

    if (response.statusCode == 200) {
      try {
        final responseMap = jsonDecode(utf8.decode(response.bodyBytes));
        final List<dynamic> data = responseMap['results'];

        final users = data.map((user) => Ticket.fromJson(user)).toList();
        return users;
      } catch (e) {
        debugPrint('Error parsing JSON: $e');
      }
    } else {
      debugPrint('Request failed with status code: ${response.statusCode}');
      debugPrint('Response content: ${response.body}');
    }

    return [];
  }

  Future<List<Problem>> fetchProblems() async {
    final response = await _performGetRequest(APIConfig.problemsUrl);
    return _parseProblemsResponse(response);
  }

  Future<List<CommentData>> fetchComments() async {
    final authService = AuthService();
    final response = await _performAuthenticatedGetRequest(
        APIConfig.reportsUrl, authService);
    return _parseCommentsResponse(response);
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
    await _performPostRequest('${APIConfig.timer}$ticket/start', body);
  }

  Future<void> fetchSurvey() async {}

  Future<void> submitSurvey(int id, List<String> answers, int count) async {
    final List<Map<String, dynamic>> answersList = [];

    for (int i = 1; i <= count; i++) {
      answersList.add({
        "question": i,
        "answer": answers[i - 1],
      });
    }

    final body = {
      "ticket": id,
      "answers_list": answersList,
    };

    await _performPostRequest(APIConfig.submitSurvey, body);
  }

  //helper functions
  Future<http.Response> _performGetRequest(String url) async {
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      return response;
    } else {
      throw Exception('Failed to fetch data');
    }
  }

  Future<void> _performPostRequest(String url, dynamic body) async {
    final accessToken = await AuthService().getAccessToken();
    final response = await http.post(
      Uri.parse(url),
      body: jsonEncode(body),
      headers: {
        'Authorization': 'Bearer $accessToken',
        'Content-Type': 'application/json',
      },
    );
    if (response.statusCode == 201 || response.statusCode == 200) {
      Fluttertoast.showToast(
        msg: "تمت اضافة البيانات بنجاح!",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        textColor: Colors.white,
      );
    } else {
      Fluttertoast.showToast(
        msg: "لم تمت عملية الاضافة!",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        textColor: Colors.white,
      );
      throw Exception('Failed to add data: ${response.body}');
    }
  }

  Future<void> _performPutRequest(String url, dynamic body) async {
    final accessToken = await AuthService().getAccessToken();
    final response = await http.put(
      Uri.parse(url),
      body: jsonEncode(body),
      headers: {
        'Authorization': 'Bearer $accessToken',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      Fluttertoast.showToast(
        msg: "تم تحديث البيانات بنجاح!",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        textColor: Colors.white,
      );
    } else {
      Fluttertoast.showToast(
        msg: "!لم يتم التحديث",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        textColor: Colors.white,
      );
      throw Exception('Failed to update data: ${response.statusCode}');
    }
  }

  Future<http.Response> _performAuthenticatedGetRequest(
      String url, AuthService authService,
      [BuildContext? context]) async {
    final accessToken = await authService.getAccessToken();
    final response = await http.get(Uri.parse(url), headers: {
      'Authorization': 'Bearer $accessToken',
    });

    if (response.statusCode == 401) {
      await authService.getNewAccessToken();
      return _performAuthenticatedGetRequest(url, authService, context);
    } else if (response.statusCode != 200 && context != null) {
      if (context.mounted) {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => const LoginPage(),
        ));
      }
      authService.logout();
    }

    return response;
  }

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

  List<CommentData> _parseCommentsResponse(http.Response response) {
    if (response.statusCode == 200) {
      final responseMap = jsonDecode(utf8.decode(response.bodyBytes));
      final List<dynamic> results = responseMap['results'];

      final comments =
          results.map((item) => CommentData.fromJson(item)).toList();
      return comments;
    } else {
      throw Exception('Failed to fetch comments');
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
}
