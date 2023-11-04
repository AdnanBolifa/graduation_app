import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:jwt_auth/screens/home.dart';
import 'package:jwt_auth/services/auth_service.dart';
import 'package:jwt_auth/theme/colors.dart';
import 'package:jwt_auth/widgets/text_field.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(
                height: 100,
              ),
              Image.asset('lib/assets/hti_logo.png'),
              const SizedBox(
                height: 50,
              ),
              const Text(
                'تسجيل الدخول',
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 25,
              ),
              textField('إسم المستخدم', 'Hello, World', emailController),
              textField('كلمة المرور', 'sudo su', passwordController,
                  isHide: true),
              ElevatedButton(
                onPressed: () async {
                  var connectivityResult =
                      await (Connectivity().checkConnectivity());
                  if (connectivityResult == ConnectivityResult.none) {
                    // No internet connection
                    Fluttertoast.showToast(
                      msg: "لا يوجد اتصال بالانترنت",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                      backgroundColor: Colors.red,
                      textColor: Colors.white,
                    );
                    return; // Don't proceed with the login if there's no internet connection.
                  }

                  try {
                    final token = await AuthService()
                        .login(emailController.text, passwordController.text);

                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const HomeScreen(),
                      ),
                    );
                    await AuthService().storeTokens(token);
                  } catch (e) {
                    print('Login failed: $e');
                  }
                },
                style: ButtonStyle(
                  minimumSize:
                      MaterialStateProperty.all<Size>(const Size(150, 50)),
                  backgroundColor:
                      MaterialStateProperty.all<Color>(AppColors.primaryColor),
                ),
                child: const Text(
                  'دخول',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
