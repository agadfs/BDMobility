import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:apple_maps_flutter/apple_maps_flutter.dart' as apple;
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:getwidget/components/bottom_sheet/gf_bottom_sheet.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:location/location.dart';
import 'package:mobi_div/screens/splash.dart';
import 'package:motiontag_sdk/motiontag.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:uuid/uuid.dart';
import '../models/finalTracker.dart';
import '../models/jwt_generator.dart';
import 'dashboard.dart';


int _page = 0;
int notificationCount = 0;
final _motionTag = MotionTag.instance;
bool _isRefetching = false;
String? selectedNotificationPayload;
String? _userToken;
bool? _isTrackingActive;
bool? _isPowerSaveModeEnabled;
bool? _isBatteryOptimisationEnabled;
bool? _isWifiOnlyDataTransferEnabled;
final scrollController = ScrollController();
final GlobalKey<CurvedNavigationBarState> _bottomNavigationKey = GlobalKey();
DateTime _focusedDay = DateTime.now();
DateTime _selectedDay = DateTime.now();
CalendarFormat _calendarFormat = CalendarFormat.week;
bool isVisible = false;
bool isFabVisible = true;
bool isCalenderSelected = false;
LatLng? currentLoc;
var record;
String userToken = "", appBarText = "Home Screen";
int total_carbon_emission = 0;
late List<dynamic> calendarData = [], dayTrips = [];
List<PolylineWayPoint> newLocationWayPoints = [];
List<dynamic> allTripData = [];
final Completer<GoogleMapController> mapController = Completer();
final Completer<apple.AppleMapController> appleMapController = Completer();
const LatLng _center = LatLng(45.521563, -122.677433);
const apple.LatLng _appleCenter = apple.LatLng(45.521563, -122.677433);
List<Days> tripDays = [];
late BoxConstraints _boxConstraints;
final Set<apple.Annotation> _appleMarkers = {};
Set<Marker> markers = {};
Set<Polyline> polylinesTrack = {};
Set<apple.Polyline> applePolylinesTrack = {};
Map<PolylineId, Polyline> polylines = {};
List<LatLng> polylineCoordinates = [];
List<apple.LatLng> applePolylineCoordinates = [];
List<LatLng> trackCoordinates = [];
PolylinePoints polylinePoints = PolylinePoints();
String googleAPiKey = "AIzaSyBGIT7tPftOEf4knWZ_1HskdC3GABNec-U";
List<Days> days = [];
final String user_id = "899d6413-bbca-43c9-8aa9-9cc2596e1546";
final String baseUrl = 'https://bdmobility-sdk.motion-tag.de/';
String authToken = '';
final String tenantKey = 'bdmobility-sdk';
String uuid = const Uuid().v4();
List<String> events = [];
List tripDates = [];
bool isLocation = false, showActions = false;
String currentDate = "";
LocationData? _currentLocation;
int trackNumbers = 0;
int travelTime = 0;
double travelDistance = 0.0;
late Color color;
int travel_time = 0, trackCount = 0;
double track_len = 0.0, len =0.0;
int times = 0, tracks = 0;
var dashboardData;
late DataResponse dataResponse;
final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
Map<String, dynamic> tripHeader = {};
late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
late tz.TZDateTime? now = tz.TZDateTime.now(tz.local);
final GFBottomSheetController _controller = GFBottomSheetController();
double _sheetPosition = 0.50;
final double _dragSensitivity = 600;
List<String> notifications = [];
var textKey = UniqueKey();
final GlobalKey _calendarKey = GlobalKey();
final GlobalKey _settingsKey = GlobalKey();
final GlobalKey _mapKey = GlobalKey();
final GlobalKey _googlemapKey = GlobalKey();
final GlobalKey _confirmTrips = GlobalKey();
final GlobalKey _tripHeaderKey = GlobalKey();
final GlobalKey _tripDetailsKey = GlobalKey();
int id = 0;
late apple.BitmapDescriptor appleMarker;
late BitmapDescriptor googleMarker;
PageController _pageController = PageController();
int _currentPVPage = 0;
List<LatLng> polylineCoordinatesWalking = [];
List<LatLng> polylineCoordinatesDriving = [];
List<LatLng> polylineCoordinatesTransit = [];
List<LatLng> polylineCoordinatesCycling = [];
Set<Polyline> modePolylines = {};
PageController _scrollController = PageController();
double _previousOffset = 0;
Map<MarkerId, Marker> _markers = {};
Map<PolylineId, Polyline> _polylines = {};
List<LatLng> _polylineCoordinates = [];
PolylinePoints _polylinePoints = PolylinePoints();


class RecorderPage extends StatefulWidget {
  const RecorderPage({super.key});

  @override
  State<RecorderPage> createState() => _RecorderPageState();
}

class _RecorderPageState extends State<RecorderPage> {

