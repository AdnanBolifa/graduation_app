import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jwt_auth/data/API_Config.dart';

class AuthService {
  final storage = const FlutterSecureStorage();

  Future<String> login(String email, String password) async {
    if (email.isEmpty || password.isEmpty) {
      throw ArgumentError('Email and password must not be empty');
    }

    final response = await http.post(Uri.parse(APIConfig.loginUrl), body: {
      'email': email,
      'password': password,
    });

    if (response.statusCode == 200) {
      return response.body;
    } else if (response.statusCode == 401) {
      Fluttertoast.showToast(msg: 'بيانات خاطئة!');
      throw Exception('Failed to log in: ${response.statusCode}');
    } else {
      Fluttertoast.showToast(msg: 'حدث خطأ ما!');
      throw Exception('Failed to log in: ${response.statusCode}');
    }
  }

  Future<void> storeTokens(String apiResponse) async {
    final Map<String, dynamic> tokens = jsonDecode(apiResponse);
    final String? refreshToken = tokens['refresh'];
    final String? accessToken = tokens['access'];

    if (refreshToken != null) {
      await storage.write(key: 'refresh_token', value: refreshToken);
    }

    if (accessToken != null) {
      await storage.write(key: 'access_token', value: accessToken);
    }
  }

  Future<String?> getRefreshToken() async {
    return await storage.read(key: 'refresh_token');
  }

  Future<String?> getAccessToken() async {
    return await storage.read(key: 'access_token');
  }

  Future<void> getNewAccessToken() {
    return getRefreshToken().then((refreshToken) async {
      final response = await http.post(Uri.parse(APIConfig.refreshUrl), body: {
        'refresh': refreshToken,
      });

      if (response.statusCode == 200) {
        debugPrint('=============================');
        debugPrint('refreshed');
        storeTokens(response.body);
      } else {
        throw Exception('Failed to log in');
      }
    });
  }

  Future<void> logout() async {
    // Remove both the access and refresh tokens when the user logs out.
    await storage.delete(key: 'access_token');
    await storage.delete(key: 'refresh_token');
  }
}
