import 'package:flutter/material.dart';

class FaqPage extends StatefulWidget {
  @override
  _FaqPageState createState() => _FaqPageState();
}

class _FaqPageState extends State<FaqPage> {
  List<Panel> panels = [
    Panel(
        'HOW CAN I GET MY TRAVELS LOGGED?',
        'By default, users can have their travels logged. When all essential permissions like: Location Always, Activity Recognition, and Sensors are granted',
        false),
    Panel(
        'HOW CAN I ACTIVATE THE REQUIRED PERMISSIONS?',
        'All required permissions are requested on first use of the application, during user account creation.',
        false),
    Panel(
        'HOW CAN I VIEW MY TRIPS?',
        'You would have to go to main screen select -> Days card and select any trip displayed',
        false),
    Panel(
        'WHAT INFORMATION IS LOGGED AND WHAT WILL IT BE USED FOR?',
        'We value your information and we ensure adequate security measures are adhered to while we log your information, for the purpose of this research your information in the form of social demographics, residential and travel preferences are recorded',
        false),
    Panel(
        'HOW CAN I ACCESS ALL MY INFORMATION?',
        'Your personal information can be viewed from the accounts page, while your responses to survey questionnaires can be view from the respective survey category.',
        false),
    Panel(
        'WHERE CAN I READ MORE ON THE INITIATIVES OF THIS RESEARCH',
        'By default, the last used shipping address will be saved intoto your Sample Store account. When you are checkingout your order, the default shipping address will be displayedand you have the option to amend it if you need to.',
        false),
    Panel(
        'WHERE CAN I READ MORE ON THE INITIATIVES OF THIS RESEARCH',
        'Kindly use the about section from the home page to access the details on this research or visit https://https://www.torontomu.ca/bridging-divides/about/ ',
        false)
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
        backgroundColor: Colors.transparent,
        title: Text(
          'Help',
          style: TextStyle(color: Colors.black),
        ),
        elevation: 0,
      ),
      body: SafeArea(
        bottom: true,
        child: Padding(
          padding: const EdgeInsets.only(top: 24.0),
          child: ListView(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(left:24.0,right:24.0,bottom: 16.0),
                child: Text(
                  'FAQ',
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 18.0),
                ),
              ),... panels.map((panel)=>ExpansionTile(
                  title: Text(
                    panel.title,
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[600]),
                  ),

                  children: [Container(
                      padding: EdgeInsets.all(16.0),
                      color: Color(0xffFAF1E2),
                      child: Text(
                          panel.content,
                          style:
                          TextStyle(color: Colors.grey, fontSize: 12)))])).toList(),

            ],
          ),
        ),
      ),
    );
  }
}

class Panel {
  String title;
  String content;
  bool expanded;

  Panel(this.title, this.content, this.expanded);
}

class PanelWithImages{
  String title;
  String content;
  String imageurl;
  bool expanded;

  PanelWithImages(this.title, this.imageurl,this.content, this.expanded);
}