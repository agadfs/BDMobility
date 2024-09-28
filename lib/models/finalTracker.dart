import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:getwidget/components/toast/gf_toast.dart';
import 'package:getwidget/position/gf_toast_position.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'jwt_generator.dart';

class Attributes {
  final String startedAt;
  final String finishedAt;
  final String? purposeKey;
  final String? purposeName;
  final String? detectedPurposeKey;
  final String? detectedPurposeName;
  final String ?detectedModeName;
  final String? detectedModeKey;
  final bool misdetectedCompletely;
  final Geometry geometry;

  Attributes({
    required this.startedAt,
    required this.finishedAt,
    this.purposeKey,
    this.purposeName, 
    this.detectedPurposeKey,
    this.detectedPurposeName,
    this.detectedModeKey,
    this.detectedModeName,
    required this.misdetectedCompletely,
    required this.geometry,
  });

  factory Attributes.fromJson(Map<String, dynamic> json) {
    return Attributes(
      startedAt: json['started_at'],
      finishedAt: json['finished_at'],
      purposeKey: json['purpose_key'],
      purposeName: json['purpose_name'],
      detectedPurposeKey: json['detected_purpose_key'],
      detectedPurposeName: json['detected_purpose_name'],
      detectedModeKey: json['detected_mode_key'],
      detectedModeName: json['detected_mode_name'],
      misdetectedCompletely: json['misdetected_completely'],
      geometry: Geometry.fromJson(json['geometry']),
    );
  }
}

class Attrib {
  final List<Days> days;

  Attrib({
    required this.days,
  });


  factory Attrib.fromJson(Map<String, dynamic> json) {
    var dayList = json['days'] as List;
    List<Days> calendarDays = dayList.map((day) => Days.fromJson(day)).toList();
    return Attrib(days: calendarDays);
  }
}

class Days {
  final String date;
  final int storyline_count;

  Days({
    required this.date,required this.storyline_count
  });

  factory Days.fromJson(Map<String, dynamic> json) {
    return Days(
      date: json['date'],
      storyline_count: json['storyline_count'],
    );
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
        coordinates: List<double>.from(
            json['coordinates'].map((coord) => coord.toDouble())),
      );
    } else if (json['type'] == 'LineString') {
      return Geometry(
        type: json['type'],
        coordinates: List<List<double>>.from(json['coordinates'].map(
                (item) =>
            List<double>.from(item.map((coord) => coord.toDouble())))),
      );
    } else {
      throw Exception('Unknown geometry type');
    }
  }

}

class StoryLine {
  final String id;
  final String type;
  final Attributes attributes;

  StoryLine({required this.id, required this.type, required this.attributes});

  factory StoryLine.fromJson(Map<String, dynamic> json) {
    return StoryLine(
      id: json['id'],
      type: json['type'],
      attributes: Attributes.fromJson(json['attributes']),
    );
  }
}

class TripPurpose {
  final String id;
  final String type;
  final Map<String, dynamic> attributes;

  TripPurpose({required this.id, required this.type, required this.attributes});

  factory TripPurpose.fromJson(Map<String, dynamic> json) {
    return TripPurpose(
      id: json['id'],
      type: json['type'],
      attributes: json['attributes'],
    );
  }
}

class Calendars {
  final String id;
  final String type;
  final Attrib attributes;

  Calendars({required this.id, required this.type, required this.attributes});

  factory Calendars.fromJson(Map<String, dynamic> json) {
    return Calendars(
      id: json['id'],
      type: json['type'],
      attributes: Attrib.fromJson(json['attributes']),
    );
  }

}

class ConfirmTrips{
  final String id;
  final String date;

  ConfirmTrips({required this.date, required this.id});

  factory ConfirmTrips.fromJson(Map<String, dynamic> json) {
    return ConfirmTrips(
      date: json['date'],
      id: json['id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'date': date,
    };
  }
}

class AlternativeModeTrips{
  final String id;
  final String date;
  final int length;
  final String mode;
  final List<LatLng> points;

  AlternativeModeTrips({required this.id, required this.date, required this.length, required this.mode, required this.points });

  factory AlternativeModeTrips.fromJson(Map<String, dynamic> json) {
    return AlternativeModeTrips(
      id: json['id'],
      date: json['date'],
      length: json['length'],
      mode: json['mode'],
      points: json['points'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'date': date,
      'length': length,
      'mode': mode,
      'points': points
    };
  }
}

class TripSaver{

  Future<void> saveTrips(ConfirmTrips trips) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('_AllConfirmedTrips', jsonEncode(trips.toJson()));
  }

  Future<void> saveAllTrips(List<ConfirmTrips> trips) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String jsonString = jsonEncode(trips.map((trip) => trip.toJson()).toList());
    await prefs.setString('_AllConfirmedTrips', jsonString);
  }

  Future<List<ConfirmTrips>> getAllTrips() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? jsonString = prefs.getString('_AllConfirmedTrips');
    if (jsonString != null) {
      final List<dynamic> jsonList = jsonDecode(jsonString);
      return jsonList.map((json) => ConfirmTrips.fromJson(json)).toList();
    }
    return [];
  }


  Future<ConfirmTrips?> getTrips()async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? tripDetails = prefs.getString('_AllConfirmedTrips');
    if (tripDetails != null) {
      return ConfirmTrips.fromJson(jsonDecode(tripDetails));
    }
    return null;
  }

}
