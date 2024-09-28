import 'dart:async';
import 'package:intl/intl.dart';
import 'dart:convert';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';import 'dart:io';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:getwidget/components/bottom_sheet/gf_bottom_sheet.dart';
import 'package:getwidget/components/toast/gf_toast.dart';
import 'package:getwidget/position/gf_toast_position.dart';
import 'package:http/http.dart' as http;
import 'package:mobi_div/models/usermodel.dart';
import 'package:mobi_div/screens/dashboard.dart';
import 'package:mobi_div/screens/notificationsPage.dart';
import 'package:mobi_div/screens/settings.dart';
import 'package:mobi_div/screens/splash.dart';
import 'package:mobi_div/screens/surveyscreen.dart';
import 'package:mobi_div/screens/userprofile.dart';
import 'package:permission_handler/permission_handler.dart' as perm;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:uuid/uuid.dart';
import '../controls.dart';
import '../logs.dart';
import '../models/authservice.dart';
import '../models/finalTracker.dart';
import '../models/jwt_generator.dart';
import 'package:location/location.dart';
import '../status.dart';
import 'package:apple_maps_flutter/apple_maps_flutter.dart' as apple;
import 'package:provider/provider.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:motiontag_sdk/events/motiontag_event.dart';
import 'package:motiontag_sdk/motiontag.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../models/powersave.dart';


class HomeScreen extends StatefulWidget with ChangeNotifier{

  static final _globalKey = GlobalKey<_HomeScreenState>();
  HomeScreen({super.key, this.userID, this.userToken});

  final String? userID, userToken;

  static const String routeName = '/';


  double lat = 0.0;
  double lng = 0.0, tripDist = 0.0;
  int dateMinutes = 0, trackCounter = 0;
  List<LatLng> trackCoordinates = [];
  List currentIDs = [];
  bool isLocationChanged = false;
  int get tractCount => trackCounter;

  void increment() {
    trackCounter++;
    notifyListeners();
  }

  static _HomeScreenState of(BuildContext context) => _globalKey.currentState!;

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

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  int _page = 0;
  int notificationCount = 0;
  static final _motionTag = MotionTag.instance;
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
  late Completer<GoogleMapController> mapController = Completer();
  final Completer<apple.AppleMapController> appleMapController = Completer();
  LatLng _center = LatLng(45.521563, -122.677433);
  apple.LatLng _appleCenter = apple.LatLng(45.521563, -122.677433);
  Location location = new Location();
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
  String user_id = "", user_token = "";
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
  bool showPrompt = false;
  late AnimationController animationController;
  late Animation<double> _animation;
  bool _showBadge = true;
  final AuthService authService = AuthService();
  late apple.CameraPosition appleCameraPosition;
  late CameraPosition androidCameraPosition;


  void _onMapCreated(apple.AppleMapController controller) {
    if (appleMapController.isCompleted) {
      setState(() {});
      return;
    } else {
      setState(() {});
      appleMapController.complete(controller);
    }
  }

  List<LatLng> returnFetchedPolylines(List<LatLng> polylines ){
    if(polylines.isNotEmpty){
      print("Not empty");
      return polylines;
    }else{
      return [];
    }
  }

  DarwinNotificationDetails iosNotificationDetails = DarwinNotificationDetails(
    categoryIdentifier: darwinNotificationCategoryPlain,
  );

  final List<DarwinNotificationCategory> darwinNotificationCategories =
  <DarwinNotificationCategory>[
    DarwinNotificationCategory(
      darwinNotificationCategoryText,
      actions: <DarwinNotificationAction>[
        DarwinNotificationAction.text(
          'text_1',
          'Action 1',
          buttonTitle: 'Send',
          placeholder: 'Placeholder',
        ),
      ],
    ),
    DarwinNotificationCategory(
      darwinNotificationCategoryPlain,
      actions: <DarwinNotificationAction>[
        DarwinNotificationAction.plain('id_1', 'Action 1'),
        DarwinNotificationAction.plain(
          'id_2',
          'Action 2 (destructive)',
          options: <DarwinNotificationActionOption>{
            DarwinNotificationActionOption.destructive,
          },
        ),
        DarwinNotificationAction.plain(
          navigationActionId,
          'Action 3 (foreground)',
          options: <DarwinNotificationActionOption>{
            DarwinNotificationActionOption.foreground,
          },
        ),
        DarwinNotificationAction.plain(
          'id_4',
          'Action 4 (auth required)',
          options: <DarwinNotificationActionOption>{
            DarwinNotificationActionOption.authenticationRequired,
          },
        ),
      ],
      options: <DarwinNotificationCategoryOption>{
        DarwinNotificationCategoryOption.hiddenPreviewShowTitle,
      },
    )
  ];


  void setCustomMapPin() async {
    appleMarker = await apple.BitmapDescriptor.fromAssetImage(
        ImageConfiguration(devicePixelRatio: 2.5, size: Size(100, 100)),
        'assets/marker.png');
    googleMarker = await BitmapDescriptor.fromAssetImage( ImageConfiguration(devicePixelRatio: 2.5, size: Size(100, 100)),
        'assets/marker.png');
  }

  confirmAllTrips() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isConfirmed = prefs.getBool('confirmTrips') ?? true;

    if (isConfirmed) {
      await prefs.setBool('confirmTrips', false);
    }
    setState(() {});
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

