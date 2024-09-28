import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:mobi_div/screens/googleMapScreen.dart';
import 'package:mobi_div/screens/loginscreen.dart';
import 'package:permission_handler/permission_handler.dart' as perm;

void main() => runApp(const App());

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle.dark.copyWith(statusBarColor: Colors.transparent),
    );

    return MaterialApp(
      title: 'Introduction screen',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue, useMaterial3: true),
      home: const OnBoardingPage(),
    );
  }
}

class OnBoardingPage extends StatefulWidget {
  const OnBoardingPage({super.key});

  @override
  OnBoardingPageState createState() => OnBoardingPageState();
}

class OnBoardingPageState extends State<OnBoardingPage> {
  final introKey = GlobalKey<IntroductionScreenState>();
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  void _onIntroEnd(context) {
    _initializePermissionsAndStartSdk();

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => SignupPage()),
    );
  }
  Widget _buildFullscreenImage() {
    return Image.asset(
      'assets/travel_diary.jpg',
      fit: BoxFit.cover,
      height: double.infinity,
      width: double.infinity,
      alignment: Alignment.center,
    );
  }

  Widget _buildFullImage(String name) {
    return Image.asset(
      'assets/$name',
      fit: BoxFit.cover,
      height: double.infinity,
      width: double.infinity,
      alignment: Alignment.center,
    );
  }

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

  Widget _buildImage(String assetName, [double width = 350]) {
    return Image.asset('assets/$assetName', width: width);
  }

  Widget _circularImageView(String url, String name, int position){
    return Container(
      width: 280,
      height: 200,
      decoration: BoxDecoration(
          shape: BoxShape.circle,
      ),
      child: Stack(
          children:[
            Align(
            alignment: Alignment.topLeft,
            child: Text("$name", style: TextStyle(fontSize: 18),)),
             Image.asset(url, height: 150, width: 278, fit: BoxFit.fill,),
             Align(
              alignment: Alignment.bottomRight,
               child: Container(
                 width: 50,
                 height: 50,
                 decoration: BoxDecoration(
                   color: Colors.blue,
                   shape: BoxShape.circle
                 ),
                 child: Center(child: Text("$position", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.white),)),
               ),
             )
          ]
        ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const bodyStyle = TextStyle(fontSize: 19.0);

    const pageDecoration = PageDecoration(
      titleTextStyle: TextStyle(fontSize: 28.0, fontWeight: FontWeight.w700),
      bodyTextStyle: bodyStyle,
      bodyPadding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
      pageColor: Colors.white,
      imagePadding: EdgeInsets.zero,
    );

    return IntroductionScreen(
      key: introKey,
      globalBackgroundColor: Colors.white,
      allowImplicitScrolling: true,
      autoScrollDuration: 3000,
      infiniteAutoScroll: false,
      globalFooter: SizedBox(
        width: double.infinity,
        height: 60,
        child: ElevatedButton(
          child: const Text(
            'Let\'s go right away!',
            style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
          ),
          onPressed: () => _onIntroEnd(context),
        ),
      ),
      pages: [
        PageViewModel(
          title: "Getting started",
          body:
          "This app investigates the travel behavior of users upon user approval, presents active and passive surveys about user demographics and travel patterns while recording travel diary in time for review.",
          image: _buildFullscreenImage(),
          decoration: pageDecoration.copyWith(
            contentMargin: const EdgeInsets.symmetric(horizontal: 16),
            fullScreen: true,
            bodyFlex: 2,
            imageFlex: 3,
            safeArea: 100,
          ),
        ),
        PageViewModel(
          title: "Your Travel Diary",
          body: "User travels are recorded actively and passively to build a diary of their trips and associated purposes, for review after granting permissions."
              "Users can edit the travel details to adjust the travel mode and or purpose, i.e change from detected mode and or purpose to the actual mode and or purpose.",
          image: _buildFullscreenImage(),
          decoration:pageDecoration.copyWith(
            contentMargin: const EdgeInsets.symmetric(horizontal: 16),
            fullScreen: true,
            bodyFlex: 3,
            imageFlex: 3,
            safeArea: 100,
          ),
        ),
        PageViewModel(
          title: "Handling Permissions",
          bodyWidget: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("To fulfill the usefulness of this app the user will be required to allow these permissions"),
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: _circularImageView(
                    'assets/behaviors_permissions.png',
                    "Activity Recognition",
                  1
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: _circularImageView(
                    "assets/behaviors_permissions.png",
                    "Location",
                    2
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: _circularImageView(
                    "assets/behaviors_permissions.png",
                    "Motion Sensors",
                    3
                ),
              ),
            ],
          ),
          decoration: pageDecoration.copyWith(
            bodyFlex: 2,
            imageFlex: 4,
            bodyAlignment: Alignment.bottomCenter,
            imageAlignment: Alignment.topCenter,
          ),
          reverse: true,
        ),
        PageViewModel(
          title: "Account Setup",
          body: "To use the application, you will be required to sign up.",
          image: _buildFullImage('login_page.png'),
          decoration:pageDecoration.copyWith(
            contentMargin: const EdgeInsets.symmetric(horizontal: 16),
            fullScreen: true,
            bodyFlex: 3,
            imageFlex: 3,
            safeArea: 100,
          ),
        ),
        PageViewModel(
          title: "Travel Survey",
          body: "Take socio-demographic and travel based surveys",
          image: _buildFullImage('survey_big.jpg'),
          decoration:pageDecoration.copyWith(
            contentMargin: const EdgeInsets.symmetric(horizontal: 16),
            fullScreen: true,
            bodyFlex: 3,
            imageFlex: 3,
            safeArea: 100,
          ),
        ),
      ],
      onDone: () => _onIntroEnd(context),
      onSkip: () => _onIntroEnd(context), // You can override onSkip callback
      showSkipButton: false,
      skipOrBackFlex: 0,
      nextFlex: 0,
      showBackButton: true,
      //rtl: true, // Display as right-to-left
      back: const Icon(Icons.arrow_back),
      skip: const Text('Skip', style: TextStyle(fontWeight: FontWeight.w600)),
      next: const Icon(Icons.arrow_forward),
      done: const Text('Done', style: TextStyle(fontWeight: FontWeight.w600)),
      curve: Curves.fastLinearToSlowEaseIn,
      controlsMargin: const EdgeInsets.all(16),
      controlsPadding: kIsWeb
          ? const EdgeInsets.all(12.0)
          : const EdgeInsets.fromLTRB(8.0, 4.0, 8.0, 4.0),
      dotsDecorator: const DotsDecorator(
        size: Size(10.0, 10.0),
        color: Colors.blueAccent,
        activeSize: Size(22.0, 10.0),
        activeShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(25.0)),
        ),
      ),
      dotsContainerDecorator: const ShapeDecoration(
        color: Colors.black54,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(8.0)),
        ),
      ),
    );
  }
}
