// Automatic FlutterFlow imports
import '/actions/actions.dart' as action_blocks;
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom actions
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import '/custom_code/actions/index.dart';
import '/flutter_flow/custom_functions.dart';

import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:device_info_plus/device_info_plus.dart';

Future<String> activateLicense(String licenseCode) async {
  // 1. نفس البيانات اللي نجحت معاك في التوليد
  const String token =
      'patZuFHBTfOuzMmP7.b473d75321c56e35e5f7c0d76fcc330098903b08fabc3860400953058a89e39d';
  const String baseId = 'appmz3issohHsNLRM';
  const String tableName = 'Table 1';

  // 2. تحديد هوية الجهاز (Device ID)
  String deviceId = '';
  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  try {
    if (Platform.isAndroid) {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      deviceId = androidInfo.id;
    } else if (Platform.isIOS) {
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      deviceId = iosInfo.identifierForVendor ?? 'unknown_ios';
    }
  } catch (e) {
    deviceId = 'unknown_device';
  }

  // 3. البحث عن الكود في عمود LicenseKey
  final queryUrl = Uri.parse(
      'https://api.airtable.com/v0/$baseId/${Uri.encodeComponent(tableName)}?filterByFormula={LicenseKey}="$licenseCode"');

  final response = await http.get(queryUrl, headers: {
    'Authorization': 'Bearer $token',
  });

  if (response.statusCode != 200) {
    return "Error connecting to server.";
  }

  final data = json.decode(response.body);
  final List records = data['records'] ?? [];

  if (records.isEmpty) {
    return "Invalid License Key."; // الكود مش موجود في الجدول أصلاً
  }

  final record = records[0];
  final String recordId = record['id'];
  final fields = record['fields'];
  final bool isUsed = fields['IsUsed'] ?? false;
  final String? storedDeviceId = fields['DeviceID'];

  // 4. منطق الحماية
  if (isUsed) {
    if (storedDeviceId == deviceId) {
      return "Success"; // المستخدم بيفعل التطبيق تاني على نفس جهازه
    } else {
      return "This key is already used on another device."; // الكود شغال على جهاز تاني
    }
  } else {
    // الكود لسه جديد.. نربطه بالجهاز ده حالاً
    final updateUrl = Uri.parse(
        'https://api.airtable.com/v0/$baseId/${Uri.encodeComponent(tableName)}/$recordId');

    final updateResponse = await http.patch(
      updateUrl,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'fields': {
          'IsUsed': true,
          'DeviceID': deviceId,
        }
      }),
    );

    if (updateResponse.statusCode == 200) {
      return "Success";
    } else {
      return "Activation failed. Try again.";
    }
  }
}
