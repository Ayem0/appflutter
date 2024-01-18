import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:app_android/firebase_options.dart';
import 'package:app_android/screens/localisationChoisirPage_screen.dart';
import 'package:app_android/screens/localisationpage_screen.dart';
import 'package:app_android/screens/offerdetail_screen.dart';
import 'package:app_android/screens/register_pro_screen.dart';
import 'package:app_android/widgets/homepage/homepage_accueil.dart';
import '../screens/homepage_screen.dart';
import '../screens/launchingpage_screen.dart';
import '../screens/sign_in_page_screen.dart';
import '../screens/register_page_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FlutterFire Samples',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        brightness: Brightness.light,
      ),
      
      home:   LaunchingpageScreen(),
      );
  }
}
