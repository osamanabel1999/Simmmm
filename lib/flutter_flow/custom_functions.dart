import 'dart:convert';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'lat_lng.dart';
import 'place.dart';
import 'uploaded_file.dart';

String createLicenseKey() {
  const chars = 'ABCDEFGHJKLMNPQRSTUVWXYZ23456789';
  int seed = DateTime.now().microsecondsSinceEpoch;
  String result = '';

  for (int i = 0; i < 10; i++) {
    seed = (seed * 31 + i) % 1000000;
    result += chars[seed % chars.length];
  }

  return result;
}

bool? isErrorActive(
  List<int> errorList,
  int errorID,
) {
  return errorList.contains(errorID);
}

bool? isValidLocalIP(String ipAddress) {
  bool isValidLocalIP(String ipAddress) {
    // الكود ده بيفلتر الأرقام ويتأكد إنها على صيغة شبكة واي فاي محلية
    RegExp regExp = RegExp(
        r'^(192\.168|10|172\.(1[6-9]|2[0-9]|3[0-1]))\.\d{1,3}\.\d{1,3}$');
    return regExp.hasMatch(ipAddress);
  }
}
