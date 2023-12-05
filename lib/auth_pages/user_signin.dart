import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:travely/auth_pages/user_signup.dart';
import 'package:travely/components/global_variables.dart';
import 'forgot_password.dart';

class UserSignin extends StatefulWidget {
  const UserSignin({Key? key}) : super(key: key);

  @override
  _UserSignInState createState() => _UserSignInState();
}

class _UserSignInState extends State<UserSignin> {
  final TextEditingController emailTextController = TextEditingController();
  final TextEditingController passwordTextController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _passwordVisible = false;
  bool _rememberMe = false;

  void _validatePassword(String password) {
    if (password.length < 8) {
      _showSnackbar('Password must be at least 8 characters.');
    }
  }

  void _showSnackbar(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  String? _validateEmail(value) {
    if (value.isEmpty) {
      return 'Enter email';
    }
    RegExp regExp = RegExp(r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$');
    if (!regExp.hasMatch(value)) {
      return 'Please enter a valid email';
    }
    return null;
  }

  void _passwordVisibility() {
    setState(() {
      _passwordVisible = !_passwordVisible;
    });
  }

  Future<void> saveUserCredentials(String email, String password) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('userEmail', email);
    prefs.setString('userPassword', password);
    print('User credentials saved: $prefs');
  }

  Future<void> clearUserCredentials() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('userEmail');
    prefs.remove('userPassword');
  }

  Future<void> login(String email, String password) async {
    try {
      Response response = await post(
        Uri.parse('https://travelapp.redstonz.com/api/v1/auth/sign-in'),
        body: {
          'email': email,
          'password': password,
        },
      );

      Map<String, dynamic> responseBody = json.decode(response.body);

      if (response.statusCode == 200) {
        if (responseBody.containsKey('mesg') &&
            responseBody['mesg'] == 'login success') {
          print('Login Successfully');
          // Save user credentials if "Remember Me" is selected
          if (_rememberMe) {
            print('Remember me status is: $_rememberMe');
            await saveUserCredentials(email, password);
          } else if (!_rememberMe) {
            print('User is Logged in without storing credentials');
            await clearUserCredentials();
          }

          // No need for navigation, as it is handled in WelcomePage
        } else {
          String errorMessage =
              responseBody['mesg'] ?? 'An unknown error occurred';
          print('Login Failed: $errorMessage');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              margin: EdgeInsets.only(bottom: screenHeight * 0.9),
              behavior: SnackBarBehavior.floating,
              backgroundColor: Colors.red.shade600,
              content: Text('Failed to sign in. $errorMessage'),
            ),
          );
        }
      } else {
        print('Login Failed: Unknown error');
        print('Response Body: $responseBody');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content:
                Text('Sign in failed. Check your credentials and try again.'),
          ),
        );
      }
    } catch (e) {
      print('Error during login: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            color: Colors.indigo.shade100,
          ),
          Container(
            decoration: const BoxDecoration(
              color: Colors.black,
              image: DecorationImage(
                colorFilter: ColorFilter.mode(
                  Colors.black12,
                  BlendMode.darken,
                ),
                image: AssetImage('assets/images/travelBG.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Form(
            key: _formKey,
            child: ListView(
              padding: EdgeInsets.only(
                top: screenHeight * 0.6,
              ),
              children: [
                Container(
                  margin: EdgeInsets.only(
                    left: screenWidth * 0.04,
                    right: screenWidth * 0.04,
                    top: screenHeight * 0.01,
                  ),
                  padding: EdgeInsets.only(
                    left: screenWidth * 0.06,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white70,
                  ),
                  child: TextFormField(
                    controller: emailTextController,
                    decoration: const InputDecoration(
                      hintText: 'Email',
                      border: InputBorder.none,
                    ),
                    validator: _validateEmail,
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(
                    left: screenWidth * 0.04,
                    right: screenWidth * 0.04,
                    top: screenHeight * 0.02,
                  ),
                  padding: EdgeInsets.only(
                    left: screenWidth * 0.06,
                    top: screenWidth * 0.0,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white70,
                  ),
                  child: TextFormField(
                    controller: passwordTextController,
                    obscureText: !_passwordVisible,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Enter Password',
                      suffixIcon: GestureDetector(
                        onTap: _passwordVisibility,
                        child: Tooltip(
                          message: _passwordVisible
                              ? 'Hide password'
                              : 'Show password',
                          child: Icon(
                            _passwordVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                            size: 20,
                          ),
                        ),
                      ),
                    ),
                    validator: (value) {
                      if (value!.isEmpty || value.length < 8) {
                        _validatePassword(value);
                        return 'Please enter a valid password (at least 8 characters).';
                      }
                      return null;
                    },
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(
                    left: screenWidth * 0.0,
                    top: screenHeight * 0.0,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Checkbox(
                        checkColor: Colors.black,
                        activeColor: Colors.white,
                        value: _rememberMe,
                        onChanged: (value) {
                          setState(() {
                            _rememberMe = !_rememberMe;
                            print('RememberMe status: $_rememberMe');
                          });
                        },
                      ),
                      const Text(
                        'Remember me',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(
                        width: screenWidth * 0.25,
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => ForgotPasswordPage()));
                        },
                        child: const Text(
                          'Forgot Password',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w300,
                            fontFamily: 'SourceSans3',
                            color: Colors.white70,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  height: screenHeight * 0.06,
                  width: screenWidth,
                  margin: EdgeInsets.only(
                    left: screenWidth * 0.04,
                    right: screenWidth * 0.04,
                    top: screenHeight * 0.06,
                    bottom: screenHeight * 0.01,
                  ),
                  child: ElevatedButton(
                    onPressed: () {
                      login(
                        emailTextController.text,
                        passwordTextController.text,
                      );
                    },
                    child: const Text(
                      'Sign in',
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'If you don\'t have an account.',
                      style: TextStyle(color: Colors.white, fontSize: 14),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => const UserSignUp()));
                      },
                      child: const Text(
                        ' Sign-up',
                        style: TextStyle(
                          color: Colors.blue,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
