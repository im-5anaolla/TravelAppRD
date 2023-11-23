import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:travely/auth_pages/welcom_page.dart';
import 'package:travely/home/city_list_screen.dart';
import 'components/global_variables.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    Future<bool> isUserLoggedIn() async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? userIdentifier = prefs.getString('userIdentifier');
      print('User prefs: $userIdentifier');
      return userIdentifier != null;
    }

    bgImage = 'assets/images/BGTravel.jpg';

    return FutureBuilder(
      future: isUserLoggedIn(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.data == true) {
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              home: CityListScreen(),
            );
          } else {
            return const MaterialApp(
              debugShowCheckedModeBanner: false,
              home: WelcomePage(),
            );
          }
        } else {
          return const MaterialApp(
            debugShowCheckedModeBanner: false,
            home: Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            ),
          );
        }
      },
    );

    // return MaterialApp(
    //   debugShowCheckedModeBanner: false,
    //     home: CityListScreen(),
    // );
  }
}
