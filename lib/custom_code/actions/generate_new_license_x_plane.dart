// Automatic FlutterFlow imports
import '/actions/actions.dart' as action_blocks;
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom actions
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;

Future<String> generateNewLicenseXPlane(String? duration) async {
  const String token =
      'patZuFHBTfOuzMmP7.b473d75321c56e35e5f7c0d76fcc330098903b08fabc3860400953058a89e39d';
  const String baseId = 'appmz3issohHsNLRM';
  const String tableName = 'Table 1';

  const chars = 'ABCDEFGHJKLMNPQRSTUVWXYZ23456789';
  String newCode =
      List.generate(8, (index) => chars[Random().nextInt(chars.length)]).join();

  final url = Uri.parse(
      'https://api.airtable.com/v0/$baseId/${Uri.encodeComponent(tableName)}');

  try {
    final response = await http.post(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'fields': {
          'LicenseKey': newCode,
          'IsUsed': false,
          // هنا تم حل المشكلة: لو القيمة فاضية مش هيضرب إيرور
          'Duration': (duration == null || duration.trim().isEmpty)
              ? '1_month'
              : duration.trim(),
        }
      }),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return newCode;
    } else {
      return "Error: ${response.statusCode}";
    }
  } catch (e) {
    return "Network Error";
  }
}
