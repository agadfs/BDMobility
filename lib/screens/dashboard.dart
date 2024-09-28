import 'package:data_table_2/data_table_2.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:mobi_div/screens/traveldiary.dart';
import 'package:shared_preferences/shared_preferences.dart';
//import 'package:syncfusion_flutter_charts/charts.dart';
import 'dart:math' as math;

import 'package:syncfusion_flutter_charts/charts.dart';


class DashBoard extends StatefulWidget {
  double track_len = 0.0;
  int travel_time =0, trackCount = 0;
  var dashboardData;
  final List tripDates;

  DashBoard({Key? key, required this.trackCount, required this.travel_time, required this.track_len, required this.dashboardData, required this.tripDates}) : super(key: key);

  @override
  State<DashBoard> createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard> {
  final shadowColor =  Colors.white;
  late SelectionBehavior _selectionBehavior;
  late TooltipBehavior _tooltipBehavior;
  String authToken = "";
  int track_len = 0;
  List<ChartData> chartData = [];
  int touchedIndex = 0;
  int touchedGroupIndex = -1;
  int totalModes = 0;
  String user_id = "";

  List<dynamic> trackData = [];


  List<ChartData> getTripModes(var tripData) {
    double bikeCount = 0.0, carCount = 0.0, busCount = 0.0, trainCount = 0.0, planeCount = 0.0, walkCount = 0.0, subwayCount = 0.0;
    List<ChartData> chartData = [];

    try {
      if (tripData != null) {
        for (var data in tripData) {
          if(data['attributes']['user_id'] == user_id)
          if (data['attributes']['track_mode'] != null) {
            switch (data['attributes']['track_mode']) {
              case 'bicycle':
                bikeCount++;
                break;
              case 'bus':
                busCount++;
                break;
              case 'walk':
                walkCount++;
                break;
              case 'car':
                carCount++;
                break;
              case 'subway':
                subwayCount++;
                break;
              case 'train':
                trainCount++;
                break;
              default:
                break;
            }
          }
        }
        if(bikeCount > 0.0){
          chartData.add(ChartData("bicycle", bikeCount));
        }
        if(carCount > 0.0){
          chartData.add(ChartData("car", carCount));
        }
        if(busCount > 0.0){
          chartData.add(ChartData("bus", busCount));
        }
        if(trainCount > 0.0){
          chartData.add(ChartData("train", trainCount));
        }
        if(subwayCount > 0.0){
          chartData.add(ChartData("subway", subwayCount));
        }
        if(walkCount > 0.0){
          chartData.add(ChartData("walk", walkCount));
        }

      }
    } catch (e) {
      print("Exception $e");
    }

    return chartData;
  }

  List<DataRow> tripDetails(var data) {
    List<DataRow> rows = [];
    try {
      if (data != null && data is List) {
        rows = data.map<DataRow>((item) {
          if (item['type'] == 'Track') {
            final attributes = item['attributes'] ?? {};
            return DataRow(cells: [
              DataCell(Text('${track_len += 1}')),
              DataCell(Text('${DateFormat('yyyy-MM-dd').format(DateTime.parse(attributes['started_at']))}')),
              DataCell(Text(
                '${(attributes['track_length_in_meters'] / 1000).toStringAsFixed(2)} km',
              )),
              DataCell(Text(
                '${calculateDifferenceInMinutes(attributes['started_at'], attributes['finished_at']) ~/60} Hours, ${calculateDifferenceInMinutes(attributes['started_at'], attributes['finished_at']) % 60} mins',
              )),
              DataCell(Text(
                '${attributes['track_mode']}')),
            ]);
          } else {
            return DataRow(cells: [
              DataCell(Text('')),
              DataCell(Text('')),
              DataCell(Text('')),
              DataCell(Text('')),
              DataCell(Text('Invalid type')),
            ]);
          }
        }).toList();
      }
    } catch (e) {
      print('Error: $e');
    }
    return rows;
  }

  List<PieChartSectionData> showingSections() {
    return List.generate(4, (i) {
      final isTouched = i == touchedIndex;
      final fontSize = isTouched ? 20.0 : 16.0;
      final radius = isTouched ? 110.0 : 100.0;
      final widgetSize = isTouched ? 55.0 : 40.0;
      const shadows = [Shadow(color: Colors.black, blurRadius: 2)];

      switch (i) {
        case 0:
          return PieChartSectionData(
            color: Colors.blue,
            value: 40,
            title: '40%',
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: const Color(0xffffffff),
              shadows: shadows,
            ),
            badgeWidget: _Badge(
              Icons.directions_bus,
              size: widgetSize,
              borderColor: Colors.black,
            ),
            badgePositionPercentageOffset: .98,
          );
        case 1:
          return PieChartSectionData(
            color: Colors.yellow,
            value: 30,
            title: '30%',
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: const Color(0xffffffff),
              shadows: shadows,
            ),
            badgeWidget: _Badge(
              Icons.directions_car,
              size: widgetSize,
              borderColor: Colors.black,
            ),
            badgePositionPercentageOffset: .98,
          );
        case 2:
          return PieChartSectionData(
            color: Colors.purple,
            value: 16,
            title: '16%',
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: const Color(0xffffffff),
              shadows: shadows,
            ),
            badgeWidget: _Badge(
              Icons.directions_transit,
              size: widgetSize,
              borderColor: Colors.black,
            ),
            badgePositionPercentageOffset: .98,
          );
        case 3:
          return PieChartSectionData(
            color: Colors.green,
            value: 15,
            title: '15%',
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: const Color(0xffffffff),
              shadows: shadows,
            ),
            badgeWidget: _Badge(
              Icons.directions_bike,
              size: widgetSize,
              borderColor: Colors.black,
            ),
            badgePositionPercentageOffset: .98,
          );
        default:
          throw Exception('Oh no');
      }
    });
  }

  int calculateDifferenceInMinutes(String startedAt, String finishedAt) {
    DateTime startedDateTime = DateTime.parse(startedAt);
    DateTime finishedDateTime = DateTime.parse(finishedAt);

    Duration difference = finishedDateTime.difference(startedDateTime);
    int differenceInMinutes = difference.inMinutes;

    return differenceInMinutes % 60;
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
    getSavedDetails().then((onValue){
      if(onValue != ""){
        setState(() {
          user_id = onValue;
        });
      }
    });

    setState(() {
      track_len = 0;
    });
    _selectionBehavior = SelectionBehavior(enable: true);
    _tooltipBehavior = TooltipBehavior(enable: true);

    int count =0;
    for(var data in widget.dashboardData){
      if(data['type'] == 'Track'){
        trackData.add(data);
      }
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Title( color: Colors.black , child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.dashboard_outlined),
            Text("Dashboard")
          ],
        ),
        ),
      ),
      body: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                color: Colors.white
            ),
            child: Padding(
              padding: const EdgeInsets.only(top: 24.0, left: 5.0, right: 5.0, bottom: 10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      GestureDetector(onTap: () {}, child: Text("Day", style: TextStyle(fontSize: 16),)),
                      GestureDetector(onTap: () {}, child: Text("Week", style: TextStyle(fontSize: 16),)),
                      GestureDetector(onTap: () {}, child: Text("Month", style: TextStyle(fontSize: 16),)),
                    ],
                  ),
                  const Divider(),
                  SizedBox(
                    height: 22,
                    width: double.infinity,
                    child: ListView.builder(
                      itemCount: widget.tripDates.length,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (BuildContext context, int index){
                        return Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: Row(
                            children: [
                              Text(widget.tripDates[index]),
                              VerticalDivider(
                                thickness: 1,
                                color: Colors.black,
                                width: 20,
                                indent: 10,
                                endIndent: 10,
                              )
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                  const Divider(),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 4),
                    child: Text(
                      "Summary",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(
                    height: 50,
                    width: double.infinity,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          alignment: Alignment.center,
                          height: 48,
                          width: MediaQuery.of(context).size.width / 5,
                          child: Column(
                            children: [
                              Text('${widget.trackCount}', style: TextStyle(fontSize: 16),)
                              , Text("Tracks", style: TextStyle(fontSize: 16),)
                            ],
                          ),
                        ),
                        const VerticalDivider(
                          thickness: 1,
                          color: Colors.black,
                          width: 20,
                          indent: 10,
                          endIndent: 10,
                        ),
                        Container(
                          alignment: Alignment.center,
                          height: 48,
                          width: MediaQuery.of(context).size.width / 5,
                          child: Column(
                              children: [
                                Text('${widget.travel_time ~/60} Hrs., ${widget.travel_time % 60} min', textAlign: TextAlign.center,style: TextStyle(fontSize: 16),),
                              ]
                          ),
                        ),
                        const VerticalDivider(
                          thickness: 1,
                          color: Colors.black,
                          width: 20,
                          indent: 10,
                          endIndent: 10,
                        ),
                        Container(
                          alignment: Alignment.center,
                          height: 48,
                          width: MediaQuery.of(context).size.width / 5,
                          child: Column(
                            children: [
                              Text('${widget.track_len}', style: TextStyle(fontSize: 16),),
                              Text("km", style: TextStyle(fontSize: 16),)
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 4),
                    child: Text(
                      "Charts",
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                  Center(
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width/1.2,
                              height: MediaQuery.of(context).size.width/1.2,
                              // child: AspectRatio(
                              //   aspectRatio: 1.3,
                              //   child: AspectRatio(
                              //     aspectRatio: 1,
                              //     child: PieChart(
                              //       PieChartData(
                              //         pieTouchData: PieTouchData(
                              //           touchCallback: (FlTouchEvent event, pieTouchResponse) {
                              //             setState(() {
                              //               if (!event.isInterestedForInteractions ||
                              //                   pieTouchResponse == null ||
                              //                   pieTouchResponse.touchedSection == null) {
                              //                 touchedIndex = -1;
                              //                 return;
                              //               }
                              //               touchedIndex =
                              //                   pieTouchResponse.touchedSection!.touchedSectionIndex;
                              //             });
                              //           },
                              //         ),
                              //         borderData: FlBorderData(
                              //           show: false,
                              //         ),
                              //         sectionsSpace: 0,
                              //         centerSpaceRadius: 0,
                              //         sections: showingSections(),
                              //       ),
                              //     ),
                              //   ),
                              // )
                              child: SfCircularChart(
                                  legend: Legend(isVisible: true, position: LegendPosition.left),
                                  tooltipBehavior: _tooltipBehavior,
                                  series: <CircularSeries>[
                                    // Render pie chart
                                    DoughnutSeries<ChartData, String>(
                                        dataSource: getTripModes(widget.dashboardData),
                                        xValueMapper: (ChartData data, _) => data.x,
                                        yValueMapper: (ChartData data, _) => data.y,
                                        explode: true,
                                        selectionBehavior: _selectionBehavior,
                                        // Explode all the segments
                                        explodeAll: true,
                                        dataLabelSettings: DataLabelSettings(
                                          // Renders the data label
                                            isVisible: true)
                                    )
                                  ]
                              )
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: DataTable2(
                          columnSpacing: 12,
                          horizontalMargin: 12,
                          minWidth: 600,
                          columns: [
                            DataColumn2(
                                label: Text('Track ID'),
                                size: ColumnSize.S
                            ),
                            DataColumn(
                              label: Text('Date'),
                            ),
                            DataColumn(
                              label: Text('Distance'),
                            ),
                            DataColumn(
                              label: Text('Time'),
                            ),
                            DataColumn(
                              label: Text('Mode'),
                            ),
                          ],
                          rows: tripDetails(trackData)
                      ),
                    ),
                  )
                  // Expanded(
                  //   child: Container(
                  //     width: double.infinity,
                  //     height: 280,
                  //     child: DataTable(
                  //       columns: [
                  //         DataColumn(label: Text('Type', style: TextStyle(fontSize: 10),)),
                  //         DataColumn(label: Text('Started At', style: TextStyle(fontSize: 10),)),
                  //         //DataColumn(label: Text('Finished At', style: TextStyle(fontSize: 12),)),
                  //         // DataColumn(label: Text('Details', style: TextStyle(fontSize: 12),)),
                  //       ],
                  //       rows: tripDetails(widget.dashboardData)!
                  //     ),
                  //   ),
                  // ),
                ],
              ),
            ),
          ),
        ),
    );
  }
}

