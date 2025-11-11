import 'package:app/core/widgets/button_widget.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _hidePassword = true;
  bool _hideConfirmPassword = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // App Logo (top-left)
              Align(
                alignment: Alignment.topLeft,
                child: Image.asset(
                  'assets/imgs/app_logo_only_blue.png',
                  height: 60,
                ),
              ),
              const SizedBox(height: 30),

              // Title
              const Text(
                "Log In",
                style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 30),

              // Email Field
              TextField(
                decoration: InputDecoration(
                  labelText: "Email Address",
                  hintText: "helloweeniski@gmail.com",
                  border: const UnderlineInputBorder(),
                ),
              ),
              const SizedBox(height: 24),

              // Password Field
              TextField(
                obscureText: _hidePassword,
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
              const SizedBox(height: 24),

              // Confirm Password Field
              TextField(
                obscureText: _hideConfirmPassword,
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
              const SizedBox(height: 40),

              ButtonWidget.rectangle(
                context: context,
                text: "Log In",
                width: MediaQuery.of(context).size.width,
                type: ButtonType.primary,
                onPressed: () {
                  Navigator.pushReplacementNamed(context, '/home');
                },
              ),
              const SizedBox(height: 32),

              // Divider with “or”
              Row(
                children: [
                  const Expanded(
                    child: Divider(thickness: 1, color: Colors.grey),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      "or",
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  ),
                  const Expanded(
                    child: Divider(thickness: 1, color: Colors.grey),
                  ),
                ],
              ),
              const SizedBox(height: 25),

              // Social Login Buttons (using your assets)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _socialButton('assets/imgs/icn_google.png', () {
                    // TODO: Google login
                  }),
                  const SizedBox(width: 25),
                  _socialButton('assets/imgs/icn_facebook.png', () {
                    // TODO: Facebook login
                  }),
                ],
              ),
              const SizedBox(height: 40),

              // 🔹 Sign Up link
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Don’t have an account? ",
                    style: TextStyle(color: Colors.grey),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushReplacementNamed(context, '/register');
                    },
                    child: const Text(
                      "Sign Up",
                      style: TextStyle(
                        color: Colors.pinkAccent,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Custom image social button
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
}