  Future<String> fetchCalendar() async {
    // Define your claims
    String sub = "899d6413-bbca-43c9-8aa9-9cc2596e1546";
    String aud = "read";
    int storyline_count = 0;
    authToken = jwtGenwWithoutData(sub);

    setState(() {
      _motionTag.setUserToken(jwtGen(sub));
      _motionTag.start();
    });

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
        calendarData = jsonDecode(response.body)['data']['attributes']['days'];
        for (var day in calendarData) {
          String date = day['date'];
          storyline_count = day['storyline_count'];
          if(storyline_count > 0) {
            setState(() {
              tripDates.add(date);
              tripDays.add(Days(date: date, storyline_count: storyline_count));
            });
          }
        }

        setState(() {
          currentDate = tripDates.isNotEmpty ? tripDates.last : null;
        });
      } else {
        // Request failed, handle the error
        print("Error - Status code: ${response.statusCode}");
      }
    } catch (e) {
      // An error occurred while making the request
    }
    setState((){});
    return currentDate;
  }
  Future<List<dynamic>> fetchSpecificTrack(String trip_dt) async {
    List<dynamic> dayTrips = [];
    String sub = "899d6413-bbca-43c9-8aa9-9cc2596e1546";
    String aud = "read";
    double lat = 0.0, lng = 0.0,

        travelDistance = 0.0;
    trackNumbers = 0;
    travelTime = 0;

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

        for(var trip in dayTrips){
          var coordinates = trip['attributes']['geometry']['coordinates'];
          if(trip['attributes']['geometry']['type'] == "Point"){
            lng = trip['attributes']['geometry']['coordinates'][0];
            lat = trip['attributes']['geometry']['coordinates'][1];
            apple.LatLng origin = apple.LatLng(lat, lng);
            polylineCoordinates.add(LatLng(lat, lng));
            applePolylineCoordinates.add(origin);
            newLocationWayPoints = [];
            if(trip['attributes']['detected_mode_name'] != "" || trip['attributes']['mode_key'] != ""){
              if(trip['attributes']['mode_key'].toString().contains('walk') || trip['attributes']['mode_key'].toString().contains('walk')){
                polylineCoordinatesWalking.add(LatLng(lat, lng));
              }else if(trip['attributes']['mode_key'].toString().contains('cycle') || trip['attributes']['mode_key'].toString().contains('cycle')){
                polylineCoordinatesCycling.add(LatLng(lat, lng));
              }
              else if(trip['attributes']['mode_key'].toString().contains('car') || trip['attributes']['mode_key'].toString().contains('car')){
                polylineCoordinatesDriving.add(LatLng(lat, lng));
              }else{
                polylineCoordinatesTransit.add(LatLng(lat, lng));
              }
            }
          }else{
            for(var coord in trip['attributes']['geometry']['coordinates']){
              polylineCoordinates.add(LatLng(coord[1],coord[0]));
              applePolylineCoordinates.add(apple.LatLng(coord[1],coord[0]));
              newLocationWayPoints.add(PolylineWayPoint(location: "${coord[1].toString()},${coord[0].toString()}"));
              if(trip['attributes']['detected_mode_name'] != "" || trip['attributes']['mode_key'] != ""){
                if(trip['attributes']['mode_key'].toString().contains('walk') || trip['attributes']['mode_key'].toString().contains('walk')){
                  polylineCoordinatesWalking.add(LatLng(coord[1],coord[0]));
                }else if(trip['attributes']['mode_key'].toString().contains('cycle') || trip['attributes']['mode_key'].toString().contains('cycle')){
                  polylineCoordinatesCycling.add(LatLng(coord[1],coord[0]));
                }
                else if(trip['attributes']['mode_key'].toString().contains('car') || trip['attributes']['mode_key'].toString().contains('car')){
                  polylineCoordinatesDriving.add(LatLng(coord[1],coord[0]));
                }else{
                  polylineCoordinatesTransit.add(LatLng(coord[1],coord[0]));
                }
              }
            }
            newLocationWayPoints.removeAt(0);
            newLocationWayPoints.removeAt(newLocationWayPoints.length - 1);
          }
        }

      } else {
        dayTrips = [];
        // Request failed, handle the error
        print("Error - Status code: ${response.statusCode}");

      }
    } catch (e) {
      // An error occurred while making the request
      print("Error - Exception: $e");
    }
    return dayTrips;
  }

  void _onScroll() {
    double currentOffset = _scrollController.offset;

    if (currentOffset > _previousOffset) {
      setState(() {});
    } else if (currentOffset < _previousOffset) {
      setState(() {});
    }

    _previousOffset = currentOffset;
  }
  void _onMapCreated(apple.AppleMapController controller) {
    if (appleMapController.isCompleted) {
      setState(() {});
      return;
    } else {
      setState(() {});
      appleMapController.complete(controller);
    }
  }
  bool get _isOnDesktopAndWeb {
    if (kIsWeb) {
      return true;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.macOS:
      case TargetPlatform.linux:
      case TargetPlatform.windows:
        return true;
      case TargetPlatform.android:
      case TargetPlatform.iOS:
      case TargetPlatform.fuchsia:
        return false;
    }
  }

  moveRight(int index){
    int currentIndex = 0;
    int previousIndex = 0;

    // if(){
    //
    // }
  }

  @override
  void initState() {
    fetchCalendar();
    print("\n\ncurrentDate is $currentDate");
    if(currentDate != null) {
      fetchSpecificTrack(currentDate);
    }
    _scrollController.addListener(_onScroll);
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  _addMarker(LatLng position, String id, BitmapDescriptor descriptor) {
    MarkerId markerId = MarkerId(id);
    Marker marker =
    Marker(markerId: markerId, icon: descriptor, position: position);
  }

  _addPolyLine() {
    PolylineId id = PolylineId("poly");
    Polyline polyline = Polyline(
        polylineId: id, color: Colors.red, points: polylineCoordinates);
    polylines[id] = polyline;
    setState(() {});
  }

  _getPolyline() async {
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      googleApiKey: googleAPiKey,
      request: PolylineRequest(
        origin: PointLatLng(polylineCoordinates.first.latitude, polylineCoordinates.first.longitude),
        destination: PointLatLng(polylineCoordinates.last.latitude, polylineCoordinates.last.longitude),
        mode: TravelMode.driving,
        wayPoints: [PolylineWayPoint(location: "Sabo, Yaba Lagos Nigeria")],
      ),
    );
    if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
    }
    _addPolyLine();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        AnimatedContainer(
            duration: Duration(milliseconds: 300),
            height: MediaQuery.of(context).size.height * (1 - _sheetPosition),
            child: Platform.isAndroid ? GoogleMap(
              key: _googlemapKey,
              onMapCreated: (GoogleMapController controller) {
                if (mapController.isCompleted) {
                  setState(() {});
                  return;
                } else {
                  mapController.complete(controller);
                  setState(() {});
                }
              },
              initialCameraPosition: CameraPosition(
                  target: polylineCoordinates.isEmpty ? _center : polylineCoordinates.first,
                  zoom: 12.5
              ),
              markers: markers,
              polylines: polylinesTrack,
              myLocationEnabled: false,
              myLocationButtonEnabled: false,
              mapType: MapType.normal,
            ):
            Platform.isIOS ? apple.AppleMap(onMapCreated: _onMapCreated,
              initialCameraPosition: apple.CameraPosition(
                  heading: 270.0,
                  target: applePolylineCoordinates.isEmpty ? _appleCenter : applePolylineCoordinates.first,
                  zoom: 11.0,
                  pitch: 10.0
              ),
              polylines: applePolylinesTrack,
              annotations: _appleMarkers,
            ):Container()
        ),
        DraggableScrollableSheet(
          initialChildSize: _sheetPosition,
          builder: (BuildContext context, ScrollController scrollController) {
            return ColoredBox(
              color: Colors.transparent,
              child: Column(
                children: <Widget>[
                  Grabber(
                    onVerticalDragUpdate: (DragUpdateDetails details) {
                      setState(() {
                        _sheetPosition -= details.delta.dy / _dragSensitivity;
                        if (_sheetPosition < 0.25) {
                          _sheetPosition = 0.25;
                        }
                        if (_sheetPosition > 1.0) {
                          _sheetPosition = 1.0;
                        }
                      });
                    },
                    isOnDesktopAndWeb: _isOnDesktopAndWeb,
                  ),
                  Expanded(
                    child: Container(
                      height: _sheetPosition,
                      decoration: BoxDecoration(
                          color: Colors.white
                      ),
                      child: PageView.builder(
                          controller: _scrollController,
                          scrollDirection: Axis.horizontal,
                          itemCount: tripDates.length,
                          itemBuilder: (BuildContext context, index){
                        return currentDate == null
                            ? CircularProgressIndicator(): Column(
                          children: [
                            SizedBox(
                              width: 50,
                              height: 15,
                              child: Divider(
                                thickness: 5,
                                height: 15,
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                GestureDetector(
                                  onTap: (){
                                  },
                                    child: Icon(Icons.chevron_left, size: 30)),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text('$trackNumbers Trips', style: TextStyle(fontSize: 12),),
                                    Text(', ${travelTime ~/60} Hrs., ${travelTime % 60} min,' ,style: TextStyle(fontSize: 12),), Text(' ${(travelDistance/1000).toStringAsFixed(2)} km', style: TextStyle(fontSize: 12),),
                                  ],
                                ),
                                GestureDetector(onTap: (){

                                },child: Icon(Icons.chevron_right, size: 30,)),
                              ],
                            ),
                            Flexible(
                              child: ListView.builder(
                                itemCount: dayTrips.length,
                                itemBuilder: (context, index) {
                                  int _selectedIndex = -1;
                                  int currentIndex = index;
                                  return TripEvents(allConfirmed: false,uuid: "899d6413-bbca-43c9-8aa9-9cc2596e1546", data: dayTrips, index: index, currentTripIDs: [],);
                                },
                              ),
                            ),
                          ],
                        );
                      }),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}
