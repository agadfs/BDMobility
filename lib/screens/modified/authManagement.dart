import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mobi_div/models/jwt_generator.dart';
import 'package:mobi_div/screens/modified/landingpage.dart';
import 'package:mobi_div/screens/modified/tutorial.dart';
import 'package:motiontag_sdk/motiontag.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:showcaseview/showcaseview.dart';
import '../../models/usermodel.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';

Future<void> _executeInteraction(
    {required String logMessage, required AsyncCallback function}) async {
  print('$logMessage...');
  try {
    await function();
    print('$logMessage DONE.');
  } catch (error, stackTrace) {
    print('$logMessage ERROR. See the console logs for details');
  }
}


Future<void> _requestPermission(
    {required String name, required Permission permission}) =>
    _executeInteraction(
      logMessage: 'Requesting $name permission',
      function: () async {
        final permissionStatus = await permission.request();
        print('Permission status: ${permissionStatus.toString()}');
      },
    );

Future<void> _onRequestActivityRecognitionPermission() =>
    _requestPermission(
      name: 'activity recognition',
      permission: Permission.activityRecognition,
    );

Future<void> _onRequestLocationAlwaysPermission() => _requestPermission(
  name: 'location (always)',
  permission: Permission.locationAlways,
);
Future<void> _onRequestLocationInUsePermission() => _requestPermission(
  name: 'location (In Use)',
  permission: Permission.locationWhenInUse,
);

Future<void> _onRequestMotionSensorPermission() => _requestPermission(
  name: 'motion',
  permission: Permission.sensors,
);

Future<void> _initializePermissionsAndStartSdk() async {
  await _onRequestLocationInUsePermission();
  await _onRequestLocationAlwaysPermission();
  await _onRequestActivityRecognitionPermission();
  await _onRequestMotionSensorPermission();
}

class Sign_inPage extends StatefulWidget {
  @override
  _Sign_inPageState createState() => _Sign_inPageState();
}

