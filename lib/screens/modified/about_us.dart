import 'dart:io';
import 'package:flutter/material.dart';
import 'package:mobi_div/screens/modified/faq.dart';
import 'package:webview_all/webview_all.dart';
import 'package:webview_flutter/webview_flutter.dart';

class AboutUs extends StatefulWidget {
  const AboutUs({super.key});

  @override
  State<AboutUs> createState() => _AboutUsState();
}

class _AboutUsState extends State<AboutUs> {
  // late WebViewController _controller;
  bool _isConnected = false;
  String url = "";


  Future<void> checkConnection() async {
    try {
      // Try to look up google.com. If this fails, there's no internet connection.
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        setState(() {
          _isConnected = true;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Loading content ...')),
        );
        // _controller = WebViewController()
        //   ..setJavaScriptMode(JavaScriptMode.unrestricted)
        //   ..setNavigationDelegate(
        //     NavigationDelegate(
        //       onNavigationRequest: (NavigationRequest request) {
        //         return NavigationDecision.navigate;
        //       },
        //     ),
        //   )
        //   ..loadRequest(Uri.parse('https://www.torontomu.ca/bridging-divides/about/'));
      }
    } on SocketException catch (_) {
      setState(() {
        _isConnected = false;
      });
    }
  }


  @override
  void initState() {
    super.initState();
    checkConnection();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber[600],
        title: Text("About Us", style: TextStyle(fontWeight: FontWeight.bold, fontFamily: 'NotoSans'),),
        actions: [
          IconButton(
              onPressed: (){
                Navigator.push(context, new MaterialPageRoute(builder: (context) => FaqPage()));
              },
              icon: Icon(Icons.help_outline_outlined))
        ],
      ),
      body: _isConnected ? Webview(url: "https://www.torontomu.ca/bridging-divides/about/") : Center(
       child:  Stack(
         children: [
           CircularProgressIndicator(),
         ],
       )
      ),
    );
  }
}
