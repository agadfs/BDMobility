import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mobi_div/models/jwt_generator.dart';
import 'package:mobi_div/screens/modified/landingpage.dart';
import 'package:motiontag_sdk/motiontag.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../models/usermodel.dart';

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

Future<void> _onRequestMotionSensorPermission() => _requestPermission(
  name: 'motion',
  permission: Permission.sensors,
);

Future<void> _initializePermissionsAndStartSdk() async {
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

  Future<void> _login() async {
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();

    if (email.isNotEmpty && password.isNotEmpty) {
      try {
        var userSnapshot = await _firestore.collection('users').where('email', isEqualTo: email).get();

        if (userSnapshot.docs.isNotEmpty) {
          await _auth.signInWithEmailAndPassword(
            email: email,
            password: password,
          );
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Logged in successfully')),
          );
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => LandingPage()),
          );
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                TextField(
                  controller: _emailController,
                  decoration: InputDecoration(labelText: 'Email'),
                  keyboardType: TextInputType.emailAddress,
                ),
                TextField(
                  controller: _passwordController,
                  decoration: InputDecoration(labelText: 'Password'),
                  obscureText: true,
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _login,
                  child: Text('Login'),
                ),
              ],
            ),
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

  Future<void> _signUp() async {
    String email = _emailController.text.trim();
    String username = _usernameController.text.trim();
    String password = _passwordController.text.trim();

    if (username.isNotEmpty && password.isNotEmpty) {
      try {
        // Generate UUID
        String uuid = UserModel.generateUUID();

        // Encrypt password
        String encryptedPassword = UserModel.encryptPassword(password);

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

        // Save user to Firestore
        await _firestore.collection('users').doc(uuid).set(user.toMap());

        String userToken = jwtGen(user.uuid);
        final _motionTag = MotionTag.instance;
        if (await Permission.locationAlways.isDenied || await Permission.activityRecognition.isDenied ||
            await Permission.sensors.isDenied) {
          _initializePermissionsAndStartSdk();
        }
        else {
          _motionTag.start();
        }
        // Display success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('User registered successfully')),
        );

        // Navigate back to login or home page
        Navigator.pop(context);

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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign Up'),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                TextFormField(
                  controller: _usernameController,
                  decoration: InputDecoration(labelText: 'Username'),
                ),
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(labelText: 'Email'),
                ),
                TextFormField(
                  controller: _passwordController,
                  decoration: InputDecoration(labelText: 'Password'),
                  obscureText: true,
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _signUp,
                  child: Text('Sign Up'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}