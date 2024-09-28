import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import 'finalTracker.dart';
import 'jwt_generator.dart';

class TrackState with ChangeNotifier {
  double lat = 0.0;
  double lng = 0.0;
  List<LatLng> trackCoordinates = [];
  bool isLocationChanged = false;

  void updateLocation(double newLat, double newLng) {
    lat = newLat;
    lng = newLng;
    notifyListeners();
  }

  void addTrackCoordinates(List<LatLng> newCoordinates) {
    trackCoordinates.addAll(newCoordinates);
    notifyListeners();
  }

  void clearTrackCoordinates() {
    trackCoordinates.clear();
    notifyListeners();
  }

  void setLocationChanged(bool value) {
    isLocationChanged = value;
    notifyListeners();
  }
}


class TrackScreen extends StatelessWidget {

  Map<MarkerId, Marker> markers = {};
  Map<PolylineId, Polyline> polylines = {};
  List<LatLng> polylineCoordinates = [];
  PolylinePoints polylinePoints = PolylinePoints();
  String googleAPiKey = "Please provide your api key";

  Future<List<dynamic>> fetchSpecificTrack(String trip_dt) async {
    List<dynamic> dayTrips = [];
    String sub = "899d6413-bbca-43c9-8aa9-9cc2596e1546";
    String aud = "read";
    double lat = 0.0, lng = 0.0;
    int trackNumbers = 0;
    double travelDistance = 0.0;
    int travelTime = 0;

    String authToken = jwtGenwWithoutData(sub);
    String url = "https://bdmobility-sdk.motion-tag.de/storyline/${trip_dt}/";

    Map<String, String> queryParams = {
      'sub': sub,
      'aud': aud,
    };

    String queryString = Uri(queryParameters: queryParams).query;
    url += '?' + queryString;


    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${authToken}',
    };

    try {
      // Make the GET request
      http.Response response = await http.get(
        Uri.parse(url),
        headers: headers,
      );

      dayTrips = jsonDecode(response.body)['data'];
      dayTrips.map((data) => StoryLine.fromJson(data)).toList();

      // Check the response status code
      if (response.statusCode == 200) {
        for(var trip in jsonDecode(response.body)['data']){
          if(trip['type'] == 'Track'){
            trackNumbers += 1;
            travelDistance += (trip['attributes']['length']);
          }
          travelTime += calculateDifferenceInMinutes(trip['attributes']['started_at'], trip['attributes']['finished_at']);

          var coordinates = trip['attributes']['geometry']['coordinates'];
          if(trip['attributes']['geometry']['type'] == "Point"){
            lng = trip['attributes']['geometry']['coordinates'][0];
            lat = trip['attributes']['geometry']['coordinates'][1];
            polylineCoordinates.add(LatLng(lat, lng));
          }else{
            for(var coord in trip['attributes']['geometry']['coordinates']){
              polylineCoordinates.add(LatLng(coord[1],coord[0]));
            }
          }
        }

      } else {
        // Request failed, handle the error
        print("Error - Status code: ${response.statusCode}");
      }
    } catch (e) {
      // An error occurred while making the request
      print("Error - Exception: $e");
    }
    return dayTrips;
  }

  @override
  Widget build(BuildContext context) {
    String date = "2024-05-18"; // Example date

    return Scaffold(
      appBar: AppBar(title: Text('Track App')),
      body: FutureBuilder<List<dynamic>>(
        future: fetchSpecificTrack(date),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            if (snapshot.hasData && snapshot.data!.length < 1) {
              return Center(child: Text("No data recorded"));
            } else {
              return Center(child: CircularProgressIndicator());
            }
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            return Consumer<TrackState>(
              builder: (context, trackState, child) {
                return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        if (snapshot.data![index]['type'] == 'Stay') {
                          double lng = snapshot.data![0]['attributes']['geometry']['coordinates'][0];
                          double lat = snapshot.data![0]['attributes']['geometry']['coordinates'][1];
                          trackState.updateLocation(lat, lng);
                        } else {
                          List<LatLng> coordinates = [];
                          for (var coord in snapshot.data![index]['attributes']['geometry']['coordinates']) {
                            coordinates.add(LatLng(coord[1], coord[0]));
                          }
                          trackState.clearTrackCoordinates();
                          trackState.addTrackCoordinates(coordinates);
                        }
                      },
                      child: Container(
                        height: 70,
                        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 3.0),
                        decoration: BoxDecoration(
                          border: Border.all(color: const Color(0xFFE0E0E0)),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: snapshot.data![index]['attributes']['detected_mode_name'] == null
                                        ? Icon(Icons.timer_outlined, color: Color(0xFF35ad9c), size: 40)
                                        : getTrackIcon(snapshot.data![index]['attributes']['detected_mode_name']),
                                  ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      snapshot.data![index]['attributes']['detected_mode_name'] == null
                                          ? Text("Waiting", textAlign: TextAlign.start)
                                          : Text("${snapshot.data![index]['attributes']['detected_mode_name']}"),
                                      Text("${DateFormat.Hm().format(DateTime.parse(snapshot.data![index]['attributes']['started_at']))}")
                                    ],
                                  ),
                                ],
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  snapshot.data![index]['attributes']['length'] == null
                                      ? Container()
                                      : Text("${(snapshot.data![index]['attributes']['length'] / 1000).round()} km"),
                                  Text("${calculateDifferenceInMinutes(snapshot.data![index]['attributes']['started_at'], snapshot.data![index]['attributes']['finished_at'])} min")
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            );
          }
        },
      ),
    );
  }

  getTrackIcon(String modeName){
    Color color;
    if(modeName == 'Airplane'){
      Color color =  Color(0xFFe9b100);
      return Icon(Icons.airplanemode_on_outlined, color: color, size: 40);
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
  int calculateDifferenceInMinutes(String startedAt, String finishedAt) {
    DateTime startedDateTime = DateTime.parse(startedAt);
    DateTime finishedDateTime = DateTime.parse(finishedAt);

    Duration difference = finishedDateTime.difference(startedDateTime);
    int differenceInMinutes = difference.inMinutes;

    return differenceInMinutes % 60;
  }
}

