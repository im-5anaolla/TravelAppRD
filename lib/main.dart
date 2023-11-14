import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:travely/home/city_list_screen.dart';
import 'package:travely/home/city_sectors.dart';
import 'auth_pages/welcom_page.dart';
import 'cities/interest_point.dart';
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
    bgImage = 'assets/images/BGTravel.jpg';
    return  const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: WelcomePage(),
    );
  }
}
