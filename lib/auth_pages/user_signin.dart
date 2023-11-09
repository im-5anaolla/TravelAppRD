import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:travely/auth_pages/forgot_password.dart';
import 'package:travely/auth_pages/user_signup.dart';
import 'package:travely/components/global_variables.dart';
import '../home/city_list_screen.dart';

class UserSignin extends StatefulWidget {
  const UserSignin({Key? key}) : super(key: key);

  @override
  _UserSignUpState createState() => _UserSignUpState();
}

class _UserSignUpState extends State<UserSignin> {
  final TextEditingController emailTextController = TextEditingController();
  final TextEditingController passwordTextController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _passwordVisible = false;

  void passwordVisibility() {
    setState(() {
      _passwordVisible = !_passwordVisible; //Switched into true.
    });
  }

  login(String email, String password) async {
    try {
      Response response = await post(
          Uri.parse('https://travelapp.redstonz.com/api/v1/auth/sign-in'),
          body: {
            'email': email,
            'password': password,
          });
      if (response.statusCode == 200) {
        print('Login Successfully');
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => CityListScreen()));
      } else {
        print('Login Failed');
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Sign in faild')));
      }
    } catch (e) {
      print('Error: $e');
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
          // Background Image
          Container(
            height: double.maxFinite,
            decoration: const BoxDecoration(
              color: Colors.black,
              image: DecorationImage(
                colorFilter: ColorFilter.mode(Colors.black12, BlendMode.darken),
                image: AssetImage('assets/images/travelBG.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Form
          Form(
            key: _formKey,
            child: ListView(
              padding:  EdgeInsets.only(
                top: screenHeight * 0.6,
              ),
              children: [
                // Email/Phone TextField
                Container(
                  height: screenHeight * 0.065,
                  margin: EdgeInsets.only(left: screenWidth * 0.04, right: screenWidth * 0.04, top: screenHeight * 0.01),
                  padding:  EdgeInsets.only(left: screenWidth * 0.06,),
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
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter your email/phone.';
                      }
                      return null;
                    },
                  ),
                ),
                // Password TextField
                Container(
                    height: screenHeight * 0.06,
                  margin:  EdgeInsets.only(left: screenWidth * 0.04, right: screenWidth * 0.04, top: screenHeight * 0.01),
                  padding:  EdgeInsets.only(left: screenWidth * 0.06),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white70,
                  ),
                  child: TextFormField(
                    controller: passwordTextController,
                    obscureText: !_passwordVisible,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Password',
                      suffixIcon: GestureDetector(
                        onTap: passwordVisibility,
                        child: Icon(
                          _passwordVisible
                              ? Icons.visibility
                              : Icons.visibility_off,
                          size: 20,
                        ),
                      ),
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter a password.';
                      }
                      return null;
                    },
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: screenWidth * 0.68, top: screenHeight * 0.01),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                          (context),
                          MaterialPageRoute(
                              builder: (context) => ForgotPasswordPage()));
                    },
                    child: const Text(
                      "Forgot Password",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w300,
                        fontFamily: 'SourceSans3',
                        color: Colors.white70,
                      ),
                    ),
                  ),
                ),
                // Submit Button
                Container(
                  height: screenHeight * 0.06,
                  width: screenWidth,
                  margin: EdgeInsets.only(
                      left: screenWidth * 0.04, right: screenWidth * 0.04, top: screenHeight * 0.06, bottom: screenHeight * 0.01),
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
                // Log-in Link
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('If you don\'t have an account.',
                        style: TextStyle(color: Colors.white, fontSize: 14)),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => const UserSignUp()));
                      },
                      child: const Text(' Sign-up',
                          style: TextStyle(
                            color: Colors.blue,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          )),
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