    refresh();
  }


  void _onSetUserToken(String userToken) => _executeInteraction(
    logMessage: 'Updating the user token to $userToken',
    function: () => _motionTag.setUserToken(userToken),
  );

  void _onSetWifiOnlyDataTransfer(bool wifiOnlyDataTransfer) =>
      _executeInteraction(
        logMessage:
        'Updating the wifi only data transfer to $wifiOnlyDataTransfer',
        function: () =>
            _motionTag.setWifiOnlyDataTransfer(wifiOnlyDataTransfer),
      );

  Future<void> _onStart() async => _executeInteraction(
    logMessage: 'Starting the SDK',
    function: () => _motionTag.start(),
  );

  void _onStop() => _executeInteraction(
    logMessage: 'Stopping the SDK',
    function: () => _motionTag.stop(),
  );

  void _onClearData() => _executeInteraction(
    logMessage: 'Clearing data',
    function: () => _motionTag.clearData(),
  );

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

  Future<void> _onRequestLocationInUsePermission() => _requestPermission(
    name: 'location (in use)',
    permission: perm.Permission.locationWhenInUse,
  );

  Future<void> _onRequestLocationAlwaysPermission() => _requestPermission(
    name: 'location (always)',
    permission: perm.Permission.locationAlways,
  );

  Future<void> _onRequestMotionSensorPermission() => _requestPermission(
    name: 'motion',
    permission: perm.Permission.sensors,
  );

  Future<void> _initializePermissionsAndStartSdk() async {
    await _onRequestLocationAlwaysPermission();
    await _onRequestActivityRecognitionPermission();
    await _onRequestMotionSensorPermission();
    await fetchLocationUpdates();
    String userID = await getSavedDetails();

    if(userID.isNotEmpty){
      setState(() {
        user_id = userID;
      });

      _onSetUserToken(jwtGen(userID));
      _onStart();

      if(userID.isNotEmpty) {
        await fetchCalendar(userID);
        await fetchSyncData();
      }
    }else{
      print("\nuser id is empty");
    }

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

  Future<String> fetchCalendar(String userID) async {
    // Define your claims
    String sub = userID;
    String aud = "read";
    int storyline_count = 0;
    authToken = jwtGenwWithoutData(sub);

    print("Auth token is: $authToken");

    _motionTag.isTrackingActive().then((val){
      if(val == true){
        GFToast.showToast(
          'Starting travel recording',
          context,
          toastDuration: 3,
          toastPosition: GFToastPosition.BOTTOM,
          textStyle: TextStyle(fontSize: 14, color: Colors.white.withOpacity(0.8)),
          backgroundColor: Colors.black87,
        );
      }
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
        print("Calendar events working correctly");
        calendarData = jsonDecode(response.body)['data']['attributes']['days'];
        for (var day in calendarData.reversed) {
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
        print("Error fetch calendar - Status code: ${response.statusCode}");
      }
    } catch (e) {
      // An error occurred while making the request
    }
    setState((){});
    return currentDate;
  }


  Stream<FetchResult> fetchSpecificTrack(String trip_dt) async* {
    List<dynamic> dayTrips = [];
    String sub = user_id;
    String aud = "read";
    double lat = 0.0, lng = 0.0, travelDistance = 0.0;
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

        yield FetchResult(dayTrips: dayTrips, success: true);
      } else {
        // Request failed, handle the error
        print("Error fetch trips - Status code: ${response.statusCode}");
        yield FetchResult(dayTrips: [], success: false);
      }
    } catch (e) {
      // An error occurred while making the request
      print("Error fetch trips - Exception: $e");
      yield FetchResult(dayTrips: [], success: false);
    }
  }

  int calculateTracks(){
    return trackNumbers += 1;
  }

  int calculateTime(int time){
    travelTime += time;
    return travelTime;
  }

  double calculateDistance(int length){
    travelDistance += length;
    return travelDistance;
  }

  Future<void> fetchSyncData() async {
    authToken = jwtGenwSync();

    String url = "https://bdmobility-sdk.motion-tag.de/sync/storyline/";

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
        for(var trip in jsonDecode(response.body)['data']){
          if(trip['attributes']['user_id'].toString().trim() == user_id){
            if(trip['type'] == 'Track') {
              trackCount += 1;
              track_len += (trip['attributes']['track_length_in_meters']/1000).round();
            }
            travel_time += calculateDifferenceInMinutes(trip['attributes']['started_at'], trip['attributes']['finished_at']);
          }
        }

        dashboardData = jsonDecode(response.body)['data'];

        setState(() {});
      } else {
        // Request failed, handle the error
        print("Error fetch dashboard data - Status code: ${response.body} Sync not working");
      }
    } catch (e) {
      print("Error fetch dashboard data - Exception: $e");
    }
    setState((){});
  }

  Future<void> fetchLocationUpdates() async {
    Location location = new Location();
    bool serviceEnabled;
    PermissionStatus permissionGranted;

    if (await perm.Permission.locationAlways.isDenied) {
      _onRequestLocationAlwaysPermission();
    }
    if(await perm.Permission.activityRecognition.isDenied){
      _onRequestActivityRecognitionPermission();
    }
    if(await perm.Permission.sensors.isDenied){
      _onRequestMotionSensorPermission();
    }

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return;
      }
    }

    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    // LocationData _locationData = await location.getLocation();
    // if (_locationData != null) {
    //   location.enableBackgroundMode(enable: true);
    //   location.onLocationChanged.listen((LocationData currentLocation) {
    //     _currentLocation = currentLocation;
    //     setState(() {});
    //   });
    // } else {
    //   print("\nFetching location is pending");
    // }
  }

  void checkPowerSaveMode() async {
    bool isEnabled = await PowerSaveMode.isPowerSaveModeEnabled();
    print('Power Save Mode is enabled: $isEnabled');
  }

  void refresh() async {
    if (_isRefetching) return;
    setState(() {
      _isRefetching = true;
    });

    final userToken = await _motionTag.getUserToken();
    final isTrackingActive = await _motionTag.isTrackingActive();
    final isPowerSaveModeEnabled = await _motionTag.isPowerSaveModeEnabled();
    final isBatteryOptimisationEnabled = await _motionTag.isBatteryOptimizationsEnabled();
    final isWifiOnlyDataTransferEnabled = await _motionTag.getWifiOnlyDataTransfer();

    setState(() {
      _isRefetching = false;
      _userToken = userToken;
      _isTrackingActive = isTrackingActive;
      _isPowerSaveModeEnabled = isPowerSaveModeEnabled;
      _isBatteryOptimisationEnabled = isBatteryOptimisationEnabled;
      _isWifiOnlyDataTransferEnabled = isWifiOnlyDataTransferEnabled;
    });
  }

  void _addNotification(String notification) {
    setState(() {
      notifications.add(notification);
      notificationCount++;
    });
  }

  void _handleNotificationAction(String payload) {
    _addNotification('Marked for Later: $payload');
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      _pageController.dispose();
      animationController.dispose();
      _disposeController();
    }
    if(state == AppLifecycleState.resumed){
      setState(() {});
    }
  }

  @override
  void didChangeDependencies() {
    refresh();
    setState(() {});
    super.didChangeDependencies();
  }

  void _disposeController() async {
    final GoogleMapController controller = await mapController!.future;
    final apple.AppleMapController appleController = await appleMapController!.future;

    controller.dispose();

    if(markers.isNotEmpty) {
      markers.remove(true);
    }
    if(markers.isNotEmpty) {
      markers.remove(true);
    }
    setState(() {});
  }

  Widget detectTracking() {
    String msg = "";
    MotionTag.instance.setObserver((event) {
      if(event == MotionTagEventType.started){
        msg = "Recording has started";
      }else if(event == MotionTagEventType.stopped){
        msg = "Recording has stop..";
      }else if(event == MotionTagEventType.transmissionSuccess){
        msg = "Recording transmitted successfully";
      }else if(event == MotionTagEventType.transmissionError){
        msg = "Recording transmission error";
      }
    });
    return Text(msg);
  }

  @override
  void dispose(){
    if(mapController != null){
      mapController = Completer();
      _disposeController();
    }
    scrollController.dispose();

    super.dispose();
  }

  Future<bool> isTracking () async{
    bool result = await MotionTag.instance.isTrackingActive();
    return result;
  }

  Future<String> getSavedDetails () async{
      SharedPreferences prefs = await SharedPreferences.getInstance();
      if(prefs.getString("user_id")!= null &&  prefs.getString("user_token")!= null) {
        setState(() {
          user_id = prefs.getString("user_id").toString();
        });
        return user_id;
      }else{
        return "";
      }
  }

  @override
  void initState() {
    setState(() {
      androidCameraPosition = CameraPosition(
          target:  _center,
          zoom: 12.5
      );
      appleCameraPosition =  apple.CameraPosition(
          heading: 270.0,
          target:_appleCenter,
          zoom: 11.0,
          pitch: 10.0
      );
      trackNumbers = 0;
      travelDistance = 0.0;
      travelTime = 0;
    });

    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('@mipmap/ic_launcher');

    final DarwinInitializationSettings initializationSettingsDarwin =
    DarwinInitializationSettings(
      requestSoundPermission: false,
      requestBadgePermission: false,
      requestAlertPermission: false,
      onDidReceiveLocalNotification: onDidReceiveLocalNotification,
    );

    final InitializationSettings initializationSettings =
    InitializationSettings(
        android: initializationSettingsAndroid,
        iOS: initializationSettingsDarwin
    );
    flutterLocalNotificationsPlugin.initialize(initializationSettings, onDidReceiveNotificationResponse: (NotificationResponse notificationResponse) async {
      if (notificationResponse.actionId == 'mark_for_later') {
        _handleNotificationAction("Trip details will be displayed");
        notificationCount++;
      }
    },
    );

    _initializePermissionsAndStartSdk();
    WidgetsBinding.instance.addPostFrameCallback((_) async => location.getLocation().then((loc) async{
          _currentLocation = loc;
          _center = LatLng(loc.latitude!, loc.longitude!);
          _appleCenter = apple.LatLng(loc.latitude!, loc.longitude!);
          androidCameraPosition = CameraPosition(target: _center,
              zoom: 12.5);

          appleCameraPosition = apple.CameraPosition(target: _appleCenter,
              heading: 270.0,
              zoom: 11.0,
              pitch: 10.0);

          print("\nLocation set: $_currentLocation");

          final GoogleMapController controller = await mapController!.future;
          final apple.AppleMapController appleController = await appleMapController!.future;


          setState(() {
            controller.animateCamera(
                CameraUpdate.newCameraPosition(CameraPosition(
                    bearing: 192.8334901395799,
                    target: _center,
                    tilt: 59.440717697143555,
                    zoom: 15.151926040649414)));

            appleController.animateCamera(apple.CameraUpdate.newCameraPosition(
                apple.CameraPosition(target: _appleCenter,
                  zoom: 13.5,
                )
            ));
          });
    }
      )
    );


    WidgetsBinding.instance.addPostFrameCallback((_) async => await initializeMap());

    if(_motionTag.isTrackingActive() == true){
      print("\n tracking is active");
    }

    setCustomMapPin();

    WidgetsBinding.instance.addPostFrameCallback((_) async => await _scheduleYearlyMondayTenAMNotification());

    // _checkFirstTimeUser();

    animationController = AnimationController(
      duration: Duration(seconds: 1),
        vsync: this,
        )
      ..repeat(reverse: true);

      _animation = Tween<double>(begin: 0.8, end: 1.2).animate(CurvedAnimation(
        parent: animationController,
        curve: Curves.easeInOut,
      )
    );

    _pageController.addListener(_onScroll);
    _pageController.addListener(() {
      setState(() {
        _currentPVPage = _pageController.page?.round() ?? 0;
        if(polylinesTrack.isNotEmpty || applePolylinesTrack.isNotEmpty){
          GFToast.showToast(
            'Loading trajectory',
            context,
            toastDuration: 3,
            toastPosition: GFToastPosition.BOTTOM,
            textStyle: TextStyle(fontSize: 16, color: Colors.white),
            backgroundColor: Colors.black87,
          );
          if(Platform.isAndroid) {
            _goToTheLake(polylineCoordinates.last.latitude,
                polylineCoordinates.last.longitude);
            UpdateMarkers(polylineCoordinates.first);
            UpdateMarkers(polylineCoordinates.last);
          }
          if(Platform.isIOS){
            _goToTheLake(applePolylineCoordinates.last.latitude,
                applePolylineCoordinates.last.longitude);
            updateAppleMarkers(applePolylineCoordinates.first);
            updateAppleMarkers(applePolylineCoordinates.last);
          }
          setState(() {
            if(trackNumbers != 0 && travelDistance != 0.0 && travelTime != 0){
              trackNumbers = trackNumbers;
              travelDistance = travelDistance;
              travelTime = travelTime;
            }
          });
        }
      });
    });

    if(_isTrackingActive == true){
      print("isTracking is working");
      WidgetsBinding.instance.addPostFrameCallback((_) async => await _scheduleNotification(DateTime.now().hour, DateTime.now().minute,'Travel recording', "Travel dairy recording initiated for $currentDate"));
    }

    MotionTag.instance.setObserver((event) {
      print("recording event: $event");
      if(event == MotionTagEventType.transmissionSuccess){
        _addNotification("\nDate: $currentDate $event");
        print("Notifications: ${notifications}");
        WidgetsBinding.instance.addPostFrameCallback((_) async => await _scheduleNotification(DateTime.now().hour, DateTime.now().minute, 'Travel recording', "Travel dairy recording initiated for $currentDate"));
      }
    });

    if(showPrompt){
      print("Prompt is ready");
    }
    initiateChage();
    super.initState();
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
                  builder: (context) => SettingsPage(isTrackingActive: _isTrackingActive, isWifiOnlyDataTransferEnabled: _isWifiOnlyDataTransferEnabled, isBatteryOptimisationEnabled: _isBatteryOptimisationEnabled, isPowerSaveModeEnabled: _isPowerSaveModeEnabled, notificationCount: notificationCount,),
                ),
              );
            },
          )
        ],
      ),
    );
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

  Future<void> _scheduleNotification(int hours, int minute, String title, String body) async {
    await flutterLocalNotificationsPlugin.zonedSchedule(
        1,
        title,
        body,
        _setTime(hours, minute),
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

  tz.TZDateTime _nextInstanceOfTenAM() {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledDate =
    tz.TZDateTime(tz.local, DateTime.now().year, DateTime.now().month, DateTime.now().day, 10);
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }
    return scheduledDate;
  }

  tz.TZDateTime _setTime(int hour, int minutes ) {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledDate =
    tz.TZDateTime(tz.local, DateTime.now().year, DateTime.now().month, DateTime.now().day, hour,minutes, 0);
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }
    return scheduledDate;
  }

  tz.TZDateTime _nextInstanceOfTenAMLastYear() {
    return tz.TZDateTime(tz.local, now!.year - 1, now!.month, now!.day, 10);
  }

  tz.TZDateTime _nextInstanceOfSevenPM() {
    tz.TZDateTime scheduledDate = tz.TZDateTime(tz.local, DateTime.now().year, DateTime.now().month, DateTime.now().day, 19, 0, 0);
    if (scheduledDate.isBefore(DateTime.now())) {
      scheduledDate = scheduledDate.add(Duration(days: 1));
    }
    return scheduledDate;
  }

  tz.TZDateTime _nextInstanceOfMondayTenAM() {
    tz.TZDateTime scheduledDate = _nextInstanceOfTenAM();
    while (scheduledDate.weekday != DateTime.monday) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }
    return scheduledDate;
  }

  moveToDayTrip(String date){
    for(var tripInfo in calendarData){
      if(tripInfo['date'] == date){
        days.add(Days(date: date, storyline_count: tripInfo['storyline_count']));
      }
    }
    setState(() {
      isCalenderSelected = true;
    });
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

  initiateChage(){
    while(polylineCoordinates.isNotEmpty){
      print("\n\nPoly-lines not empty");
    }
  }

  List<Map<String, dynamic>>  possibleModes = [];

  bool allConfirmed = false;
  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          elevation: 1,
          toolbarHeight: 40.0,
          title: Center(child: Text("${appBarText.toString()}",style: TextStyle(fontSize: 18),)),
          leading: IconButton(
              onPressed: () {
                setState(() {
                  if (!isVisible) {
                    isVisible = true;
                    isFabVisible = false;
                    setState(() {
                      _sheetPosition = 0.30;
                    });
                  } else {
                    isVisible = false;
                    isFabVisible = true;
                    setState(() {
                      _sheetPosition = 0.50;
                    });
                  }
                });
              },
              icon: const Icon(Icons.calendar_month_outlined)),
          actions: [
            AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return Transform.scale(
                  scale: _animation.value,
                  child: Container(
                    width: 33,
                    height: 33,
                    child: Stack(
                      children: [
                        IconButton(
                            onPressed: (){},
                            icon: Icon(Icons.notifications_active, size: 20,)
                        ),
                        if (_showBadge)
                          Positioned(
                            right: 0,
                            top: 0,
                            child: Container(
                              padding: EdgeInsets.all(3),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.red,
                              ),
                              child: Center(
                                child: Text(
                                  '$notificationCount', // Update this value dynamically as needed
                                  style: TextStyle(color: Colors.white, fontSize: 10),
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                    ),
                  ),
                );
              },
            ),
            IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) =>   SettingsPage(isTrackingActive: _isTrackingActive, isWifiOnlyDataTransferEnabled: _isWifiOnlyDataTransferEnabled, isBatteryOptimisationEnabled: _isBatteryOptimisationEnabled, isPowerSaveModeEnabled: _isPowerSaveModeEnabled, notificationCount: notificationCount,)),
                  );
                },
                icon: const Icon(Icons.settings)),
            IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) =>   DashBoard(trackCount: trackCount, travel_time: travel_time, track_len: track_len, dashboardData: dashboardData, tripDates: tripDates)),
                  );
                },
                icon: const Icon(Icons.dashboard)),
            IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) =>  SurveyScreen()),
                  );
                },
                icon: const Icon(Icons.question_answer_outlined)),
          ],
        ),
        body: Stack(children: [_getPage(_page)]),
        // bottomNavigationBar: CurvedNavigationBar(
        //   key: _bottomNavigationKey,
        //   index: 0,
        //   height: 60.0,
        //   items: const <Widget>[
        //     Icon(Icons.calendar_today_outlined, size: 25),
        //     Icon(Icons.bar_chart_outlined, size: 25),
        //     Icon(Icons.wechat_outlined, size: 25),
        //     Icon(Icons.question_answer, size: 25),
        //     Icon(Icons.perm_identity_rounded, size: 25),
        //   ],
        //   color: Colors.white,
        //   buttonBackgroundColor: Colors.white,
        //   backgroundColor: Colors.black12,
        //   animationCurve: Curves.easeInOut,
        //   animationDuration: const Duration(milliseconds: 600),
        //   onTap: (index) {
        //     setState(() {
        //       _page = index;
        //     });
        //   },
        //   letIndexChange: (index) => true,
        // ),
      ),
    );
  }

  Widget _getPage(int index){
    // Implement your pages here
    switch (index) {
      case 0:
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
                  initialCameraPosition: androidCameraPosition,
                  markers: markers,
                  polylines: polylinesTrack.isNotEmpty ? polylinesTrack : {},
                  myLocationEnabled: true,
                  myLocationButtonEnabled: false,
                  mapType: MapType.normal,
                ):
                Platform.isIOS ? apple.AppleMap(onMapCreated: _onMapCreated,
                  initialCameraPosition: appleCameraPosition,
                  polylines: applePolylinesTrack.isNotEmpty ? applePolylinesTrack : {},
                  annotations: _appleMarkers,
                  myLocationEnabled: true,
                  myLocationButtonEnabled: true,
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
                          child: isCalenderSelected ? showDaysData(days) : showDaysData(tripDays),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
            SafeArea(
              child: Align(
                alignment: Alignment.topCenter,
                child: Visibility(
                  visible: isVisible ? true : false,
                  child: Container(
                    width: double.infinity,
                    height: MediaQuery.of(context).size.height / 1.80,
                    decoration: const BoxDecoration(color: Colors.white),
                    child: TableCalendar(
                      firstDay: DateTime.utc(2010, 10, 16),
                      lastDay: DateTime.utc(2030, 3, 14),
                      focusedDay: _focusedDay,
                      selectedDayPredicate: (day) {
                        return isSameDay(_selectedDay, day);
                      },
                      onDaySelected: (selectedDay, focusedDay) {
                        setState(() {
                          _selectedDay = selectedDay;
                          _focusedDay = focusedDay;
                          currentDate = DateFormat('yyyy-MM-dd').format(selectedDay);
                          DateTime date = DateFormat('yyyy-MM-dd').parse(currentDate);
                          DateTime now = DateTime(DateTime.now().year,DateTime.now().month, DateTime.now().day);
                          if(isVisible){
                            if(date == now){
                              appBarText = "Today";
                            }else if(date == now.subtract(Duration(days: 1))){
                            appBarText = "Yesterday";
                          }else{
                              print("date: $date");
                              appBarText = currentDate;
                            }
                            isVisible = false;
                            moveToDayTrip(currentDate);
                            setState(() {});
                          }else{

                            appBarText = "Home Screen";
                          }
                          setState(() {});
                        });
                      },
                      calendarFormat: _calendarFormat,
                      availableCalendarFormats: const {
                        CalendarFormat.month: 'Month',
                        CalendarFormat.week: 'Week',
                      },
                      onFormatChanged: (format) {
                        setState(() {
                          _calendarFormat = format;
                        });
                      },
                      onPageChanged: (focusedDay) {
                        _focusedDay = focusedDay;
                      },
                    ),
                  ),
                ),
              ),
            ),
            SafeArea(
              child: Visibility(
                visible: isFabVisible ? true : false,
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Container(
                      margin: EdgeInsets.only(right: 15),
                      width: 50,
                      height: 50,
                      decoration: const BoxDecoration(color: Colors.transparent),
                      child: FloatingActionButton(
                        onPressed: (){
                          if(currentTripID.isNotEmpty){
                            TripSaver().saveAllTrips(currentTripID);
                            allConfirmed = true;
                            setState(() {});
                          }
                        },
                        tooltip: "Confirm trips",
                        backgroundColor: Colors.blue,
                        child: Icon(Icons.check, color: Colors.white, size: 30,),
                      )
                  ),
                ),
              ),
            ),
          ],
        );
      case 1:
        return DashBoard(trackCount: trackCount, travel_time: travel_time, track_len: track_len, dashboardData: dashboardData, tripDates: tripDates,);
      case 2:
        return SizedBox.expand(
          child: Padding(
            padding: EdgeInsets.all(10),
            child: Column(
              children: [
                Status(),
                Divider(
                  color: Colors.black,
                ),
                Expanded(
                  child: SizedBox(
                    width: double.infinity,
                    child: Logs(),
                  ),
                ),
                Divider(
                  color: Colors.black,
                ),
                SizedBox(
                  width: double.infinity,
                  child: Controls(),
                ),
              ],
            ),
          ),
        );
      case 3:
        return const Survey();
      case 4:
        return const UserProfilePage();
      default:
        return Container();
    }
  }

  Widget showEvents(List<String> arr) {
    return Container(
        width: double.infinity,
        height: double.infinity,
        child:  GestureDetector(
          onTap: (){},
          child: const Text('Fetch data'),
        )
    );
  }

  Future<void> initializeMap() async {

    // final coordinates = travelDistance await fetchPolylinePoints();
    // generatePolyLineFromPoints(coordinates);
  }

  LatLng start = LatLng(0, 0);
  LatLng end = LatLng(0, 0);
  List<LatLng> waypoints = [];
  List<ConfirmTrips> currentTripID = [];
  List<AlternativeModeTrips> alt_mode_trips = [];

  Widget showDaysData(List<Days> days){
    int currentItem = 0;
    return Column(
      children: [
        Center(
          child: Padding(
            padding: const EdgeInsets.all(2.0),
            child: SizedBox(
              width: 50,
              child: Divider(thickness: 4),
            ),
          ),
        ),
        Expanded(
          child: days.isNotEmpty ? PageView.builder(
              controller: _pageController,
              physics: PageScrollPhysics(),
              itemCount: days.length,
              scrollDirection: Axis.horizontal,
              onPageChanged: (index){
                setState(() {
                  polylinesTrack = polylinesTrack;
                  applePolylinesTrack = applePolylinesTrack;
                  appBarText = days[index].date;
                });
                if(Platform.isAndroid) {
                  _goToTheLake(polylineCoordinates.first.latitude,
                      polylineCoordinates.first.longitude);
                }
                if(Platform.isIOS) {
                  _goToTheLake(applePolylineCoordinates.first.latitude,
                      applePolylineCoordinates.first.longitude);
                }
                setState(() {});
              },
              itemBuilder: (BuildContext context, int index){
                return Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(child: buildTrips(days[index].date)),
                  ],
                );
              }
          ) : Center( child: _motionTag.isTrackingActive() == true ? detectTracking() : Text("No calendar events available\nKindly allow about 24 hours to retrieve your trips")),
        ),
      ],
    );
  }

  void _onScroll() {
    double _previousOffset = 0;
    double currentOffset = _pageController.offset;

    if (currentOffset > _previousOffset) {
      setState(() {});
    } else if (currentOffset < _previousOffset) {
      setState(() {});
    }
  }

  int calculateDifferenceInMinutes(String startedAt, String finishedAt) {
    DateTime startedDateTime = DateTime.parse(startedAt);
    DateTime finishedDateTime = DateTime.parse(finishedAt);

    Duration difference = finishedDateTime.difference(startedDateTime);
    int differenceInMinutes = difference.inMinutes;

    return differenceInMinutes % 60;
  }

  LatLngBounds _calculateLatLngBounds(List<LatLng> positions) {
    double x0 = positions[0].latitude;
    double x1 = positions[0].latitude;
    double y0 = positions[0].longitude;
    double y1 = positions[0].longitude;

    for (LatLng pos in positions) {
      if (pos.latitude > x1) x1 = pos.latitude;
      if (pos.latitude < x0) x0 = pos.latitude;
      if (pos.longitude > y1) y1 = pos.longitude;
      if (pos.longitude < y0) y0 = pos.longitude;
    }

    return LatLngBounds(
      southwest: LatLng(x0, y0),
      northeast: LatLng(x1, y1),
    );
  }
  apple.LatLngBounds _appleCalculateLatLngBounds(List<apple.LatLng> positions) {
    double x0 = positions[0].latitude;
    double x1 = positions[0].latitude;
    double y0 = positions[0].longitude;
    double y1 = positions[0].longitude;

    for (apple.LatLng pos in positions) {
      if (pos.latitude > x1) x1 = pos.latitude;
      if (pos.latitude < x0) x0 = pos.latitude;
      if (pos.longitude > y1) y1 = pos.longitude;
      if (pos.longitude < y0) y0 = pos.longitude;
    }

    return apple.LatLngBounds(
      southwest: apple.LatLng(x0, y0),
      northeast: apple.LatLng(x1, y1),
    );
  }

  Future locateMapUpdates(double lat, double lng) async{
    try {
      if (Platform.isAndroid) {
        if (mapController != null && lat != null && lng != null) {
          LatLngBounds bounds = _calculateLatLngBounds(polylineCoordinates);
          GoogleMapController controller = await mapController.future;
          if (controller != null) {
            controller.animateCamera(
              CameraUpdate.newLatLngBounds(bounds, 100.0),
            );
            controller.animateCamera(
                CameraUpdate.newCameraPosition(
                    CameraPosition(target: LatLng(lat, lng),
                      zoom: 13.0,
                    )
                )
            );
          }
        }
      }
      if (Platform.isIOS) {
        if (appleMapController != null && lat != null && lng != null) {
          apple.LatLngBounds _appleBounds = _appleCalculateLatLngBounds(
              applePolylineCoordinates);

          apple.AppleMapController controller = await appleMapController.future;
          if (controller != null) {
            controller.animateCamera(
                apple.CameraUpdate.newLatLngBounds(_appleBounds, 5.0));
            controller.animateCamera(apple.CameraUpdate.newCameraPosition(
                apple.CameraPosition(target: apple.LatLng(lat, lng),
                  zoom: 13.5,
                )
            ));
          }
        }
      }
    }catch(e){print("Exception: $e");}
  }

  Set<Polyline> _createPolylines(var _data) {
    if(polylinesTrack.isNotEmpty ){
      polylinesTrack.clear();
    }
    if(markers.isNotEmpty){
      markers.clear();
    }

    widget.isLocationChanged = true;
    for (var item in _data) {
      var coordinates = item['attributes']['geometry']['coordinates'];
      if (item['type'] == 'Track' && coordinates.length > 1) {
        List<LatLng> points = coordinates.map<LatLng>((coord) => LatLng(coord[1], coord[0])).toList();
        polylinesTrack.add(Polyline(
          polylineId: PolylineId(item['id']),
          points: points,
          width: 5,
          color: Colors.blue,
        ));

        UpdateMarkers(points[0]);
        UpdateMarkers(points[points.length -1]);
        _goToTheLake(points[points.length -1].latitude, points[points.length -1].longitude);
      }
    }

    return polylinesTrack;
  }
  Set<apple.Polyline> _createApplePolylines(var _data) {
    if(applePolylinesTrack.isNotEmpty){
      applePolylinesTrack.clear();
    }
    if(_appleMarkers.isNotEmpty){
      _appleMarkers.clear();
    }

    widget.isLocationChanged = true;
    for (var item in _data) {
      var coordinates = item['attributes']['geometry']['coordinates'];
      if (item['type'] == 'Track' && coordinates.length > 1) {
        List<apple.LatLng> applePoints = coordinates.map<apple.LatLng>((coord) => apple.LatLng(coord[1], coord[0])).toList();
        applePolylinesTrack.add(apple.Polyline(
          polylineId: apple.PolylineId(item['id']),
          points: applePoints,
          width: 5,
          color: Colors.blue,
        ));


        updateAppleMarkers(applePoints[0]);
        updateAppleMarkers(applePoints[applePoints.length -1]);

        _goToTheLake(applePoints[applePoints.length -1].latitude, applePoints[applePoints.length -1].longitude);
      }
    }

    return applePolylinesTrack;
  }

  Future<void> _goToTheLake(double lat, double lng) async {
    try {
      if(lat != null && lng != null) {
        if (Platform.isAndroid) {
          final GoogleMapController controller = await mapController.future;
          // print('GoogleMapController initialized');
          await controller.animateCamera(
              CameraUpdate.newCameraPosition(CameraPosition(
                  bearing: 192.8334901395799,
                  target: LatLng(lat, lng),
                  tilt: 59.440717697143555,
                  zoom: 15.151926040649414)));
          // print('Camera animated to new position on Android');
        } else {
          final apple.AppleMapController controller = await appleMapController
              .future;
          // print('AppleMapController initialized');
          await controller.animateCamera(
              apple.CameraUpdate.newCameraPosition(apple.CameraPosition(
                  target: apple.LatLng(lat, lng),
                  zoom: 15.151926040649414)));
          // print('Camera animated to new position on iOS');
        }
      }else{
        return;
      }
    } catch (e) {
      print('Exception: $e');
    }
  }


  UpdateMarkers(LatLng points){
    markers.add(
      Marker(
          markerId: MarkerId(points.toString()),
          infoWindow: InfoWindow(title: "Points"),
          icon: googleMarker,
          position: points
      ),
    );

    isCalenderSelected = false;
  }

  updateAppleMarkers(apple.LatLng points){
    _appleMarkers.add(
      apple.Annotation(
          annotationId: apple.AnnotationId(points.toString()),
          infoWindow: apple.InfoWindow(title: "Points"),
          icon: appleMarker,
          position: points
      ),
    );

    isCalenderSelected = false;
  }

  getTrackIcon(String modeName, double size){
    if(modeName == 'Airplane'){
      color =  Color(0xFFe9b100);
      return Icon(Icons.airplanemode_on_outlined, color: color, size: size);
    }
    else if(modeName == 'Bicycle'){
      color =  Color(0xFF90a72f);
      return Icon(Icons.directions_bike_outlined, color: color, size: size);
    }
    else if(modeName == 'Bus'){
      color =  Color(0xFF5175ae);
      return Icon(Icons.directions_bus_outlined, color: color, size: size);
    }
    else if(modeName == 'Cable car'){
      color =  Color(0xFF2ea8c5);
      return Icon(Icons.subway_outlined, color: color, size: size);
    }
    else if(modeName == 'Car'){
      color =  Color(0xFFd57f0e);
      return Icon(Icons.directions_car_outlined, color: color, size: size);
    }
    else if(modeName == 'Ferry'){
      color =  Color(0xFF6e6cad);
      return Icon(Icons.directions_boat_outlined, color: color, size: size);
    }
    else if(modeName == 'Other'){
      color =  Color(0xFF35ad9c);
      return Icon(Icons.adjust_rounded, color:  color, size: size);
    }
    else if(modeName == 'Rapid transit railway'){
      color =  Color(0xFF35ad9c);
      return Icon(Icons.directions_railway_outlined, color: color, size: size);
    }
    else if(modeName == 'Regional train'){
      color =  Color(0xFFcb4288);
      return Icon(Icons.directions_railway_outlined, color: color, size: size);
    }
    else if(modeName == 'Subway'){
      color =  Color(0xFF3e8eb6);
      return Icon(Icons.directions_subway_outlined, color: color, size: size);
    }
    else if(modeName == 'Train'){
      color =  Color(0xFFd6393a);
      return Icon(Icons.directions_train, color: color, size: size);
    }
    else if(modeName == 'Tramway'){
      color =  Color(0xFF2ea8c5);
      return Icon(Icons.directions_train, color: color, size: size);
    }
    else if(modeName == 'Walking'){
      color =  Color(0xFFdebb00);
      return Icon(Icons.directions_walk, color: color, size: size);
    }
  }

  void addPolyLines(List<LatLng> polylineCoordinates, String id, Color color) {
    final polyline = Polyline(
      polylineId: PolylineId(id),
      color: color,
      points: polylineCoordinates,
      width: 5,
    );

    modePolylines.add(polyline);
  }

  void _showAlternativeMode(BuildContext context,List<Map<String, dynamic>> items, String mode, LatLng origin, LatLng dest) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Select Alternative Trip Mode', textAlign: TextAlign.center,style: TextStyle(fontSize: 16),),
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
                            width: MediaQuery.of(context).size.width/4,
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children:[
                                  Text("Initial travel details: ${items[0]}" ),
                                  Text('Cost: ${items[0]['cost']}', textAlign: TextAlign.start,),
                                  Text('Carbon: ${items[0]['carbon']}', textAlign: TextAlign.start,),
                                  // Text('Distance: ${_calculateDistance(origin, dest, mode)}', textAlign: TextAlign.start,),
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
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  TravelMode getTripMode(String mode){
    if(mode.trim().contains("driving")){
      return TravelMode.driving;
    }
    else if(mode.trim().contains("bicycle")){
      return TravelMode.bicycling;
    }
    else if(mode.trim().contains("transit") || mode.trim().contains("train") || mode.trim().contains("plane") || mode.trim().contains("transit")){
      return TravelMode.transit;
    }else{
      return TravelMode.transit;
    }
  }

  Future<String> _calculateDistance(LatLng _origin, LatLng _destination, String mode) async {
    final apiKey = 'AIzaSyBGIT7tPftOEf4knWZ_1HskdC3GABNec-U';
    String _distance = '';
    final url = Uri.parse(
        'https://maps.googleapis.com/maps/api/distancematrix/json?origins=${_origin.latitude},${_origin.longitude}&destinations=${_destination.latitude},${_destination.longitude}&mode=${getTripMode(mode)}&key=$apiKey');

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final rows = data['rows'];
      if (rows.isNotEmpty) {
        final elements = rows[0]['elements'];
        if (elements.isNotEmpty) {
          final distance = elements[0]['distance'];
          if (distance != null) {
            setState(() {
              _distance = distance['text'];
            });
          }
        }
      }
      return _distance;
    } else {
      throw Exception('Failed to load distance data');
    }
  }


  Widget buildTrips(String date){
    late double lng, lat;
    int? selectedIndex = -1;
    record = fetchSpecificTrack(date);

    return StreamBuilder<FetchResult>(
      stream: record,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        else if(snapshot.hasData && snapshot.data!.dayTrips.length < 1){
          return Center(child: Text("No data recorded, travel recording has been initiated."),);
        }
        else if (snapshot.hasError) {
          // isCalenderSelected = false;
          return Center(child: Text('Error: with fetching trips, ${snapshot.error}'));
        }
        else {
          travelDistance = 0.0;
          for(var trip in snapshot.data!.dayTrips){
            var coordinates = trip['attributes']['geometry']['coordinates'];

            if(trip['attributes']['geometry']['type'] == "Point"){
              lng = trip['attributes']['geometry']['coordinates'][0];
              lat = trip['attributes']['geometry']['coordinates'][1];
              start = LatLng(lat, lng);
              apple.LatLng origin = apple.LatLng(lat, lng);
              polylineCoordinates.add(start);
              applePolylineCoordinates.add(origin);
              newLocationWayPoints = [];
              if(trip['attributes']['detected_mode_name'] != "" || trip['attributes']['mode_key'] != ""){
                if(trip['attributes']['mode_key'].toString().contains('walk') || trip['attributes']['mode_key'].toString().contains('walk')){
                  polylineCoordinatesWalking.add(start);
                }else if(trip['attributes']['mode_key'].toString().contains('cycle') || trip['attributes']['mode_key'].toString().contains('cycle')){
                  polylineCoordinatesCycling.add(start);
                }
                else if(trip['attributes']['mode_key'].toString().contains('car') || trip['attributes']['mode_key'].toString().contains('car')){
                  polylineCoordinatesDriving.add(start);
                }else{
                  polylineCoordinatesTransit.add(start);
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

            currentTripID.add(ConfirmTrips(date: date, id: trip['id']));
            if(trip['type'] == 'Track'){
              var attributes = trip['attributes'];
              Map<int, int> frequencyMap = {};
              if((attributes['length'] <= 1500 && attributes['length'] >= 500) && (attributes['detected_mode_key'] == "bus" || attributes['detected_mode_key'] == "car")){
                possibleModes.add({'mode':'bicycle','cost':3.0, 'carbon': 0, });
                possibleModes.add({'mode':'bus','cost':3.5, 'carbon': 93, });

                List<LatLng> points = [];
                for(var coord in trip['attributes']['geometry']['coordinates']){
                  points.add(LatLng(coord[1],coord[0]));
                }
                alt_mode_trips.add(AlternativeModeTrips(id: trip['id'], date: date, length: attributes['length'], mode: attributes['detected_mode_key'], points: points));
              }
              tracks = calculateTracks();
              len = calculateDistance(trip['attributes']['length']);
            }
            times = calculateTime(calculateDifferenceInMinutes(trip['attributes']['started_at'], trip['attributes']['finished_at']));

          }
          if(Platform.isAndroid) {
            _createPolylines(snapshot.data!.dayTrips);
          }
          if(Platform.isIOS) {
            _createApplePolylines(snapshot.data!.dayTrips);
          }
          return Consumer<HomeScreen>(
            builder: (context, homeState, child) {
              return Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Icon(Icons.chevron_left, size: 30),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text('$trackNumbers Trips'),
                          Text(', ${travelTime ~/60} Hrs., ${travelTime % 60} min,'), Text(' ${(travelDistance/1000).toStringAsFixed(2)} km'),
                        ],
                      ),
                      Icon(Icons.chevron_right, size: 30,),
                    ],
                  ),
                  Flexible(
                    child: ListView.builder(
                      itemCount: snapshot.data!.dayTrips.length,
                      itemBuilder: (context, index) {
                        int _selectedIndex = -1;
                        int currentIndex = index;
                        return TripEvents(allConfirmed: allConfirmed,uuid: user_id, data: snapshot.data!.dayTrips, index: index, currentTripIDs: allConfirmed ? currentTripID : [],);
                      },
                    ),
                  ),
                ],
              );
            },
          );
        }
      },
    );
  }

  Future<List<LatLng>> fetchPolylinePoints(var data) async {
    LatLng start; LatLng dest; List<PolylineWayPoint> waypoints = []; TravelMode mode;
    final polylinePoints = PolylinePoints();

    for(var trip in data){
      if(trip['type'] == "Track"){
        var coordinates = trip['attributes']['geometry']['coordinates'];
        if(trip['attributes']['geometry']['type'] == "Point"){
          double lng = trip['attributes']['geometry']['coordinates'][0];
          double lat = trip['attributes']['geometry']['coordinates'][1];
          start = LatLng(lat, lng);
          apple.LatLng origin = apple.LatLng(lat, lng);
          polylineCoordinates.add(start);
          applePolylineCoordinates.add(origin);
          newLocationWayPoints = [];

        }else{
          for(var coord in trip['attributes']['geometry']['coordinates']){
            polylineCoordinates.add(LatLng(coord[1],coord[0]));
            applePolylineCoordinates.add(apple.LatLng(coord[1],coord[0]));
            newLocationWayPoints.add(PolylineWayPoint(location: "${coord[1].toString()},${coord[0].toString()}"));
          }
          newLocationWayPoints.removeAt(0);
          newLocationWayPoints.removeAt(newLocationWayPoints.length - 1);
        }
      }
    }

    for(int i = 0; i < 22; i++){
      waypoints.add(newLocationWayPoints[i]);
    }


    final result = await polylinePoints.getRouteBetweenCoordinates(
        googleApiKey: googleAPiKey,
        request: PolylineRequest(
          origin: PointLatLng(polylineCoordinates.first.latitude, polylineCoordinates.first.longitude),
          destination: PointLatLng(polylineCoordinates.last.latitude, polylineCoordinates.last.longitude),
          mode: TravelMode.driving,
          wayPoints: waypoints,
        ),
    );

    if (result.points.isNotEmpty) {
      return result.points
          .map((point) => LatLng(point.latitude, point.longitude))
          .toList();
    } else {
      debugPrint(result.errorMessage);
      return [];
    }
  }

  Future<void> generatePolyLineFromPoints(
      List<LatLng> polylineCoordinates) async {
    const id = PolylineId('polyline');

    final polyline = Polyline(
      polylineId: id,
      color: Colors.blueAccent,
      points: polylineCoordinates,
      width: 5,
    );

    setState(() => polylines[id] = polyline);
  }

}