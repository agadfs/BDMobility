// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyCuP1Q-PxWy-1EnN0DDyw-uWqTJI6ZnhPo',
    appId: '1:498646571873:web:d30dfccf8704d6bab4c320',
    messagingSenderId: '498646571873',
    projectId: 'bdmobility-7c131',
    authDomain: 'bdmobility-7c131.firebaseapp.com',
    storageBucket: 'bdmobility-7c131.appspot.com',
    measurementId: 'G-M7EBG0NXWV',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyC43khbtrbnBxJ68zxprUkiMp5g3MCy5oY',
    appId: '1:498646571873:android:20a8a66f0158613eb4c320',
    messagingSenderId: '498646571873',
    projectId: 'bdmobility-7c131',
    storageBucket: 'bdmobility-7c131.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBJm4BZB9vOGxPIMZwF_r_HBRxVmFmXmuU',
    appId: '1:498646571873:ios:333f4ae9bf2edaf5b4c320',
    messagingSenderId: '498646571873',
    projectId: 'bdmobility-7c131',
    storageBucket: 'bdmobility-7c131.appspot.com',
    iosBundleId: 'com.example.ios',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBJm4BZB9vOGxPIMZwF_r_HBRxVmFmXmuU',
    appId: '1:498646571873:ios:a4e440d3bb07b0ccb4c320',
    messagingSenderId: '498646571873',
    projectId: 'bdmobility-7c131',
    storageBucket: 'bdmobility-7c131.appspot.com',
    iosBundleId: 'com.example.ios.RunnerTests',
  );
}
