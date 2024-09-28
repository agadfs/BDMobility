import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobi_div/screens/googleMapScreen.dart';
import 'package:mobi_div/screens/modified/authManagement.dart';
import 'package:mobi_div/screens/modified/landingpage.dart';
import 'package:mobi_div/screens/modified/tutorial.dart';
import 'package:mobi_div/screens/onboarding.dart';
import 'package:provider/provider.dart';
import 'package:mobi_div/screens/splash.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:firebase_core/firebase_core.dart';

import 'screens/map_test.dart';


void main() async{
  // Initialize time zone database
  tz.initializeTimeZones();

  // Set local time zone
  final String timeZoneName = 'America/Toronto'; // Replace with your local time zone
  tz.setLocalLocation(tz.getLocation(timeZoneName));

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    App()
  );
}

class App extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AppInit(),
    );
  }
}


class AppInit extends StatefulWidget {
  @override
  _AppInitState createState() => _AppInitState();
}

class _AppInitState extends State<AppInit> {
  bool? _firstTimeUser;
  User? _currentUser;


  @override
  void initState() {
    super.initState();
    _checkFirstTimeUser();
  }

  Future<void> _checkFirstTimeUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? firstTime = prefs.getBool('first_time_user') ?? true;
    User? currentUser = FirebaseAuth.instance.currentUser;

    setState(() {
      _firstTimeUser = firstTime;
      _currentUser = currentUser;
    });

    Timer(const Duration(seconds: 5), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => firstTime ?
        OnboardingScreen() : _currentUser != null ? LandingPage() : SignUpPage()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Set your desired background color
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 20),
            Text(
              'BDMobility',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}