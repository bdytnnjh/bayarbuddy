import 'package:app/core/widgets/button_widget.dart';
import 'package:app/presentation/screens/register/providers/register_providers.dart';
import 'package:app/presentation/screens/register/set_up_name.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _hidePassword = true;
  bool _hideConfirmPassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _handleSignUp() async {
    // Validate input
    if (_emailController.text.trim().isEmpty) {
      _showError('Please enter your email');
      return;
    }

    if (_passwordController.text.isEmpty) {
      _showError('Please enter your password');
      return;
    }

    if (_passwordController.text != _confirmPasswordController.text) {
      _showError('Passwords do not match');
      return;
    }

    if (_passwordController.text.length < 6) {
      _showError('Password must be at least 6 characters');
      return;
    }

    // Register with email and password
    final registerProvider = Provider.of<RegisterProvider>(
      context,
      listen: false,
    );
    final success = await registerProvider.registerWithEmailPassword(
      email: _emailController.text.trim(),
      password: _passwordController.text,
    );

    if (success && mounted) {
      // Navigate to setup name screen
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const SetUpNameScreen()),
      );
    } else if (registerProvider.error != null && mounted) {
      _showError(registerProvider.error!);
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  Widget _socialButton(String assetPath, VoidCallback onPressed) {
    return Container(
      height: 50,
      width: 50,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.grey.shade300, width: 1.5),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(25),
        onTap: onPressed,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Image.asset(assetPath),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 28, vertical: 20),
          child: Consumer<RegisterProvider>(
            builder: (context, registerProvider, child) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Align(
                    alignment: Alignment.topLeft,
                    child: Image.asset(
                      'assets/imgs/app_logo_only_blue.png',
                      height: 60,
                    ),
                  ),
                  SizedBox(height: 30),

                  Text(
                    'Register',
                    style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
                  ),

                  SizedBox(height: 30),

                  TextField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    enabled: !registerProvider.isLoading,
                    decoration: InputDecoration(
                      labelText: "Email Address",
                      hintText: "helloweenski@gmail.com",
                      border: const UnderlineInputBorder(),
                    ),
                  ),

                  SizedBox(height: 24),

                  TextField(
                    controller: _passwordController,
                    obscureText: _hidePassword,
                    enabled: !registerProvider.isLoading,
                    decoration: InputDecoration(
                      labelText: "Password",
                      border: const UnderlineInputBorder(),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _hidePassword
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                        ),
                        onPressed: () {
                          setState(() {
                            _hidePassword = !_hidePassword;
                          });
                        },
                      ),
                    ),
                  ),

                  SizedBox(height: 24),

                  TextField(
                    controller: _confirmPasswordController,
                    obscureText: _hideConfirmPassword,
                    enabled: !registerProvider.isLoading,
                    decoration: InputDecoration(
                      labelText: "Confirm Password",
                      border: const UnderlineInputBorder(),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _hideConfirmPassword
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                        ),
                        onPressed: () {
                          setState(() {
                            _hideConfirmPassword = !_hideConfirmPassword;
                          });
                        },
                      ),
                    ),
                  ),

                  SizedBox(height: 40),

                  Center(
                    child: registerProvider.isLoading
                        ? CircularProgressIndicator()
                        : ButtonWidget.rectangle(
                            context: context,
                            type: ButtonType.primary,
                            width: 200,
                            text: 'Sign Up',
                            onPressed: _handleSignUp,
                          ),
                  ),

                  SizedBox(height: 32),

                  Row(
                    children: [
                      Expanded(child: Divider()),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          'or',
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                      ),
                      Expanded(child: Divider()),
                    ],
                  ),

                  SizedBox(height: 25),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _socialButton('assets/imgs/icn_google.png', () {}),
                      const SizedBox(width: 25),
                      _socialButton('assets/imgs/icn_facebook.png', () {}),
                    ],
                  ),
                  SizedBox(height: 40),

                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Already have an account? ',
                          style: TextStyle(color: Colors.grey),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.pushReplacementNamed(context, '/login');
                          },
                          child: const Text(
                            'Login',
                            style: TextStyle(
                              color: Color(0xFF6C5CE7),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
