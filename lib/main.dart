import 'package:flutter/material.dart';
import 'package:jwt_auth/screens/login.dart';
import 'package:jwt_auth/services/auth_service.dart';
import 'package:jwt_auth/screens/home.dart';
import 'package:jwt_auth/theme/colors.dart';
import 'package:flutter/services.dart';
import 'package:jwt_auth/theme/theme.dart';

//todo make every field in the add ticket page required

void main() async {
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: AppColors.primaryColor,
  ));

  WidgetsFlutterBinding.ensureInitialized();

  final accessToken = await AuthService().getAccessToken();
  debugPrint('Access Token: $accessToken');
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: accessToken != null ? const HomeScreen() : const LoginPage(),
      theme: customTheme,
    ),
  );
}
