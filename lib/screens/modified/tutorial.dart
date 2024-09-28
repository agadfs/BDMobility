import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart' as perm;
import 'package:shared_preferences/shared_preferences.dart';

import 'authManagement.dart';


class OnboardingScreen extends StatelessWidget {
  final PageController _controller = PageController();
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();


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
      {required String name, required perm.Permission permission}) =>
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
        permission: perm.Permission.activityRecognition,
      );

  Future<void> _onRequestLocationAlwaysPermission() => _requestPermission(
    name: 'location (always)',
    permission: perm.Permission.locationAlways,
  );

  Future<void> _onRequestLocationInUsePermission() => _requestPermission(
    name: 'location (in use)',
    permission: perm.Permission.locationWhenInUse,
  );

  Future<void> _onRequestMotionSensorPermission() => _requestPermission(
    name: 'motion',
    permission: perm.Permission.sensors,
  );

  Future<void> _initializePermissionsAndStartSdk() async {
    await _onRequestLocationAlwaysPermission();
    await _onRequestLocationInUsePermission();
    await _onRequestActivityRecognitionPermission();
    await _onRequestMotionSensorPermission();

    if (defaultTargetPlatform == TargetPlatform.iOS) {
      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(
        alert: true,
        badge: true,
        sound: true,
      );
    }

  }

  Future<void> _completeOnboarding(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('first_time_user', false);
    await _initializePermissionsAndStartSdk();

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => SignUpPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _controller,
        children: [
          _buildPage(
            context,
            title: "BDMobility Welcomes You!",
            description: "This is the first onboarding screen.",
            image: Icons.accessibility_new,
          ),
          _buildPage(
            context,
            title: "How to use the App",
            description: "This is the second onboarding screen.",
            image: Icons.timeline,
          ),
          _buildPage(
            context,
            title: "Get Started",
            description: "Let's get started!",
            image: Icons.get_app,
            isLastPage: true,
            onTap: () => _completeOnboarding(context),
          ),
        ],
      ),
    );
  }

  Widget _buildPage(BuildContext context,
      {required String title,
        required String description,
        required IconData image,
        bool isLastPage = false,
        VoidCallback? onTap}) {
    return Container(
      padding: EdgeInsets.all(32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(image, size: 120),
          SizedBox(height: 40),
          Text(title),
          SizedBox(height: 20),
          Text(description, textAlign: TextAlign.center),
          SizedBox(height: 40),
          if (isLastPage)
            ElevatedButton(
              onPressed: onTap,
              child: Text('Get Started'),
            ),
        ],
      ),
    );
  }
}