class _Badge extends StatelessWidget {
  const _Badge(
      this.svgAsset, {
        required this.size,
        required this.borderColor,
      });
  final IconData svgAsset;
  final double size;
  final Color borderColor;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: PieChart.defaultDuration,
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        border: Border.all(
          color: borderColor,
          width: 2,
        ),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.black.withOpacity(.5),
            offset: const Offset(3, 3),
            blurRadius: 3,
          ),
        ],
      ),
      padding: EdgeInsets.all(size * .15),
      child: Center(
        child: Icon(
          svgAsset,
        ),
      ),
    );
  }
}

class ChartData {
  ChartData(this.x, this.y, [this.color]);
  final String x;
  final double y;
  final Color? color;
}

class _IconWidget extends ImplicitlyAnimatedWidget {
  const _IconWidget({
    required this.color,
    required this.isSelected,
  }) : super(duration: const Duration(milliseconds: 300));
  final Color color;
  final bool isSelected;

  @override
  ImplicitlyAnimatedWidgetState<ImplicitlyAnimatedWidget> createState() =>
      _IconWidgetState();
}

class _IconWidgetState extends AnimatedWidgetBaseState<_IconWidget> {
  Tween<double>? _rotationTween;

  @override
  Widget build(BuildContext context) {
    final rotation = math.pi * 4 * _rotationTween!.evaluate(animation);
    final scale = 1 + _rotationTween!.evaluate(animation) * 0.5;
    return Transform(
      transform: Matrix4.rotationZ(rotation).scaled(scale, scale),
      origin: const Offset(14, 14),
      child: Icon(
        widget.isSelected ? Icons.face_retouching_natural : Icons.face,
        color: widget.color,
        size: 28,
      ),
    );
  }

