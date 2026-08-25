// Automatic FlutterFlow imports
import '/actions/actions.dart' as action_blocks;
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom actions
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'dart:math' as math;
import 'dart:convert';

Future<dynamic> calculateA320Landing(
  double weight, // وزن الهبوط بالطن (مثال: 64.5)
  double elevation, // ارتفاع المطار بالقدم
  double oat, // درجة الحرارة المئوية
  double qnh, // الضغط الجوي (مثال: 1013)
  double windDir, // اتجاه الرياح (مثال: 250)
  double windSpeed, // سرعة الرياح بالعقدة (مثال: 12)
  double runwayHeading, // اتجاه المدرج (مثال: 240)
  String ldgConf, // "FULL" أو "CONF 3"
  String runwayCondition, // "DRY", "WET", "ICE"
  String autobrake, // "LOW" أو "MED"
  String reversersInop, // "YES" أو "NO"
  double slope, // ميل المدرج
  double runwayLength, // طول المدرج المتاح بالمتر (LDA)
  String antiIceOn, // "OFF", "ENGINE", "TOTAL"
) async {
  try {
    // =========================================================
    // 1. حساب مركبة الرياح (Headwind / Tailwind)
    // =========================================================
    double angleDiff = (windDir - runwayHeading) * (math.pi / 180.0);
    double windComponent = windSpeed * math.cos(angleDiff);

    double headwind = (windComponent > 0) ? windComponent : 0.0;
    double tailwind = (windComponent < 0) ? windComponent.abs() : 0.0;

    // =========================================================
    // 2. حساب السرعات (VLS, VAPP, O, S, F)
    // =========================================================
    double vrefFull = 137.0 + (weight - 66.0);

    double vls = vrefFull;
    if (ldgConf.toUpperCase().contains('3')) {
      vls += 4.0;
    }

    double windCorr = headwind / 3.0;
    if (windCorr < 5.0) windCorr = 5.0;
    if (windCorr > 15.0) windCorr = 15.0;

    double vapp = vls + windCorr;

    int oSpeed = (2.0 * weight + 85.0).round();
    int sSpeed = (1.8 * weight + 75.0).round();
    int fSpeed = (1.25 * weight + 70.0).round();

    // =========================================================
    // 3. حساب مسافة الهبوط (Landing Distance Calculations)
    // =========================================================
    double baseDist = 0.0;
    double weightPenalizerOver = 0.0;
    double altPenalizer = 0.0;
    double tailwindPenalizer = 0.0;
    double tempPenalizer = 0.0;
    double slopePenalizer = 0.0;
    double qnhPenalizer = 0.0;

    if (ldgConf.toUpperCase().contains('3')) {
      if (autobrake.toUpperCase() == 'LOW') {
        baseDist = 2090.0;
        weightPenalizerOver = 40.0;
        altPenalizer = 70.0;
        tailwindPenalizer = 200.0;
        tempPenalizer = 70.0;
        slopePenalizer = 30.0;
        qnhPenalizer = 30.0;
      } else {
        baseDist = 1450.0;
        weightPenalizerOver = 30.0;
        altPenalizer = 50.0;
        tailwindPenalizer = 130.0;
        tempPenalizer = 50.0;
        slopePenalizer = 10.0;
        qnhPenalizer = 20.0;
      }
    } else {
      if (autobrake.toUpperCase() == 'LOW') {
        baseDist = 1950.0;
        weightPenalizerOver = 40.0;
        altPenalizer = 70.0;
        tailwindPenalizer = 200.0;
        tempPenalizer = 70.0;
        slopePenalizer = 30.0;
        qnhPenalizer = 30.0;
      } else {
        baseDist = 1370.0;
        weightPenalizerOver = 30.0;
        altPenalizer = 50.0;
        tailwindPenalizer = 130.0;
        tempPenalizer = 50.0;
        slopePenalizer = 10.0;
        qnhPenalizer = 20.0;
      }
    }

    double distance = baseDist;

    // أ. تصحيح الوزن
    if (weight > 66.0) {
      distance += (weight - 66.0) * weightPenalizerOver;
    } else if (weight < 66.0) {
      distance -= (66.0 - weight) * 10.0;
    }

    // ب. تصحيح الارتفاع
    distance += (elevation / 1000.0) * altPenalizer;

    // ج. تصحيح الرياح
    if (tailwind > 0) {
      distance += (tailwind / 5.0) * tailwindPenalizer;
    } else if (headwind > 0) {
      distance -= (headwind / 5.0) * (tailwindPenalizer / 2.0);
    }

    // د. تصحيح الحرارة
    double isaTemp = 15.0 - (2.0 * (elevation / 1000.0));
    if (oat > isaTemp) {
      distance += ((oat - isaTemp) / 10.0) * tempPenalizer;
    }

    // هـ. تصحيح ميل المدرج
    if (slope < 0) {
      distance += (slope.abs()) * slopePenalizer;
    } else if (slope > 0) {
      distance -= slope * (slopePenalizer / 2.0);
    }

    // و. تصحيح الضغط الجوي
    if (qnh < 1013.25) {
      distance += ((1013.25 - qnh) / 10.0) * qnhPenalizer;
    }

    // ز. حالة المدرج والـ Reversers
    if (runwayCondition.toUpperCase() == 'WET') {
      distance *= 1.15;
    } else if (runwayCondition.toUpperCase() == 'ICE' ||
        runwayCondition.toUpperCase() == 'SLUSH') {
      distance *= 1.30;
    }

    if (reversersInop.toUpperCase() == 'YES' ||
        reversersInop.toUpperCase() == 'INOP') {
      if (runwayCondition.toUpperCase() == 'WET' ||
          runwayCondition.toUpperCase() == 'ICE') {
        distance *= 1.10;
      } else {
        if (autobrake.toUpperCase() == 'LOW') distance += 10.0;
      }
    }

    // ح. تأثير الـ Anti-Ice
    if (antiIceOn.toUpperCase() == 'ENGINE') {
      distance += (autobrake.toUpperCase() == 'LOW') ? 70.0 : 50.0;
    } else if (antiIceOn.toUpperCase() == 'TOTAL') {
      distance += (autobrake.toUpperCase() == 'LOW') ? 160.0 : 120.0;
    }

    // ط. Air Distance والـ Safety Factor
    distance += 305.0;
    double factoredDistance = distance * 1.15;

    // =========================================================
    // 4. مقارنة المسافة بطول المدرج المتاح
    // =========================================================
    double remainingRunway = runwayLength - factoredDistance;
    bool isSafeToLand = remainingRunway >= 0;

    String runwayStatusMessage = isSafeToLand
        ? "SAFE: ${remainingRunway.round()}m Remaining"
        : "OVERRUN WARNING: ${remainingRunway.abs().round()}m";

    // =========================================================
    // 5. التنسيقات للـ UI
    // =========================================================
    String formattedTemp = (oat >= 0) ? "+${oat.round()}°" : "${oat.round()}°";
    String formattedWind =
        "${windDir.round().toString().padLeft(3, '0')}/${windSpeed.round()}";
    String formattedConf =
        ldgConf.toUpperCase().contains('3') ? "CONF 3" : "FULL";

    // Map المخرجات
    Map<String, dynamic> resultCode = {
      "vapp": vapp.round(),
      "vls": vls.round(),
      "o_speed": oSpeed,
      "s_speed": sSpeed,
      "f_speed": fSpeed,
      "actual_distance": distance.round(),
      "factored_distance": factoredDistance.round(),
      "qnh_display": qnh.round().toString(),
      "temp_display": formattedTemp,
      "ldg_conf_display": formattedConf,
      "wind_display": formattedWind,
      "remaining_runway": remainingRunway.round(),
      "is_safe": isSafeToLand,
      "runway_status_message": runwayStatusMessage,
    };

    // تحويل الـ Map إلى JSON متوافق تماماً مع FlutterFlow Return Parameter
    return jsonDecode(jsonEncode(resultCode));
  } catch (e) {
    Map<String, dynamic> errorMap = {
      "error": e.toString(),
      "is_safe": false,
      "runway_status_message": "CALCULATION ERROR",
    };
    return jsonDecode(jsonEncode(errorMap));
  }
}
