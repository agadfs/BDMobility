import 'dart:convert';
import 'package:http/http.dart' as http;
import 'finalTracker.dart';
import 'jwt_generator.dart';

class APIHandler{

  Future<List<Days>> fetchCalendar(String userID) async {
    // Define your claims
    String sub = userID;
    List<Days> tripDays = [];
    List<dynamic> calendarData = [];
    String aud = "read";
    int storyline_count = 0;
    String authToken = jwtGenwWithoutData(sub);

    String url = "https://bdmobility-sdk.motion-tag.de/calendar/${DateTime.now().year}/";

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

      // Check the response status code
      if (response.statusCode == 200) {
        print("Calendar events working correctly");
        calendarData = jsonDecode(response.body)['data']['attributes']['days'];
        for (var day in calendarData.reversed) {
          String date = day['date'];
          storyline_count = day['storyline_count'];
          if(storyline_count > 0) {
            tripDays.add(Days(date: date, storyline_count: storyline_count));
          }
        }

      } else {
        // Request failed, handle the error
        print("Error fetch calendar - Status code: ${response.statusCode}");
      }
    } catch (e) {
      // An error occurred while making the request
    }
    return tripDays;
  }

  Future<List<dynamic>> fetchSpecificTrack(String trip_dt, String userID) async {
    List<dynamic> dayTrips = [];
    String sub = userID;
    String aud = "read";

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

      // Check the response status code
      if (response.statusCode == 200) {
        dayTrips = jsonDecode(response.body)['data'];
        dayTrips.map((data) => StoryLine.fromJson(data)).toList();
      } else {
        // Request failed, handle the error
        print("Error fetch trips - Status code: ${response.statusCode}");
      }
    } catch (e) {
      // An error occurred while making the request
      print("Error fetch trips - Exception: $e");
    }

    return dayTrips;
  }

}