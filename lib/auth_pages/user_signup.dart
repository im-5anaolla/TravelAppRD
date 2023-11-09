import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:travely/auth_pages/user_signin.dart';
import 'package:travely/home/city_list_screen.dart';

class UserSignUp extends StatefulWidget {
  const UserSignUp({Key? key}) : super(key: key);

  @override
  _UserSignUpState createState() => _UserSignUpState();
}

class _UserSignUpState extends State<UserSignUp> {
  final TextEditingController emailTextController = TextEditingController();
  final TextEditingController passwordTextController = TextEditingController();
  final TextEditingController nameTextController = TextEditingController();
  final TextEditingController mobileNumberController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool _passwordVisible = false;

  void _passwordVisibility() {
    setState(() {
      _passwordVisible = !_passwordVisible;
    });
  }

  void _showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('')));
  }

  //Weak password snackBar message
  void _validatePassword(String password) {
    if (password.length < 8) {
      _showSnackbar('Password must be atleast 8 charecters.');
    } else {
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => CityListScreen()));
    }
  }

  void signUP(
      String name, String email, String mobileNumber, String password) async {
    try {
      Response response = await http.post(
        Uri.parse('https://travelapp.redstonz.com/api/v1/auth/sign-up'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'email': email,
          'password': password,
          'name': name,
          'mobile_no': mobileNumber,
        }),
      );

      if (response.statusCode == 200) {
        print('Account Created Successfully');
      } else {
        print('An error occurred while creating an account.');
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
          // Background Image
          Container(
            height: double.maxFinite,
            decoration: const BoxDecoration(
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
              padding: const EdgeInsets.only(
                top: 300,
                left: 16.0,
                right: 16.0,
              ),
              children: [
                // Name TextField
                Container(
                  margin: const EdgeInsets.only(
                    left: 30,
                    right: 30,
                  ),
                  padding: const EdgeInsets.only(left: 20, right: 5),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white70,
                  ),
                  child: TextFormField(
                    controller: nameTextController,
                    decoration: const InputDecoration(
                      hintText: 'Enter your name',
                      border: InputBorder.none,
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter your name.';
                      }
                      return null;
                    },
                  ),
                ),
                // Email/Phone TextField
                Container(
                  margin: const EdgeInsets.only(left: 30, right: 30, top: 15),
                  padding: const EdgeInsets.only(left: 20, right: 5),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white70,
                  ),
                  child: TextFormField(
                    controller: emailTextController,
                    decoration: const InputDecoration(
                        hintText: 'Enter Email', border: InputBorder.none),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter your email/phone.';
                      }
                      return null;
                    },
                  ),
                ),

                Container(
                  margin: const EdgeInsets.only(left: 30, right: 30, top: 15),
                  padding: const EdgeInsets.only(left: 20, right: 5),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white70,
                  ),
                  child: TextFormField(
                    controller: mobileNumberController,
                    keyboardType: TextInputType.phone,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Phone',
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter a phone number.';
                      }
                      return null;
                    },
                  ),
                ),

                // Password TextField
                Container(
                  margin: const EdgeInsets.only(left: 30, right: 30, top: 15),
                  padding: const EdgeInsets.only(left: 20, right: 5),
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
                          child: Icon(
                            _passwordVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                            size: 20,
                          ),
                        )),
                    validator: (value) {
                      if (value!.isEmpty && value.length < 12) {
                        _validatePassword(value);
                      }
                      return null;
                    },
                  ),
                ),

                ///This code sign-up users with api server.
                Container(
                  margin: EdgeInsets.all(50),
                  height: 40,
                  width: 100,
                  decoration: BoxDecoration(color: Colors.blue),
                  child: Center(
                    child: GestureDetector(
                      onTap: () {
                        signUP(
                          nameTextController.text.toString(),
                          emailTextController.text.toString(),
                          mobileNumberController.text.toString(),
                          passwordTextController.text.toString(),
                        );
                      },
                      child: const Text(
                        'Sign Up',
                        style: TextStyle(
                          fontSize: 18,
                          fontFamily: 'SourceSans3',
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: 1,
                        ),
                      ),
                    ),
                  ),
                ),

                // Log-in Link
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('If you already have an account.',
                        style: TextStyle(color: Colors.white, fontSize: 14)),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => const UserSignin()));
                      },
                      child: const Text(' Log-in',
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