class _Sign_inPageState extends State<Sign_inPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  bool obscureText = false, forgot_pass = false;
  final _formKey = GlobalKey<FormState>();

  Future<void> _login() async {
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();

    if (email.isNotEmpty && password.isNotEmpty) {
      try {
        var userSnapshot = await _firestore.collection('users').where('email', isEqualTo: email).get();

        if (userSnapshot.docs.isNotEmpty) {
          String uuid = userSnapshot.docs.first['uuid'];
          final SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setString("uuid", uuid);

          await _auth.signInWithEmailAndPassword(
            email: email,
            password: password,
          ).then((result){
            if(result.user != null){
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Logged in successfully')),
              );

              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => ShowCaseWidget(
                    blurValue: 1,
                    autoPlayDelay: const Duration(seconds: 3),
                    builder: (context) => LandingPage()
                )),
              );
            }
          });

        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('User does not exist. Redirecting to sign up page.')),
          );
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => SignUpPage()),
          );
        }
      } on FirebaseAuthException catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${e.message}')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill all fields')),
      );
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _resetPassword() async {
    if (_formKey.currentState!.validate()) {
    try {
    await FirebaseAuth.instance.sendPasswordResetEmail(email: _emailController.text.trim());
    // Display a success message
    ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text('Password reset email sent!')),
    );
    // Optionally navigate back to the login screen
    Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
    // Handle errors
    print(e.message);
    ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text('Error: ${e.message}')),
    );
    }
  }
  }


  Widget ForgotPass() {
  return Align(
    alignment: Alignment.center,
    child: Container(
    child: Padding(
    padding: const EdgeInsets.all(16.0),
    child: Form(
    key: _formKey,
    child: Column(
    children: [
    TextFormField(
    controller: _emailController,
    decoration: InputDecoration(
    labelText: 'Email',
      filled: true,
      fillColor: Colors.white70,
      border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(12))
      ),
      prefixIcon: Icon(Icons.email_outlined, size: 20,),
      prefixIconColor: Color(0xFF1890FF),
    ),
    validator: (value) {
    if (value == null || value.isEmpty) {
    return 'Please enter your email';
    }
    if (!value.contains('@')) {
    return 'Please enter a valid email';
    }
    return null;
    },
    ),
    SizedBox(height: 20),
      GestureDetector(
        onTap: _resetPassword,
        child: Container(
            padding: EdgeInsets.symmetric(vertical: 12, horizontal: 25),
            decoration: BoxDecoration(
              color: Color(0xff1890FF),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  spreadRadius: 5,
                  blurRadius: 10,
                  offset: Offset(5, 5),
                ),
              ],
              borderRadius: BorderRadius.circular(15), // Optional: Round edges
            ),
            child: Text('Reset Password', style: TextStyle(fontFamily: 'NotoSans', fontSize: 14, color: Colors.white),)),
      ),
    ],
    ),
    ),
    ),
    ),
  );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.all(32),
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment(0.00, -1.00),
            end: Alignment(0, 1),
            colors: [Color(0xFFF5F5F5), Color(0xFFA5D0F3)],
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Image.asset(
                'assets/logo_blue.png',
                width: 260,
                height: 260,
              ),
              SizedBox(height: 10),
              !forgot_pass ? Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        controller: _emailController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your email';
                          }
                          if (!value.contains('@')) {
                            return 'Please enter a valid email';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white70,
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(12))
                            ),
                            prefixIcon: Icon(Icons.email_outlined, size: 20,),
                            prefixIconColor: Color(0xFF1890FF),
                            labelText: 'Email'
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        controller: _passwordController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your password';
                          }
                          if (value.length < 6) {
                            return 'Password must be at least 6 characters';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white70,
                          prefixIcon: Icon(Icons.lock_outline, size: 20,),
                          prefixIconColor: Color(0xFF1890FF),
                          labelText: 'Password',
                          suffixIcon: IconButton(
                              icon: Icon(
                                obscureText ? Icons.visibility_off : Icons.visibility,
                              ),
                              onPressed: () {
                                setState(() {obscureText = !obscureText;});
                              }
                          ),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(12))
                          ),
                        ),
                        obscureText: obscureText,
                      ),
                    ),
                    SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              GestureDetector(
                                onTap: (){
                                  Navigator.push(context, new MaterialPageRoute(builder: (context) =>
                                  SignUpPage()
                                  ));
                                },
                                  child: Text("Don\'t have an account?", style: TextStyle(
                                      color: Color(0xFF1890FF),
                                      fontFamily: 'NotoSans',
                                      fontSize: 14
                                  ),))
                            ],
                          ),
                          GestureDetector(
                            onTap: (){
                              setState(() {
                                forgot_pass = true;
                              });
                            },
                              child: Text("Forgot your password?",
                                style: TextStyle(
                                color: Color(0xFF1890FF),
                                  fontFamily: 'NotoSans',
                                  fontSize: 14
                              ),
                              ))
                        ],
                      ),
                    ),
                    SizedBox(height: 20),
                    Align(
                      alignment: Alignment.center,
                      child: GestureDetector(
                        onTap: (){
                          if (_formKey.currentState!.validate()) {
                            _login();
                          }
                        },
                        child: Container(
                            padding: EdgeInsets.symmetric(vertical: 12, horizontal: 25),
                            decoration: BoxDecoration(
                              color: Color(0xff1890FF),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  spreadRadius: 5,
                                  blurRadius: 10,
                                  offset: Offset(5, 5),
                                ),
                              ],
                              borderRadius: BorderRadius.circular(15), // Optional: Round edges
                            ),
                            child: Text('Login', style: TextStyle(fontFamily: 'NotoSans', fontSize: 14, color: Colors.white),)),
                      ),
                    ),
                    SizedBox(height: 40),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: GestureDetector(
                          onTap: (){
                            Navigator.push(context, new MaterialPageRoute(builder: (context) =>
                                OnboardingScreen()
                            ));
                          },
                          child: Text("What is BDMobility?", style: TextStyle(
                              color: Color(0xFF1890FF),
                              fontFamily: 'NotoSans',
                              fontSize: 14
                          ),)),
                    )
                  ],
                ),
              ):
              Container(
                padding: EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: Colors.white38,
                  borderRadius: BorderRadius.all(Radius.circular(10))
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Align(
                      alignment: Alignment.topRight,
                      child: Padding(padding: EdgeInsets.all(5),
                        child: GestureDetector(
                          onTap: (){
                            setState(() {
                              forgot_pass = false;
                            });
                          },
                          child: Icon(Icons.cancel_outlined, size: 32, color: Colors.blueAccent,),
                        ),),
                    ),
                    SizedBox(height: 10),
                    Text("Reset your password", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, fontFamily: "NotoSans"),),
                    ForgotPass(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}