  @override
  void forEachTween(TweenVisitor<dynamic> visitor) {
    _rotationTween = visitor(
      _rotationTween,
      widget.isSelected ? 1.0 : 0.0,
      (dynamic value) => Tween<double>(
        begin: value as double,
        end: widget.isSelected ? 1.0 : 0.0,
      ),
    ) as Tween<double>?;
  }
}

enum FilterType { day, week, month }

class SummaryTab extends StatelessWidget {
  final List<TrackData> tracks;
  final FilterType filterType;

  SummaryTab(this.tracks, this.filterType);

  List<TrackData> getFilteredData() {
    DateTime now = DateTime.now();
    DateTime start;

    switch (filterType) {
      case FilterType.day:
        start = now.subtract(Duration(days: 1));
        break;
      case FilterType.week:
        start = now.subtract(Duration(days: 7));
        break;
      case FilterType.month:
        start = now.subtract(Duration(days: 30));
        break;
    }

    return tracks.where((track) => track.attributes.startedAt.isAfter(start)).toList();
  }

  @override
  Widget build(BuildContext context) {
    List<TrackData> filteredData = getFilteredData();

    double totalDistance = filteredData.fold(0, (sum, track) {
     return (sum + track.attributes.trackLengthInMeters!) / 1000;
    });

    Duration totalTime = filteredData.fold(Duration(), (sum, track) {
      return sum + track.attributes.finishedAt.difference(track.attributes.startedAt);
    });

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Total Distance: ${totalDistance.toStringAsFixed(2)} km'),
          Text('Total Time: ${totalTime.inHours} hours, ${totalTime.inMinutes.remainder(60)} minutes'),
        ],
      ),
    );
  }
}

