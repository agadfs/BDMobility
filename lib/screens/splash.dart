import 'dart:async';
import 'dart:convert';
import 'package:mobi_div/screens/onboarding.dart';
import 'dart:ui';
import 'package:apple_maps_flutter/apple_maps_flutter.dart' as apple;
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_flutter_platform_interface/google_maps_flutter_platform_interface.dart';
import 'package:mobi_div/models/finalTracker.dart';
import 'package:mobi_div/models/usermodel.dart';
import 'package:mobi_div/screens/loginscreen.dart';
import 'package:mobi_div/models/jwt_generator.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:mobi_div/screens/traveldiary.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/authservice.dart';
import 'googleMapScreen.dart';


class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final AuthService authService = AuthService();
  bool isLoggedIn = false;
  String user_id = "";
  String user_token = "";
  bool isFirstTime = false;

  Future<void> _checkFirstTimeUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    isFirstTime = await prefs.getBool('_newUserKey') ?? true;

    if (isFirstTime) {
      setState(() {
        prefs.setBool('_newUserKey', false);
      });
      Navigator.pushReplacement(context, new MaterialPageRoute(builder: (context) => OnBoardingPage()));
    }else{
      _checkLoginStatus();

      Timer(const Duration(seconds: 5), () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => isLoggedIn ?
          HomeScreen() : SignupPage()),
        );
      });
    }
    setState(() {});
  }

  Future<void> _checkLoginStatus() async {
    bool loggedIn = await authService.userService.isUserLoggedIn();
    if(loggedIn == true){
      await authService.userService.getUser().then(
        (value){
          setState(() {
            user_id = value!.id;
            user_token = value.token;
          });
        }
      );
    }
    setState(() {
      isLoggedIn = loggedIn;
    });
  }



  @override
  void initState() {
    super.initState();
     _checkFirstTimeUser();
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

const String darwinNotificationCategoryPlain = 'plainCategory';
/// A notification action which triggers a url launch event
const String urlLaunchActionId = 'id_1';

/// A notification action which triggers a App navigation event
const String navigationActionId = 'id_3';

/// Defines a iOS/MacOS notification category for text input actions.
const String darwinNotificationCategoryText = 'textCategory';

const DarwinNotificationDetails darwinNotificationDetails = DarwinNotificationDetails(
  presentSound: false,
);

class ReceivedNotification {
  ReceivedNotification({
    required this.id,
    required this.title,
    required this.body,
    required this.payload,
  });

  final int id;
  final String? title;
  final String? body;
  final String? payload;
}

class TripEvents extends StatefulWidget {
  bool allConfirmed;
  var data;
  final int index;
  final String uuid;
  bool status = false;
  bool showActions = false;
  bool reviewed = false;
  List currentIDs = [];
  final List<ConfirmTrips> currentTripIDs;

  TripEvents({required this.allConfirmed, required this.uuid,required this.data, required this.index, super.key, required this.currentTripIDs});

  @override
  State<TripEvents> createState() => _TripEventsState();
}

class _TripEventsState extends State<TripEvents> with SingleTickerProviderStateMixin {
  Color color = Colors.transparent;
  String selectedMode = "";
  String detectedMode = "";
  String detectedPurpose = "";
  String selectedPurpose = "";
  bool previousChecked = true;
  bool currentChecked = false, showPrompt = false;
  List editedTrips = [];
  late ConfirmTrips _confirmTrips;
  List savedTripID = [];


  int calculateDifferenceInMinutes(String startedAt, String finishedAt) {
    DateTime startedDateTime = DateTime.parse(startedAt);
    DateTime finishedDateTime = DateTime.parse(finishedAt);

    Duration difference = finishedDateTime.difference(startedDateTime);
    int differenceInMinutes = difference.inMinutes;

    return differenceInMinutes % 60;
  }

  List<Map<String, String>> modesAvailable = [
    {'name':"Airplane",'key':'airplane'}, {'name':"Bicycle",'key':'bicycle'}, {'name':"Bus",'key':'bus'}, {'name':"Cable Car",'key':'cablecar'},
    {'name':"Car",'key':'car'}, {'name':"Ferry",'key':'ferry'}, {'name':"Other",'key':'other'}, {'name':"Rapid transit railway", 'key':'light_rail'},
    {'name':"Regional train",'key':'regional_train'}, {'name':"Subway", 'key':'subway'}, {'name':"Train",'key':'train'},
    {'name':"Tramway", 'key':'tramway'}, {'name':"Walking", 'key':'walking'}
  ];
  List<Map<String, String>> purposesAvailable = [{'name':"Work",'key':'work'}, {'name':"School",'key':'school'}, {'name':"Sports",'key':'sports'},
    {'name':"Leisure",'key':'leisure'}, {'name':"Other", 'key':'other'}, {'name':"Shopping",'key':'shopping'}, {'name':"Waiting",'key':'waiting'},
    {'name':"Home",'key':'home'},{'name':"Unknown",'key':'unknown'}];
  List<PolylineWayPoint> currentTripWPGoogle = [];
  LatLng startLocGoogle = LatLng(0.0, 0.0);
  LatLng destLocGoogle = LatLng(0.0, 0.0);
  apple.LatLng startLocApple = apple.LatLng(0.0, 0.0);
  apple.LatLng destLocApple = apple.LatLng(0.0, 0.0);
  List<Map<String, dynamic>>  possibleModes = [];

  getTrackIcon(String modeName){
    if(modeName == 'Airplane'){
      color =  Color(0xFFe9b100);
      return Icon(Icons.airplanemode_on_outlined, color: color, size: 40);
    }
    else if(modeName == 'Unknown'){
      color =  Color(0xFF5175ae);
      return Icon(Icons.question_mark_outlined, color: color, size: 40);
    }
    else if(modeName == 'Bicycle'){
      color =  Color(0xFF90a72f);
      return Icon(Icons.directions_bike_outlined, color: color, size: 40);
    }
    else if(modeName == 'Bus'){
      color =  Color(0xFF5175ae);
      return Icon(Icons.directions_bus_outlined, color: color, size: 40);
    }
    else if(modeName == 'Cable car'){
      color =  Color(0xFF2ea8c5);
      return Icon(Icons.subway_outlined, color: color, size: 40);
    }
    else if(modeName == 'Car'){
      color =  Color(0xFFd57f0e);
      return Icon(Icons.directions_car_outlined, color: color, size: 40);
    }
    else if(modeName == 'Ferry'){
      color =  Color(0xFF6e6cad);
      return Icon(Icons.directions_boat_outlined, color: color, size: 40);
    }
    else if(modeName == 'Other'){
      color =  Color(0xFF35ad9c);
      return Icon(Icons.adjust_rounded, color:  color, size: 40);
    }
    else if(modeName == 'Rapid transit railway'){
      color =  Color(0xFF35ad9c);
      return Icon(Icons.directions_railway_outlined, color: color, size: 40);
    }
    else if(modeName == 'Regional train'){
      color =  Color(0xFFcb4288);
      return Icon(Icons.directions_railway_outlined, color: color, size: 40);
    }
    else if(modeName == 'Subway'){
      color =  Color(0xFF3e8eb6);
      return Icon(Icons.directions_subway_outlined, color: color, size: 40);
    }
    else if(modeName == 'Train'){
      color =  Color(0xFFd6393a);
      return Icon(Icons.directions_train, color: color, size: 40);
    }
    else if(modeName == 'Tramway'){
      color =  Color(0xFF2ea8c5);
      return Icon(Icons.directions_train, color: color, size: 40);
    }
    else if(modeName == 'Walking'){
      color =  Color(0xFFdebb00);
      return Icon(Icons.directions_walk, color: color, size: 40);
    }
  }
  getPurposeIcon(String purposeName){
    if(purposeName.toLowerCase().contains('unknown')){
      color =  Color(0xFFe9b100);
      return Icon(Icons.question_mark_outlined, color: color, size: 40);
    }
    else if(purposeName.toLowerCase().contains('home') ){
      color =  Color(0xFF90a72f);
      return Icon(Icons.home, color: color, size: 40);
    }
    else if(purposeName.toLowerCase().contains('work')){
      color =  Color(0xFF5175ae);
      return Icon(Icons.work_history_outlined, color: color, size: 40);
    }
    else if(purposeName.toLowerCase().contains('school')){
      color =  Color(0xFF90a72f);
      return Icon(Icons.school_outlined, color: color, size: 40);
    }
    else if(purposeName.toLowerCase().contains('sports')){
      color =  Color(0xFF2ea8c5);
      return Icon(Icons.sports_outlined, color: color, size: 40);
    }
    else if(purposeName.toLowerCase().contains('leisure')){
      color =  Color(0xFFd57f0e);
      return Icon(Icons.games_outlined, color: color, size: 40);
    }
    else if(purposeName.toLowerCase().contains('shop')){
      color =  Color(0xFFd6393a);
      return Icon(Icons.shopping_bag_outlined, color: color, size: 40);
    }
    else if(purposeName.toLowerCase().contains('medical')){
      color =  Color(0xFF2ea8c5);
      return Icon(Icons.medical_services_outlined, color: color, size: 40);
    }
    else if(purposeName.toLowerCase().contains('wait')){
      color =  Color(0xFF6e6cad);
      return Icon(Icons.timer_outlined, color: color, size: 40);
    }
    else if(purposeName.toLowerCase().contains('other')){
      color =  Color(0xFFdebb00);
      return Icon(Icons.adjust_rounded, color: color, size: 40);
    }
  }

  String getDetectModeOrPurpose(int index){
    if(widget.data[index]['attributes']['detected_mode_name'] == null){
      return detectedPurpose = widget.data[index]['attributes']['purpose_name'];
    }else{
      return detectedMode = widget.data[index]['attributes']['detected_mode_name'];
    }
  }

  Future<bool> patchTrip(String uuid, String tripID, String type, String result) async{
    if(uuid != "" && tripID != ""){
      String authToken = jwtGenPatch(uuid);

      final url = Uri.parse("https://bdmobility-sdk.motion-tag.de/storyline/${tripID}/");

      Map<String, String> headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${authToken}',
      };

      try {
        var body;
        if(type == "Track"){
          body = jsonEncode({
            "data": {
              "id": tripID,
              "type": "Track",
              "attributes": {
                "mode": result
              }
            },
            "meta": {
              "operation": "edit"
            }
          });
        }else{
          body = jsonEncode({
            "data": {
              "id": tripID,
              "type": "Stay",
              "attributes": {
                "purpose": result
              }
            },
            "meta": {
              "operation": "edit"
            }
          });
        }

        print('\n Response is :$result');
        final response = await http.patch(url, headers: headers, body: body);

        if (response.statusCode == 204) {
          print('\nData updated successfully');
          setState(() {
            widget.showActions == false;
            editedTrips.add(tripID);
          });
        } else {
          print('Failed to update data: ${response.statusCode}');
          print('Response body: ${response.body}');
        }
      } catch (e) {
        print("Error - Exception: $e");
      }


      return true;
    }else{
      return false;
    }
  }

  void _showDialog(BuildContext context, String header,List<Map<String, String>> items) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Select $header of Trip', textAlign: TextAlign.center,style: TextStyle(fontSize: 17),),
          content: Container(
            width: double.maxFinite,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: items.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: InkWell(
                    onTap: (){
                      String? response = items[index]['key'];
                      patchTrip(widget.uuid, widget.data[widget.index]['id'], widget.data[widget.index]['type'], response!);
                      setState(() {
                        widget.showActions = false;
                      });
                      Navigator.pop(context);
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        items[index]['name'] == detectedMode ? Text("${items[index]['name']} (Detected)", style: TextStyle(fontSize: 14, color: Colors.blue),) :
                        items[index]['name'] == detectedPurpose ? Text("${items[index]['name']} (Detected)", style: TextStyle(fontSize: 14, color: Colors.blue),): Text(items[index]['name']!, style: TextStyle(fontSize: 14),),
                        Visibility(
                          visible: currentChecked ? true : false,
                            child: Icon(Icons.check, size: 20,))
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  widget.showActions = false;
                });
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  void _showAlternativeMode(BuildContext context,List<Map<String, dynamic>> items, String detectedMode, int distance) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Column(
            children: [
              Text('Select Alternative Trip Mode', textAlign: TextAlign.center,style: TextStyle(fontSize: 16),),
              Text("If you are to make this trip again, would you like to consider a different mode for this trip?", textAlign: TextAlign.center,style: TextStyle(fontSize: 15),),
              Text("\nDetected trip details: \nTravel Mode: $detectedMode & Distance: $distance KM", textAlign: TextAlign.start,style: TextStyle(fontSize: 15),)
            ],
          ),
          content: Container(
            width: double.maxFinite,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                    height: 150,
                    child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: items.length,
                        itemBuilder: (context, index){
                          return Container (
                            width: MediaQuery.of(context).size.width/3.4,
                            padding: EdgeInsets.all(5),
                            margin: EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(
                                color: Colors.black,
                                width: 2.0,
                              ),
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children:[
                                  Text("Choice ${index +1}"),
                                  Text('Cost: ${items[0]['cost']}', textAlign: TextAlign.start, style: TextStyle(fontSize: 12),),
                                  Text('Carbon: ${items[0]['carbon']}', textAlign: TextAlign.start, style: TextStyle(fontSize: 12),),
                                  Text('Distance: ${0.5} km', textAlign: TextAlign.start, style: TextStyle(fontSize: 12),),
                                ]),
                          );
                        })
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Yes'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('No'),
            ),
          ],
        );
      },
    );
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
                  builder: (context) => HomeScreen(),
                ),
              );
            },
          )
        ],
      ),
    );
  }

  void _initializeNotifications() async {
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

  Future<void> _sendNotification({
    required int id,
    required String title,
    required String body,
  }) async {
    // Android notification details
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
    AndroidNotificationDetails(
      'channel_id', // Channel ID
      'Channel Name', // Channel name
      channelDescription: 'Channel Description', // Channel description
      importance: Importance.max,
      priority: Priority.high,
    );

    // Notification details for all platforms
    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: darwinNotificationDetails,
    );

    // Show the notification
    await flutterLocalNotificationsPlugin.show(
      id,
      title,
      body,
      platformChannelSpecifics,
    );
  }


  @override
  void initState() {
    _initializeNotifications();
    if(TripSaver().getAllTrips() != null){
      TripSaver().getAllTrips().then((trips){
        if(trips == null){return;}else {
          for(var trip in trips){
            savedTripID.add(trip.id);
          }
        }
      });

      if (widget.data[widget.index]['type'] == "Track") {
        var attributes = widget.data[widget.index]['attributes'];
        if (attributes['length'] > 500 && attributes['length'] <= 1500 &&
            (attributes['detected_mode_key'] == "car" ||
                attributes['detected_mode_key'] == "walk")) {
          setState(() {
            possibleModes.add({'mode': 'bicycle', 'cost': 3.0, 'carbon': 0,});
            possibleModes.add({'mode': 'bus', 'cost': 3.5, 'carbon': 93,});
          });
          notifications.add("New trip to Review on ${attributes['started_at']}");
          setState(() {
            notificationCount ++;
            showPrompt = false;
          });

          if(showPrompt) {
            Timer(const Duration(seconds: 5), () {
              _sendNotification(id: 3,
                  title: "New Travel Mode Questionnaire",
                  body: "If you are to make this trip again, would you like to consider a different mode for this trip?");
              _showAlternativeMode(
                  context, possibleModes, attributes['detected_mode_key'],
                  attributes['length']);
            });
            showPrompt = false;
          }
        }
      }

    }

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    int index = widget.index;
    widget.currentIDs.add(widget.data[index]['id']);

    return GestureDetector(
      onTap: (){
        if(widget.currentIDs.contains(widget.data[index]['id'])){
          setState(() {
            widget.showActions = true;
            widget.currentIDs.remove(widget.data[index]['id']);
          });
        }else{
          setState(() {
            widget.showActions = true;
          });
        }
      },
      child: Container(
        key: UniqueKey(),
        height: 70,
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 3.0),
        decoration: BoxDecoration(
          border: Border.all(color: const Color(0xFFE0E0E0)),
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child:  widget.showActions == false ? Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: widget.data[index]['type'] == "Track" ? widget.data[index]['attributes']['detected_mode_name'] == null
                        ? Icon(Icons.timer_outlined, color: Color(0xFF35ad9c), size: 40)
                        : getTrackIcon(widget.data[index]['attributes']['detected_mode_name']) :
                    widget.data[index]['attributes']['purpose_name'] == null
                        ? Icon(Icons.timer_outlined, color: Color(0xFF35ad9c), size: 40)
                        : getPurposeIcon(widget.data[index]['attributes']['purpose_key']),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(getDetectModeOrPurpose(index)),
                      Text("${DateFormat.Hm().format(DateTime.parse(widget.data[index]['attributes']['started_at']))}")
                    ],
                  ),
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  widget.data[index]['attributes']['length'] == null
                      ? Container()
                      : Text("${(widget.data[index]['attributes']['length'] / 1000).toStringAsFixed(2)} km"),
                  Text("${calculateDifferenceInMinutes(widget.data[index]['attributes']['started_at'], widget.data[index]['attributes']['finished_at'])} min"),
                  Container(
                    width: 8.0,
                    height: 8.0,
                    decoration: BoxDecoration(
                      color: savedTripID.contains(widget.data[index]['id'])  ? Colors.red: Colors.green,
                      shape: BoxShape.circle,
                    ),
                  ),
                ],
              ),
            ],
          ) : Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              GestureDetector(
                onTap: (){
                  if(widget.data[index]['type'] == "Track") {
                    _showDialog(context,"Mode", modesAvailable);
                  }
                  if(widget.data[index]['type'] == "Stay"){
                    _showDialog(context, "Purpose",purposesAvailable);
                  }
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.edit_road_outlined),
                    Text("Edit")
                  ],
                ),
              ),
              GestureDetector(
                onTap: (){
                  ConfirmTrips trips = ConfirmTrips(date: widget.data[index]['attributes']['started_at'], id: widget.data[index]['id']);
                  List<ConfirmTrips> allTrips = [];
                  allTrips.add(trips);
                  TripSaver().saveAllTrips(allTrips);
                  setState(() {
                    widget.reviewed = true;
                    widget.allConfirmed = true;
                    widget.showActions = false;
                  });
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.check_box_outlined),
                    Text("Confirm")
                  ],
                ),
              ),
              GestureDetector(
                onTap: (){
                  setState(() {
                    widget.showActions = false;
                  });
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.close),
                    Text("Close")
                  ],
                ),
              )
            ],
          )
        ),
      ),
    );
  }
}

class Grabber extends StatelessWidget {
  const Grabber({
    super.key,
    required this.onVerticalDragUpdate,
    required this.isOnDesktopAndWeb,
  });

  final ValueChanged<DragUpdateDetails> onVerticalDragUpdate;
  final bool isOnDesktopAndWeb;

  @override
  Widget build(BuildContext context) {
    if (!isOnDesktopAndWeb) {
      return const SizedBox.shrink();
    }
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return GestureDetector(
      onVerticalDragUpdate: onVerticalDragUpdate,
      child: Container(
        width: double.infinity,
        color: colorScheme.onSurface,
        child: Align(
          alignment: Alignment.topCenter,
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 8.0),
            width: 32.0,
            height: 4.0,
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
        ),
      ),
    );
  }
}

class FetchResult {
  final List<dynamic> dayTrips;
  final bool success;

  FetchResult({required this.dayTrips, required this.success});
}


