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
import 'package:http/http.dart' as http;

Future<String?> checkMSFSLicensePlan(String? licenseKey) async {
  if (licenseKey == null || licenseKey.trim().isEmpty) {
    return "INVALID_KEY";
  }

  const String token =
      'patZuFHBTfOuzMmP7.b473d75321c56e35e5f7c0d76fcc330098903b08fabc3860400953058a89e39d';
  const String baseId = 'appmz3issohHsNLRM';
  const String tableId = 'tblse0E5FhASxuhmn';

  final String cleanKey = licenseKey.trim();
  final String filterFormula = "NOT({LicenseKey} = '')";
  final Uri url = Uri.parse(
      'https://api.airtable.com/v0/$baseId/$tableId?filterByFormula=${Uri.encodeComponent(filterFormula)}');

  try {
    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode >= 200 && response.statusCode < 300) {
      final data = json.decode(response.body);
      final List records = data['records'] ?? [];

      for (var record in records) {
        final fields = record['fields'] ?? {};
        if (fields['LicenseKey']?.toString().trim() == cleanKey) {
          final String rawDuration =
              fields['Duration']?.toString().trim() ?? '';

          // تحويل الكود لنص إنجليزي نظيف للعرض والمقارنة
          if (rawDuration == '12_months' || rawDuration == 'yearly') {
            return 'Yearly';
          } else if (rawDuration == 'lifetime') {
            return 'Lifetime';
          } else {
            return 'Monthly';
          }
        }
      }
      return "NOT_FOUND";
    } else {
      return "Error_${response.statusCode}";
    }
  } catch (e) {
    return "Error: $e";
  }
}
