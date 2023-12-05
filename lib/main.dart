import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:travely/home/city_list_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'auth_pages/welcom_page.dart';
import 'components/global_variables.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key});

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    Future<bool> isUserLoggedIn() async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? userIdentifier = prefs.getString('userIdentifier');
      print('Login status: $userIdentifier');
      return userIdentifier != null;
    }

    bgImage = 'assets/images/BGTravel.jpg';

    return FutureBuilder(
      future: isUserLoggedIn(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            home: snapshot.data == true ? CityListScreen() : WelcomePage(),
          );
        } else {
          return const MaterialApp(
            debugShowCheckedModeBanner: false,
            home: Scaffold(
              body: Center(
                child: CircularProgressIndicator(
                  color: Colors.black26,
                  strokeWidth: 3.0,
                ),
              ),
            ),
          );
        }
      },
    );
  }
}
