import 'package:flutter/material.dart';
import 'package:getwidget/components/toast/gf_toast.dart';
import 'package:getwidget/position/gf_toast_position.dart';
import 'package:mobi_div/models/usermodel.dart';
import 'package:motiontag_sdk/motiontag.dart';

import '../models/authservice.dart';
import '../models/inAppNotificationBadge.dart';
import 'help.dart';

class SettingsPage extends StatefulWidget {
  final int notificationCount;
  bool? isWifiOnlyDataTransferEnabled;
  bool? isTrackingActive;
  bool? isPowerSaveModeEnabled;
  bool? isBatteryOptimisationEnabled;
  SettingsPage({Key? key, this.isTrackingActive, this.isPowerSaveModeEnabled, this.isBatteryOptimisationEnabled,this.isWifiOnlyDataTransferEnabled, required this.notificationCount}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool isSet = false;
  bool isCrash = false;
  bool isBattery = false;
  bool isPower = false;
  bool isActive = false;
  bool isLoggedIn = false;
  final AuthService authService = AuthService();

  static final _motionTag = MotionTag.instance;
  late Future<User?> user;

  Future<void> _checkLoginStatus() async {
    bool loggedIn = await authService.userService.isUserLoggedIn();
    user = authService.userService.getUser();
    setState(() {
      isLoggedIn = loggedIn;
    });
  }

  @override
  void initState() {
    _checkLoginStatus();
    if(widget.isWifiOnlyDataTransferEnabled == true){
      setState(() {
        isSet = widget.isWifiOnlyDataTransferEnabled!;
      });
    }
    if(widget.isBatteryOptimisationEnabled == true){
      setState(() {
        isBattery = widget.isBatteryOptimisationEnabled!;
      });
    }
    if(widget.isPowerSaveModeEnabled == true){
      setState(() {
        isPower = widget.isPowerSaveModeEnabled!;
      });
    }
    if(widget.isTrackingActive == true){
      setState(() {
        isActive = widget.isTrackingActive!;
      });
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body:  Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            FutureBuilder<User?>(
              future: authService.userService.getUser(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (snapshot.hasData) {
                  User? user = snapshot.data;
                  if (user != null) {
                    return Text(user.email, textAlign: TextAlign.center, style: TextStyle(fontSize: 18),);
                  } else {
                    return Text("Username", textAlign: TextAlign.center, style: TextStyle(fontSize: 18),);
                  }
                } else {
                  return Text("Username", textAlign: TextAlign.center, style: TextStyle(fontSize: 18),);
                }
              },
            ),
            const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                 Container(
                   width: MediaQuery.of(context).size.width/1.3,
                   child: Column(
                     mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Notifications", textAlign: TextAlign.start,),
                    ],
                   ),
                 ),
                NotificationBadge(notificationCount: widget.notificationCount),
              ],
            ),
            const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                 Container(
                   width: MediaQuery.of(context).size.width/1.3,
                   child: Column(
                     mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Data transfer over WIFI only", textAlign: TextAlign.start,),
                      Text("Save data by transferring over WIFI instead of mobile network (track processing will be postponed until connected)",
                      style: TextStyle(fontSize: 10),),
                    ],
                   ),
                 ),
                Switch(
                  value: isSet,
                    onChanged: (val) {
                      setState(() {
                        isSet = val;
                        _motionTag.setWifiOnlyDataTransfer(isSet);
                      });
                    },
                )
              ],
            ),
            const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Battery Optimization"),
                Switch(
                  value: isBattery,
                    onChanged: (val) {
                      setState(() {
                        isBattery = val;
                      });
                    },
                )
              ],
            ),
            const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Travel Diary Recording"),
                Switch(
                  value: isActive,
                  onChanged: (val) {
                    setState(() {
                      isActive = val;
                    });
                  },
                )
              ],
            ),
            const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Power Saving"),
                Switch(
                  value: isPower,
                  onChanged: (val) {
                    setState(() {
                      isPower = val;
                    });
                  },
                )
              ],
            ),
            const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("FAQ"),
                IconButton(onPressed: (){
                  Navigator.push(context, new MaterialPageRoute(builder: (context)=>FAQPage()));
                }, icon: const Icon(Icons.arrow_right))
              ],
            ),
            const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Contact Support"),
                IconButton(onPressed: (){}, icon: const Icon(Icons.arrow_right))
              ],
            ),
            const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("App Info"),
                IconButton(onPressed: (){}, icon: const Icon(Icons.arrow_right))
              ],
            ),

            Padding(
              padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 9),
              child: GestureDetector(
                onTap: (){},
                child: Container(
                  width: MediaQuery.of(context).size.width - 35,
                  height: MediaQuery.of(context).size.height * 1 / 16,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Colors.greenAccent,
                          Colors.green,
                        ]),
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                  child: Center (
                    child:Text("Log out"),
                  )
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

