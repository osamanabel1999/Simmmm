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
import 'dart:math';
import 'package:http/http.dart' as http;

Future<String> generateNewLicense() async {
  // 1. التوكن الجديد والبيانات المأخوذة من الـ Test الناجح بتاعك
  const String token =
      'patZuFHBTfOuzMmP7.b473d75321c56e35e5f7c0d76fcc330098903b08fabc3860400953058a89e39d';
  const String baseId = 'appmz3issohHsNLRM';
  const String tableName = 'Table 1';

  // 2. توليد كود عشوائي (8 حروف وأرقام)
  const chars = 'ABCDEFGHJKLMNPQRSTUVWXYZ23456789';
  String newCode =
      List.generate(8, (index) => chars[Random().nextInt(chars.length)]).join();

  // 3. بناء الرابط (URL)
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
          'LicenseKey': newCode, // التأكد من اسم العمود في Airtable
          'IsUsed': false,
        }
      }),
    );

    // 4. التحقق من النتيجة
    if (response.statusCode == 200 || response.statusCode == 201) {
      return newCode; // هيرجع الكود الجديد عشان تظهره للمستخدم أو تخزنه
    } else {
      return "Error: ${response.statusCode}"; // لو لسه فيه مشكلة هيظهر رقم الخطأ
    }
  } catch (e) {
    return "Network Error";
  }
}
