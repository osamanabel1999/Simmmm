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

Future<String> generateNewLicenseMSFSforBothSIM(
    String? duration, String? appUserId) async {
  const String token =
      'patZuFHBTfOuzMmP7.b473d75321c56e35e5f7c0d76fcc330098903b08fabc3860400953058a89e39d';
  const String baseId = 'appmz3issohHsNLRM';
  const String tableId = 'tblse0E5FhASxuhmn';

  const chars = 'ABCDEFGHJKLMNPQRSTUVWXYZ23456789';
  String newCode =
      List.generate(8, (index) => chars[Random().nextInt(chars.length)]).join();

  const String simType = 'BothSIM';

  final String currentDuration = (duration == null || duration.trim().isEmpty)
      ? '1_month'
      : duration.trim().toLowerCase();

  final String cleanUserId = (appUserId == null) ? '' : appUserId.trim();

  // تحديد نوع الباقة باحترافية بناءً على الكلمة الموجودة في عمود Duration
  String cleanPlanType = 'Monthly'; // القيمة الافتراضية

  if (currentDuration.contains('year')) {
    cleanPlanType = 'Yearly';
  } else if (currentDuration.contains('life')) {
    cleanPlanType = 'Lifetime';
  } else if (currentDuration.contains('month')) {
    cleanPlanType = 'Monthly';
  }

  final url = Uri.parse('https://api.airtable.com/v0/$baseId/$tableId');

  try {
    final response = await http.post(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'typecast': true,
        'fields': {
          'LicenseKey': newCode,
          'Duration': currentDuration,
          'PlanType': cleanPlanType,
          'SimType': simType,
          'AppUserID': cleanUserId,
        }
      }),
    );

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return newCode;
    } else {
      return "Status ${response.statusCode}: ${response.body}";
    }
  } catch (e) {
    return "Error: $e";
  }
}
