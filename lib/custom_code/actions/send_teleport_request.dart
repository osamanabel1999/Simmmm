// Automatic FlutterFlow imports
import '/actions/actions.dart' as action_blocks;
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom actions
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'package:http/http.dart' as http;
import 'dart:convert';

Future sendTeleportRequest(
  String ipAddress,
  double lat,
  double lon,
  double? altitudeFt,
  double? headingDeg,
  double? speedKnots,
) async {
  // تجهيز رابط السيرفر (مثال: http://192.168.1.5:8080/teleport)
  final url = Uri.parse('http://$ipAddress:8080/teleport');

  // تجهيز الـ JSON Body بالبيانات المبعوثة من الخريطة
  final Map<String, dynamic> bodyData = {
    'lat': lat,
    'lon': lon,
    if (altitudeFt != null) 'altitude_ft': altitudeFt,
    if (headingDeg != null) 'heading_deg': headingDeg,
    if (speedKnots != null) 'speed_knots': speedKnots,
  };

  try {
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(bodyData),
    );

    if (response.statusCode == 200) {
      print("✈️ Teleport Success: ${response.body}");
    } else {
      print("❌ Server Error: ${response.statusCode} - ${response.body}");
    }
  } catch (e) {
    print("❌ Network Error: $e");
  }
}
