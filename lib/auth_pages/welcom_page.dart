import 'package:flutter/material.dart';
import 'package:travely/auth_pages/user_signin.dart';
import 'package:travely/auth_pages/user_signup.dart';
import 'package:travely/components/global_variables.dart';
import 'package:travely/home/city_list_screen.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SizedBox(
            height: screenHeight,
            width: screenWidth,
            child: Image.asset(
              bgImage,
              fit: BoxFit.cover,
            ),
          ),
          Container(
            margin: const EdgeInsets.all(20),
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.only(
                      top: screenHeight * 0.05, left: screenWidth * 0.7),
                  child: InkWell(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => CityListScreen()));
                    },
                    child: const Text(
                      'Skip',
                      style: TextStyle(
                        color: Colors.white70,
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: screenHeight * 0.75),
                  width: screenWidth,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => UserSignin()));
                    },
                    child: const Text('Login'),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Don\'t have an account?',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                      ),
                    ),
                    SizedBox(
                      width: screenWidth * 0.015,
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => UserSignUp()));
                      },
                      child: const Text(
                        'Sign-Up',
                        style: TextStyle(
                          color: Colors.lightBlueAccent,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
