import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:getwidget/components/toast/gf_toast.dart';
import 'package:mobi_div/main.dart';
import 'package:mobi_div/models/jwt_generator.dart';
import 'package:mobi_div/models/usermodel.dart';
import 'package:mobi_div/screens/modified/authManagement.dart';
import 'package:mobi_div/screens/modified/faq.dart';
import 'package:mobi_div/screens/modified/surveycategory.dart';
import 'package:mobi_div/screens/modified/travelevents.dart';
import 'package:mobi_div/screens/modified/settings.dart';
import 'package:mobi_div/screens/modified/userprofile.dart';
import 'package:motiontag_sdk/events/motiontag_event.dart';
import 'package:motiontag_sdk/motiontag.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:timezone/timezone.dart' as tz;

import '../../models/api_handle.dart';
import '../../models/finalTracker.dart';
import 'trip_events.dart';
import 'about_us.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final APIHandler apiHandler = new APIHandler();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  var tripDays;
  String email ="", username = "";
  int tripCount = 0;
  String uuid = "";
  MotionTag _motionTag = MotionTag.instance;
  late tz.TZDateTime? now = tz.TZDateTime.now(tz.local);
  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  final GlobalKey _signOutKey = GlobalKey();
  final GlobalKey _surveyKey = GlobalKey();
  final GlobalKey _accountKey = GlobalKey();
  final GlobalKey _settingsKey = GlobalKey();
  final GlobalKey _faqKey = GlobalKey();
  final GlobalKey _aboutKey = GlobalKey();
  final GlobalKey _tripsKey = GlobalKey();

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

  Future<void> _onStart() async => _executeInteraction(
    logMessage: 'Starting the SDK',
    function: () => _motionTag.start(),
  );

  void _onSetUserToken(String userToken) => _executeInteraction(
    logMessage: 'Updating the user token to $userToken',
    function: () => _motionTag.setUserToken(userToken),
  );


  Future<void> _signOut(BuildContext context) async {
    await _auth.signOut();
    Navigator.pushReplacement(context, new MaterialPageRoute(builder: (context)=> Sign_inPage())); // Update with appropriate route name
  }

  Future<void> initiateAPIS() async{
    try{
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      setState(() {
        uuid = prefs.getString("uuid").toString();
      });
      if(uuid.isNotEmpty){
        String userToken = jwtGen(uuid);
        print("current user token: $userToken");

        if(await Permission.locationWhenInUse.isDenied){
          await Permission.locationWhenInUse.request();
        }
        if(await Permission.locationAlways.isDenied){
          await Permission.locationAlways.request();
        }
        if(await Permission.sensors.isDenied){
          await Permission.sensors.request();
        }
        if(await Permission.activityRecognition.isDenied){
          await Permission.activityRecognition.request();
        }
        if(await Permission.locationWhenInUse.isGranted || await Permission.locationAlways.isGranted && await Permission.sensors.isGranted && await Permission.activityRecognition.isGranted) {
         setState(() {
           _onSetUserToken(userToken);
           _onStart();
         });
        }
        await _motionTag.isTrackingActive().then((event){
          if(event != false){
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Location logging is active')),
            );
            print("Event: $event");
          }else{
            setState(() {
              _motionTag.start();
            });
          }
        });
        _motionTag.setObserver((event){
          print(event);
          if(event == MotionTagEventType.location){
            print(event.toString());
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Logged location initiated')),
            );
          }else if(event == MotionTagEventType.transmissionSuccess){
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Logged location transmitted')),
            );
          }else if(event == MotionTagEventType.transmissionError){
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Error transmitting data')),
            );
          }
        });

        await apiHandler.fetchCalendar("899d6413-bbca-43c9-8aa9-9cc2596e1546").then((day){
          tripCount = day.length;
          tripDays = day;
        });

        getUserInfo();

        if(tripDays.isNotEmpty){
          WidgetsBinding.instance.addPostFrameCallback((_) async => await _scheduleYearlyMondayTenAMNotification());
        }
        setState(() {});
      }

      print('uuid is: $uuid');
      bool isFirstTime = prefs.getBool('isFirstTime') ?? true;
      if(isFirstTime){
        WidgetsBinding.instance.addPostFrameCallback(
              (_) => ShowCaseWidget.of(context)
              .startShowCase([_signOutKey, _tripsKey, _surveyKey, _accountKey, _settingsKey, _aboutKey, _faqKey]),
        );
        prefs.setBool('isFirstTime', false);
      }
    }catch(e){
      print("error $e");
    }
  }

  void _initializeNotifications() async {
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
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
    // Initialization settings for Android
    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('@mipmap/ic_launcher');

    final DarwinInitializationSettings initializationSettingsDarwin =
    DarwinInitializationSettings(
      requestSoundPermission: false,
      requestBadgePermission: false,
      requestAlertPermission: false,
      onDidReceiveLocalNotification: onDidReceiveLocalNotification,
    );

    // Initialization settings for all platforms
    final InitializationSettings initializationSettings =
    InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsDarwin,
    );

    // Initialize the plugin
    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  Future<void> getUserInfo() async{
    if(await _auth.currentUser !=  null){
      email = await _auth.currentUser!.email.toString();
      var userDB = await FirebaseFirestore.instance.collection('users').doc(uuid).get();

      if(userDB.exists){
        UserModel user = UserModel.fromMap(userDB.data() as Map<String, dynamic>);
        username = user.username;
      }
      setState(() {});
    }
  }

  tz.TZDateTime _nextInstanceOfSevenPM() {
    tz.TZDateTime scheduledDate = tz.TZDateTime(tz.local, DateTime.now().year, DateTime.now().month, DateTime.now().day, 19, 0, 0);
    if (scheduledDate.isBefore(DateTime.now())) {
      scheduledDate = scheduledDate.add(Duration(days: 1));
    }
    return scheduledDate;
  }

  Future<void> _scheduleYearlyMondayTenAMNotification() async {
    await flutterLocalNotificationsPlugin.zonedSchedule(
        0,
        'Review your  trips for today',
        'Your latest trip is ready for review',
        _nextInstanceOfSevenPM(),
        const NotificationDetails(
          android: AndroidNotificationDetails(
              actions: <AndroidNotificationAction>[
                AndroidNotificationAction('mark_as_read', 'Mark as read'),
                AndroidNotificationAction('mark_for_later', 'Mark for review'),
              ],
              'Daily notification channel id',
              'Daily notification channel name',
              channelDescription: 'Review today\'s trip now'),
          iOS: darwinNotificationDetails,
        ),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
        UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.dateAndTime);
  }

  void onDidReceiveLocalNotification(
      int id, String? title, String? body, String? payload) async {
    // display a dialog with the notification details, tap ok to go to another page
    showDialog(
      context: context,
      builder: (BuildContext context) => CupertinoAlertDialog(
        title: Text(title??''),
        content: Text(body??''),
        actions: [
          CupertinoDialogAction(
            isDefaultAction: true,
            child: Text('Ok'),
            onPressed: () async {
              Navigator.of(context, rootNavigator: true).pop();
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AppInit(),
                ),
              );
            },
          )
        ],
      ),
    );
  }


  @override
  void initState() {
    _initializeNotifications();
    initiateAPIS();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Screen'),
        actions: [
          Showcase(
            key: _signOutKey,
            description: "Click here to logout",
            child: IconButton(
              icon: Icon(Icons.logout),
              onPressed: () => _signOut(context),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: GridView.count(
              primary: false,
              padding: const EdgeInsets.all(10),
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              crossAxisCount: 2,
              children: <Widget>[
                Showcase(
                  key: _tripsKey,
                  description: "View your logged trips",
                  child: GestureDetector(
                    onTap: (){
                      if(tripDays != null) {
                        Navigator.push(context, new MaterialPageRoute(
                            builder: (context) => TravelEvents(
                              uuid: "899d6413-bbca-43c9-8aa9-9cc2596e1546",
                              tripDaysList: tripDays,)));
                      }else{
                        print("No trips are available");
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      color: Colors.amber[100],
                      child: Center(child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("$tripCount", style: TextStyle(fontSize: 95, fontFamily: 'NotoSans', fontWeight: FontWeight.bold),),
                          Text("Days", style: TextStyle(fontSize: 16),),
                        ],
                      )),
                    ),
                  ),
                ),
                Showcase(
                  key: _surveyKey,
                  description: "View and partake in our surveys",
                  child: GestureDetector(
                    onTap: (){
                      Navigator.push(context, new MaterialPageRoute(builder: (context) => SurveyCategory()));
                    },
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      color: Colors.amber[200],
                      child:  Center(child:
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.quiz_outlined, size: 120,),
                            Text('Survey'),
                          ],
                        )
                      ),
                    ),
                  ),
                ),
                Showcase(
                  key: _accountKey,
                  description: "Manage your account from here",
                  child: GestureDetector(
                    onTap: (){
                      Navigator.push(context, new MaterialPageRoute(builder: (context)=> UserProfilePage(email: email, username: username,)));
                    },
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      color: Colors.amber[300],
                      child:Center(child:
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.person, size: 120,),
                          Text('My Account'),
                        ],
                      )
                      ),
                    ),
                  ),
                ),
                Showcase(
                  key: _settingsKey,
                  description: "Manage app preferences from here.",
                  child: GestureDetector(
                    onTap: (){
                      Navigator.push(context, new MaterialPageRoute(builder: (context) =>
                        SettingsPage(notificationCount: 0, isTrackingActive: true, isWifiOnlyDataTransferEnabled: true,isBatteryOptimisationEnabled: true, isPowerSaveModeEnabled: true,)
                      ));
                    },
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      color: Colors.amber[400],
                      child: Center(child:
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.settings_outlined, size: 120,),
                          Text('Settings'),
                        ],
                      )
                      ),
                    ),
                  ),
                ),
                Showcase(
                  key: _aboutKey,
                  description: "Get to know more about us.",
                  child: GestureDetector(
                    onTap: (){
                      Navigator.push(context, new MaterialPageRoute(builder: (context)=>
                          AboutUs()
                      ));
                    },
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      color: Colors.amber[500],
                      child:Center(child:
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.group_outlined, size: 120,),
                          Text('About Us'),
                        ],
                      )
                      ),
                    ),
                  ),
                ),
                Showcase(
                  key: _faqKey,
                  description: "Are you in doubt? Visit our FAQs",
                  child: GestureDetector(
                    onTap: (){
                      Navigator.push(context, new MaterialPageRoute(builder: (context) =>
                        FaqPage()));
                    },
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      color: Colors.amber[600],
                      child: Center(child:
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.live_help_outlined, size: 120,),
                          Text('FAQ'),
                        ],
                      )
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      )
    );
  }
}
