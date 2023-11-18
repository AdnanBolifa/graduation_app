import 'package:flutter/material.dart';
import 'package:connectivity/connectivity.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:jwt_auth/screens/home.dart';
import 'package:jwt_auth/services/api_service.dart';
import 'package:jwt_auth/services/auth_service.dart';
import 'package:jwt_auth/theme/colors.dart';
import 'package:jwt_auth/widgets/text_field.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isLoading = false; // Flag to track the loading state.

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(height: 150),
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
              textField('إسم المستخدم', 'Hello, World', emailController, isRight: false),
              textField('كلمة المرور', 'sudo su', passwordController, isHide: true, isRight: false),
              ElevatedButton(
                onPressed: isLoading
                    ? null
                    : () async {
                        var connectivityResult = await (Connectivity().checkConnectivity());
                        if (connectivityResult == ConnectivityResult.none) {
                          // No internet connection
                          Fluttertoast.showToast(
                            msg: "لا يوجد اتصال بالانترنت",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            backgroundColor: Colors.red,
                            textColor: Colors.white,
                          );
                          return;
                        }
                        setState(() {
                          isLoading = true;
                        });
                        try {
                          final token = await AuthService().login(emailController.text, passwordController.text);

                          await AuthService().storeTokens(token);
                          if (context.mounted) {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => const HomeScreen(),
                              ),
                            );
                          }
                        } catch (e) {
                          ApiService().handleErrorMessage(msg: "LOGIN ERROR: $e");
                        } finally {
                          setState(() {
                            isLoading = false;
                          });
                        }
                      },
                style: ButtonStyle(
                  minimumSize: MaterialStateProperty.all<Size>(const Size(150, 50)),
                  backgroundColor: MaterialStateProperty.all<Color>(AppColors.primaryColor),
                ),
                child: isLoading
                    ? const CircularProgressIndicator()
                    : const Text(
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
