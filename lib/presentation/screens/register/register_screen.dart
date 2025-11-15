import 'package:app/presentation/screens/register/screen1.dart';
import 'package:flutter/material.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  bool _hidePassword = true;
  bool _hideConfirmPassword = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 28, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Align(
                alignment: Alignment.topLeft,
                child: Image.asset('assets/imgs/app_logo_only_blue.png', height: 60),
              ),
            SizedBox(height: 30),
            
            Text(
              'Register',
              style: TextStyle(
                fontSize: 40, 
                fontWeight: FontWeight.bold),
            ),
            
            SizedBox(height: 30),
            
            TextField(
              decoration: InputDecoration(
                labelText: "Email Address",
                hintText: "helloweenski@gmail.com",
                border: const UnderlineInputBorder(),
              ),
            ),
            
            SizedBox(height: 24),
            
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
            
            SizedBox(height: 24),
            
            TextField(
              obscureText: _hideConfirmPassword,
              decoration: InputDecoration(
                labelText: "Confirm Password",
                border: const UnderlineInputBorder(),
                suffixIcon: IconButton(
                  icon: Icon(
                    _hideConfirmPassword 
                    ? Icons.visibility_off_outlined 
                    : Icons.visibility_outlined),
                  onPressed: () {
                    setState(() {
                      _hideConfirmPassword = !_hideConfirmPassword;
                    });
                  },
                ),
              ),
            ),
            
            SizedBox(height: 40),
            
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const Screen1(),
                      ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFFF1F70),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(28),
                  ),
                ),
                child: Text(
                  'Sign Up',
                  style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            
            SizedBox(height: 32),
            
            Row(
              children: [
                Expanded(child: Divider()),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Text('or', style: TextStyle(color: Colors.grey[600])),
                ),
                Expanded(child: Divider()),
              ],
            ),
            
            SizedBox(height: 25),
            
            Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _socialButton('assets/imgs/icn_google.png', () {
                    
                  }),
                  const SizedBox(width: 25),
                  _socialButton('assets/imgs/icn_facebook.png', () {
                    
                  }),
                ],
              ),
              SizedBox(height: 40),
            
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Already have an account? ', style: TextStyle(color: Colors.grey)),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushReplacementNamed(context, '/login');
                    },
                    child: const Text(
                    'Login',
                    style: TextStyle(color: Color(0xFF6C5CE7), fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
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
}