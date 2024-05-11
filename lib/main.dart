import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jwt_auth/screens/history.dart';
import 'package:jwt_auth/screens/login.dart';
import 'package:jwt_auth/services/auth_service.dart';
import 'package:jwt_auth/screens/home.dart';
import 'package:jwt_auth/theme/colors.dart';
import 'package:jwt_auth/theme/theme.dart';

GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: AppColors.primaryColor,
    ),
  );

  WidgetsFlutterBinding.ensureInitialized();

  final accessToken = await AuthService().getAccessToken();
  debugPrint('Access Token: $accessToken');
  runApp(
    MyApp(
      accessToken: accessToken,
    ),
  );
}

class MyApp extends StatelessWidget {
  final String? accessToken;

  const MyApp({Key? key, this.accessToken}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Heart Disease Predictor',
      initialRoute: accessToken != null ? '/' : '/login',
      routes: {
        '/': (context) => HomeScreen(),
        '/history': (context) => const HistoryPage(),
        '/login': (context) => const LoginPage(),
      },
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      theme: customTheme,
    );
  }
}