class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final _motionTag = MotionTag.instance;
  bool obscureText = false;
  final _formKey = GlobalKey<FormState>();

  Future<void> _signUp() async {
    String email = _emailController.text.trim();
    String username = _usernameController.text.trim();
    String password = _passwordController.text.trim();

    if (username.isNotEmpty && password.isNotEmpty) {
        // Generate UUID
        String uuid = UserModel.generateUUID();

        // Encrypt password
        String encryptedPassword = UserModel.encryptPassword(password);

        try {
        // Create a new user in Firebase Auth
        await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password, // Firebase requires plain password for sign up
        );

        // Create user model
        UserModel user = UserModel(
          uuid: uuid,
          email: email,
          username: username,
          password: encryptedPassword,
        );

        final SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString("uuid", uuid);

        _motionTag.setUserToken(jwtGen(uuid));
        _motionTag.start();

        if(await _motionTag.isTrackingActive()){
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Logged in successfully')),
          );
        }

        // Save user to Firestore
        await _firestore.collection('users').doc(uuid).set(user.toMap());


        // Display success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('User registered successfully')),
        );

        // Navigate back to landing page
        Navigator.pushReplacement(context, new MaterialPageRoute(builder: (context) => ShowCaseWidget(
            blurValue: 1,
            autoPlayDelay: const Duration(seconds: 3),
            builder: (context) => LandingPage()
        )));

      } on FirebaseAuthException catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${e.message}')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill all fields')),
      );
    }
  }

  Future<void> checkPermissions ()async{
    if(await Permission.locationAlways.isDenied || await Permission.activityRecognition.isDenied ||
        await Permission.sensors.isDenied ){
      _initializePermissionsAndStartSdk();
    }
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    checkPermissions();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.all(32),
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment(0.00, -1.00),
            end: Alignment(0, 1),
            colors: [Color(0xFFF5F5F5), Color(0xFFA5D0F3)],
          ),
        ),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey ,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/logo_blue.png',
                  width: 260,
                  height: 260,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: _usernameController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your username';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white70,
                      labelText: 'Username',
                      prefixIcon: Icon(Icons.person_2_outlined, size: 20,),
                      prefixIconColor: Color(0xFF1890FF),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(12))
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: _emailController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your email';
                      }
                      if (!value.contains('@')) {
                        return 'Please enter a valid email';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white70,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(12))
                      ),
                      prefixIcon: Icon(Icons.email_outlined, size: 20,),
                        prefixIconColor: Color(0xFF1890FF),
                        labelText: 'Email'
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: _passwordController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your password';
                      }
                      if (value.length < 6) {
                        return 'Password must be at least 6 characters';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white70,
                        prefixIcon: Icon(Icons.lock_outline, size: 20,),
                        prefixIconColor: Color(0xFF1890FF),
                        labelText: 'Password',
                        suffixIcon: IconButton(
                          icon: Icon(
                            obscureText ? Icons.visibility_off : Icons.visibility,
                          ),
                          onPressed: () {
                            setState(() {obscureText = !obscureText;});
                          }
                          ),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(12))
                        ),
                    ),
                    obscureText: obscureText,
                  ),
                ),
                Align(
                  alignment: Alignment.center,
                  child: GestureDetector(
                      onTap: (){
                        Navigator.push(context, new MaterialPageRoute(builder: (context) =>
                            Sign_inPage()
                        ));
                      },
                      child: Text("Already registered?", style: TextStyle(
                          color: Color(0xFF1890FF),
                          fontFamily: 'NotoSans',
                          fontSize: 14
                      ),)),
                ),
                SizedBox(height: 20),
                Align(
                  alignment: Alignment.center,
                  child: GestureDetector(
                    onTap: (){
                      if (_formKey.currentState!.validate()) {
                        _signUp();
                      }
                    },
                    child: Container(
                        padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                        decoration: BoxDecoration(
                          color: Color(0xff1890FF),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              spreadRadius: 5,
                              blurRadius: 10,
                              offset: Offset(5, 5),
                            ),
                          ],
                          borderRadius: BorderRadius.circular(15), // Optional: Round edges
                        ),
                        child: Text('Sign Up', style: TextStyle(fontFamily: 'NotoSans', fontSize: 14, color: Colors.white),)),
                  ),
                ),
                SizedBox(height: 40),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: GestureDetector(
                      onTap: (){
                        Navigator.push(context, new MaterialPageRoute(builder: (context) =>
                            OnboardingScreen()
                        ));
                      },
                      child: Text("What is BDMobility?", style: TextStyle(
                          color: Color(0xFF1890FF),
                          fontFamily: 'NotoSans',
                          fontSize: 14
                      ),)),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _registerWithEmailAndPassword() async {
    try {
      FirebaseAuth.instance.setLanguageCode("en");
      String username = _usernameController.text.trim();
      String email = _emailController.text.trim();
      String password = _passwordController.text.trim();

      String uuid = UserModel.generateUUID();

      // Encrypt password
      String encryptedPassword = UserModel.encryptPassword(password);

      if(username.isNotEmpty && email.isNotEmpty && password.isNotEmpty) {
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email,
          password: encryptedPassword,
        );

        // Create user model
        UserModel user = UserModel(
          uuid: uuid,
          email: email,
          username: username,
          password: encryptedPassword,
        );

        final SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString("uuid", uuid);

        _motionTag.setUserToken(jwtGen(uuid));
        _motionTag.start();

        // Save user to Firestore
        await _firestore.collection('users').doc(uuid).set(user.toMap());
        // Display success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('User registered successfully')),
        );

        print('User registered successfully!');
      }
    } on FirebaseAuthException catch (e) {
      // Handle registration errors
      print('Registration failed: ${e.code}');
      // Display an error message to the user
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Registration failed: ${e.code}'),
        ),
      );
    }
  }
}