class TrackData {
  final String type;
  final String id;
  final Attributes attributes;

  TrackData({required this.type, required this.id, required this.attributes});

  factory TrackData.fromJson(Map<String, dynamic> json) {
    return TrackData(
      type: json['type'],
      id: json['id'],
      attributes: Attributes.fromJson(json['attributes']),
    );
  }
}

class Attributes {
  final String userId;
  final DateTime createdAt;
  final DateTime startedAt;
  final String startedAtTimezone;
  final DateTime finishedAt;
  final String finishedAtTimezone;
  final Geometry geometry;
  final String? trackMode;
  final int? trackLengthInMeters;
  final String? stayPurpose;

  Attributes({
    required this.userId,
    required this.createdAt,
    required this.startedAt,
    required this.startedAtTimezone,
    required this.finishedAt,
    required this.finishedAtTimezone,
    required this.geometry,
    this.trackMode,
    this.trackLengthInMeters,
    this.stayPurpose,
  });

  factory Attributes.fromJson(Map<String, dynamic> json) {
    return Attributes(
      userId: json['user_id'],
      createdAt: DateTime.parse(json['created_at']),
      startedAt: DateTime.parse(json['started_at']),
      startedAtTimezone: json['started_at_timezone'],
      finishedAt: DateTime.parse(json['finished_at']),
      finishedAtTimezone: json['finished_at_timezone'],
      geometry: Geometry.fromJson(json['geometry']),
      trackMode: json['track_mode'],
      trackLengthInMeters: json['track_length_in_meters'],
      stayPurpose: json['stay_purpose'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'created_at': createdAt.toIso8601String(),
      'started_at': startedAt.toIso8601String(),
      'started_at_timezone': startedAtTimezone,
      'finished_at': finishedAt.toIso8601String(),
      'finished_at_timezone': finishedAtTimezone,
      'geometry': geometry.toJson(),
      'track_mode': trackMode,
      'track_length_in_meters': trackLengthInMeters,
      'stay_purpose': stayPurpose,
    };
  }
}

class Geometry {
  final String type;
  final dynamic coordinates;

  Geometry({required this.type, required this.coordinates});

  factory Geometry.fromJson(Map<String, dynamic> json) {
    if (json['type'] == 'Point') {
      return Geometry(
        type: json['type'],
        coordinates: List<double>.from(json['coordinates'].map((coord) => coord.toDouble())),
      );
    } else if (json['type'] == 'LineString') {
      return Geometry(
        type: json['type'],
        coordinates: List<List<double>>.from(json['coordinates'].map(
                (item) => List<double>.from(item.map((coord) => coord.toDouble())))),
      );
    } else {
      throw Exception('Unknown geometry type');
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'coordinates': coordinates,
    };
  }
}

class DataResponse {
  final List<TrackData> data;

  DataResponse({required this.data});

  factory DataResponse.fromJson(Map<String, dynamic> json) {
    return DataResponse(
      data: List<TrackData>.from(json['data'].map((item) => TrackData.fromJson(item))),
    );
  }
}