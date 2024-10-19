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
      print('$logMessage ERROR. See the console logs for details, $stackTrace');
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
    await _onRequestLocationInUsePermission();
    if(await perm.Permission.locationWhenInUse.isGranted){
    await _onRequestLocationAlwaysPermission();
    }
    if(await perm.Permission.locationWhenInUse.isGranted || await perm.Permission.locationAlways.isGranted) {
      await _onRequestActivityRecognitionPermission();
    }
    if((await perm.Permission.locationWhenInUse.isGranted || await perm.Permission.locationAlways.isGranted)
      && await perm.Permission.activityRecognition.isGranted) {
      await _onRequestMotionSensorPermission();

    }

    if((await perm.Permission.locationWhenInUse.isGranted || await perm.Permission.locationAlways.isGranted)
        && await perm.Permission.activityRecognition.isGranted && await perm.Permission.sensors.isGranted) {
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
          _buildWelcomePage(context, title: "Welcome", description: 'to the step by step guide for BDMobility participation'),
          _buildPage1(context, onTap: () => _completeOnboarding(context),),
          _buildPage2(context, onTap: () => _completeOnboarding(context)),
          _buildOtherPages(context, description: "Allow our access requests and give consent", url: "assets/perms.png"),
          _buildOtherPages(context, description: "Answer questionnaires about your demographics, residence and travel preferences. Your anonymity is our promise", url: "assets/tut_survey.png"),
          _buildOtherPages(context, description: "Allow the application to always run in the background to log data", url: "assets/recording.png"),
          _buildOtherPages(context, description: "You can pause your travel diary recording from the app settings anytime", url: "assets/settings.png", isLastPage: true,
              onTap: () => _completeOnboarding(context)),
        ],
      ),
    );
  }

  Widget _buildPage1(BuildContext context,
      {VoidCallback? onTap}) {
    return Container(
      padding: EdgeInsets.all(32),
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment(0.00, -1.00),
          end: Alignment(0, 1),
          colors: [Color(0xFFF5F5F5), Color(0xFFA5D0F3)],
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
            Image.asset(
            'assets/logo_blue.png',
            width: 300,
            height: 300,
          ),
          SizedBox(height: 10),
          Text("Efficient travel survey app to best meet\nyour needs", textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold, fontFamily: 'NotoSans', fontSize: 16)),
          SizedBox(height: 40),
          GestureDetector(
            onTap: (){
              _controller.animateToPage(
                2,
                duration: Duration(milliseconds: 100),
                curve: Curves.easeInOut,
              );
            },
            child: Container(
              padding: EdgeInsets.all(12),
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
                child: Text('Let\'s get started', style: TextStyle(fontFamily: 'NotoSans', fontSize: 16, color: Colors.white),)),
          ),
          SizedBox(height: 40),
          GestureDetector(
            onTap: onTap,
            child: Container(
              color: Color(0x1890FF),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text("Skip, to sign in", style: TextStyle(color: Color(0xff0557F9), fontSize: 14),),
                  Icon(Icons.arrow_forward, color: Color(0xff0557F9), size: 18, weight: 1.0,),
                ],
              ),
            ),
          ),
          SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildPage2(BuildContext context,
      {VoidCallback? onTap}) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 20, horizontal: 32),
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment(0.00, -1.00),
          end: Alignment(0, 1),
          colors: [Color(0xFFF5F5F5), Color(0xFFA5D0F3)],
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/logo_blue.png',
            width: 300,
            height: 300,
          ),
          Text("Efficient travel survey app to best meet\nyour needs", textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold, fontFamily: 'NotoSans', fontSize: 14)),
          SizedBox(height: 20),
          Container(
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                        width: 20,
                        height: 20,
                        padding: EdgeInsets.all(5),
                        margin: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                            color: Color(0xFF0557F9),
                            shape: BoxShape.circle
                        ),
                        child: Center(child: Icon(Icons.check_sharp, size: 12, color: Colors.white,))),
                    Text("Gather insights on your travel habits")
                  ],
                ),
                Row(
                  children: [
                    Container(
                        width: 20,
                        height: 20,
                        padding: EdgeInsets.all(5),
                        margin: EdgeInsets.all(3),
                        decoration: BoxDecoration(
                            color: Color(0xFF0557F9),
                            shape: BoxShape.circle
                        ),
                        child: Center(child: Icon(Icons.check_sharp, size: 12, color: Colors.white,))),
                    Text("Quickly share your experiences")
                  ],
                ),
                Row(
                  children: [
                    Container(
                        width: 20,
                        height: 20,
                        padding: EdgeInsets.all(5),
                        margin: EdgeInsets.all(3),
                        decoration: BoxDecoration(
                            color: Color(0xFF0557F9),
                            shape: BoxShape.circle
                        ),
                        child: Center(child: Icon(Icons.check_sharp, size: 12, color: Colors.white,))),
                    Text("Receive real-time updates")
                  ],
                ),
                Row(
                  children: [
                    Container(
                        width: 20,
                        height: 20,
                        padding: EdgeInsets.all(5),
                        margin: EdgeInsets.all(3),
                        decoration: BoxDecoration(
                            color: Color(0xFF0557F9),
                            shape: BoxShape.circle
                        ),
                        child: Center(child: Icon(Icons.check_sharp, size: 12, color: Colors.white,))),
                    Text("Review your trips and make necessary edits")
                  ],
                ),
                SizedBox(height: 25),
                GestureDetector(
                  onTap: (){
                    _controller.animateToPage(
                      3,
                      duration: Duration(milliseconds: 100),
                      curve: Curves.easeInOut,
                    );
                  },
                  child: Container(
                      padding: EdgeInsets.all(12),
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
                      child: Text('Participate', style: TextStyle(fontFamily: 'NotoSans', fontSize: 16, color: Colors.white),)),
                ),
              ],
            ),
          ),
          SizedBox(height: 30),
          GestureDetector(
            onTap: onTap,
            child: Container(
              color: Color(0x1890FF),
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text("Take me to sign in", style: TextStyle(color: Color(0xff0557F9), fontSize: 14),),
                    Icon(Icons.arrow_forward, color: Color(0xff0557F9), size: 18, weight: 1.0,),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildOtherPages(BuildContext context,
      {
        required String? description,
        required String  url,
        bool isLastPage = false,
        VoidCallback? onTap}) {
    return Container(
      padding: EdgeInsets.all(32),
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: Color(0xFF0557F9)
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            "assets/logo_white.png",
            width: 200,
            height: 200,
          ),
          Image.asset(
            url,
            width: 300,
            height: 220,
          ),
          SizedBox(height: 20),
          Text(description!, textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600),),
          SizedBox(height: 20),
          Align(
            alignment: Alignment.bottomRight,
            child: Container(
              color: Color(0x1890FF),
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: GestureDetector(
                  onTap: (){
                    if(!isLastPage) {
                      _controller.animateToPage(
                        _controller.page!.toInt() + 1,
                        duration: Duration(milliseconds: 100),
                        curve: Curves.easeInOut,
                      );
                    }else{
                      _completeOnboarding(context);
                    }
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text("Let\'s get started", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white),),
                      Icon(Icons.arrow_forward, size: 22, color: Colors.white,)
                    ],
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }


  Widget _buildWelcomePage(BuildContext context,
      {required String title,
        required String description}) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment(0.00, -1.00),
          end: Alignment(0, 1),
          colors: [Color(0xFFF5F5F5), Color(0xFFA5D0F3)],
        ),
      ),
      child: Column(
        children: [
          Image.asset(
            'assets/logo_blue.png',
            width: 300,
            height: 300,
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Container(
              padding: EdgeInsets.all(20),
              width: MediaQuery.of(context).size.width * 0.71,
              height: MediaQuery.of(context).size.height/1.79,
              decoration: BoxDecoration(
                image: DecorationImage(image: AssetImage('assets/img.png'), fit: BoxFit.fill),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: 40),
                  Text(title, style: TextStyle(fontSize: 24, color: Colors.white, fontFamily: 'NotoSans', fontWeight: FontWeight.bold),),
                  SizedBox(height: 20),
                  Text(description, textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontFamily: 'NotoSans', fontSize: 16),),
                  SizedBox(height: 20),
                  Align(
                    alignment: Alignment.centerRight,
                    child: GestureDetector(
                      onTap: (){
                        _controller.animateToPage(
                          1,
                          duration: Duration(milliseconds: 100),
                          curve: Curves.easeInOut,
                        );
                      },
                      child: Container(
                        color: Color(0x1890FF),
                        child: Padding(
                          padding: const EdgeInsets.all(1.0),
                          child: Icon(Icons.arrow_forward, size: 45, color: Colors.white,),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
