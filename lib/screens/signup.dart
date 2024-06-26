import 'package:flutter/material.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  bool _isDoctor = false;

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    bool isVisible = true,
    bool isNumber = true,
    bool isPassword = false,
    String? hint,
  }) {
    return Visibility(
      visible: isVisible,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Align(
              alignment: Alignment.center,
              child: TextField(
                obscureText: isPassword,
                controller: controller,
                decoration: InputDecoration(
                  labelText: label,
                  hintText: hint ?? "",
                  border: InputBorder.none,
                ),
                keyboardType:
                    isNumber ? TextInputType.number : TextInputType.text,
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign Up'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: _buildTextField(
                      controller: _firstNameController,
                      label: 'First Name',
                      hint: 'Enter your first name',
                    ),
                  ),
                  Expanded(
                    child: _buildTextField(
                      controller: _lastNameController,
                      label: 'Last Name',
                      hint: 'Enter your last name',
                    ),
                  ),
                ],
              ),
              _buildTextField(
                controller: _usernameController,
                label: 'Username',
                hint: 'Enter your username',
              ),
              _buildTextField(
                controller: _emailController,
                label: 'Email',
                hint: 'Enter your email',
              ),
              _buildTextField(
                controller: _passwordController,
                label: 'Password',
                isPassword: true,
                hint: 'Enter your password',
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Are you a doctor?'),
                    Switch(
                      value: _isDoctor,
                      onChanged: (bool value) {
                        setState(() {
                          _isDoctor = value;
                        });
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    // Handle sign-up logic here
                    final signUpData = {
                      "email": _emailController.text,
                      "username": _usernameController.text,
                      "password": _passwordController.text,
                      "first_name": _firstNameController.text,
                      "last_name": _lastNameController.text,
                      "isDoctor": _isDoctor,
                    };
                    print(signUpData);
                  },
                  child: const Text('Sign Up'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
