import 'package:flutter/material.dart';
import 'package:travely/auth_pages/user_signin.dart';

class ForgotPasswordPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: EdgeInsets.only(top: 20),
                width: double.maxFinite,
                height: 300,
                child: Image.asset('assets/images/forgotPasswordOne.jpg'),
              ),
              SizedBox(height: 10),
              const Text(
                'Forgot Password',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'SourceSans3',
                  letterSpacing: 1,
                ),
              ),
              SizedBox(height: 10),
              const Text(
                'Enter your email to reset your password',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
              SizedBox(height: 30),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Email',
                  prefixIcon: Icon(Icons.email),
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  // Implement password reset logic
                },
                child: Text('Reset Password'),
              ),
              SizedBox(height: 10),
              TextButton(
                onPressed: () {
                  Navigator.push((context), MaterialPageRoute(builder: (context) => UserSignin()));
                },
                child: Text('Back to Sign In'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
