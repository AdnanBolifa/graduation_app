import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jwt_auth/screens/bottom_nav_bar.dart';
import 'package:jwt_auth/screens/history.dart';
import 'package:jwt_auth/screens/login.dart';
import 'package:jwt_auth/screens/signup.dart';
import 'package:jwt_auth/services/auth_service.dart';
import 'package:jwt_auth/theme/colors.dart';
import 'package:jwt_auth/theme/theme.dart';
import 'package:jwt_auth/widgets/inhert.dart'; 

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

class MyApp extends StatefulWidget {
  final String? accessToken;

  const MyApp({Key? key, this.accessToken}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _selectedDataset = 'Basic';

  void _updateDataset(String newDataset) {
    setState(() {
      _selectedDataset = newDataset;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SettingsProvider(
      selectedDataset: _selectedDataset,
      child: MaterialApp(
        title: 'Heart Disease Predictor',
        initialRoute: widget.accessToken != null ? '/' : '/login',
        routes: {
          '/': (context) => BottomNav(updateDataset: _updateDataset),
          '/history': (context) => const HistoryPage(),
          '/login': (context) => const LoginPage(),
          '/signup': (context) => const SignUpPage(),
        },
        navigatorKey: navigatorKey,
        debugShowCheckedModeBanner: false,
        theme: customTheme,
      ),
    );
  }
}
