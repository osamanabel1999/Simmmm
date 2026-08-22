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
  String reversersInop, // تم التعديل إلى String (مثال: "YES" أو "NO")
  double slope, // ميل المدرج (سالب للنزول، موجب للطلوع)
  double runwayLength, // طول المدرج المتاح بالمتر (LDA)
  String antiIceOn, // تم التعديل إلى String ("OFF", "ENGINE", "TOTAL")
) async {
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
  // السرعة المرجعية لوزن 66 طن هي تقريباً 137 عقدة
  // بتزيد/تقل بمقدار 1 عقدة لكل طن
  double vrefFull = 137.0 + (weight - 66.0);

  double vls = vrefFull;
  if (ldgConf.toUpperCase().contains('3')) {
    vls += 4.0; // CONF 3 بيحتاج سرعة أعلى بـ 4 عقد
  }

  // حساب الـ Wind Correction لسرعة الـ Approach
  double windCorr = headwind / 3.0;
  if (windCorr < 5.0) windCorr = 5.0; // الحد الأدنى
  if (windCorr > 15.0) windCorr = 15.0; // الحد الأقصى

  double vapp = vls + windCorr;

  // سرعات المناورة (Green Dot, Slat, Flap)
  int oSpeed = (2.0 * weight + 85.0).round();
  int sSpeed = (1.8 * weight + 75.0).round();
  int fSpeed = (1.25 * weight + 70.0).round();

  // =========================================================
  // 3. حساب مسافة الهبوط (Landing Distance Calculations)
  // القاعدة: 66 طن، سطح البحر، ISA، لا رياح، مدرج مستوي
  // =========================================================
  double baseDist = 0.0;
  double weightPenalizerOver = 0.0;
  double altPenalizer = 0.0;
  double tailwindPenalizer = 0.0;
  double tempPenalizer = 0.0;
  double slopePenalizer = 0.0;
  double qnhPenalizer = 0.0;

  // تحديد القيم الأساسية بناءً على الإعدادات
  if (ldgConf.toUpperCase().contains('3')) {
    if (autobrake == 'LOW') {
      baseDist = 2090.0;
      weightPenalizerOver = 40.0;
      altPenalizer = 70.0;
      tailwindPenalizer = 200.0;
      tempPenalizer = 70.0;
      slopePenalizer = 30.0;
      qnhPenalizer = 30.0;
    } else {
      // MED
      baseDist = 1450.0;
      weightPenalizerOver = 30.0;
      altPenalizer = 50.0;
      tailwindPenalizer = 130.0;
      tempPenalizer = 50.0;
      slopePenalizer = 10.0;
      qnhPenalizer = 20.0;
    }
  } else {
    // FULL
    if (autobrake == 'LOW') {
      baseDist = 1950.0;
      weightPenalizerOver = 40.0;
      altPenalizer = 70.0;
      tailwindPenalizer = 200.0;
      tempPenalizer = 70.0;
      slopePenalizer = 30.0;
      qnhPenalizer = 30.0;
    } else {
      // MED
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
    distance -= (66.0 - weight) * 10.0; // طرح 10 متر لكل طن أقل من 66
  }

  // ب. تصحيح الارتفاع
  distance += (elevation / 1000.0) * altPenalizer;

  // ج. تصحيح الرياح
  if (tailwind > 0) {
    distance += (tailwind / 5.0) * tailwindPenalizer;
  } else if (headwind > 0) {
    distance -= (headwind / 5.0) *
        (tailwindPenalizer / 2.0); // تقليل المسافة للـ Headwind
  }

  // د. تصحيح الحرارة (مقارنة بـ ISA)
  double isaTemp = 15.0 - (2.0 * (elevation / 1000.0));
  if (oat > isaTemp) {
    distance += ((oat - isaTemp) / 10.0) * tempPenalizer;
  }

  // هـ. تصحيح ميل المدرج
  if (slope < 0) {
    // نزول (Downhill)
    distance += (slope.abs()) * slopePenalizer;
  } else if (slope > 0) {
    // طلوع (Uphill)
    distance -= slope * (slopePenalizer / 2.0);
  }

  // و. تصحيح الضغط الجوي (QNH)
  if (qnh < 1013.25) {
    distance += ((1013.25 - qnh) / 10.0) * qnhPenalizer;
  }

  // ز. حالة المدرج والـ Reversers (الجزاءات القاسية)
  if (runwayCondition == 'WET') {
    distance *= 1.15; // زيادة 15%
  } else if (runwayCondition == 'ICE' || runwayCondition == 'SLUSH') {
    distance *= 1.30; // زيادة 30%
  }

  // التعديل هنا ليتعامل مع الـ Reversers كـ String
  if (reversersInop.toUpperCase() == 'YES' ||
      reversersInop.toUpperCase() == 'INOP') {
    if (runwayCondition == 'WET' || runwayCondition == 'ICE') {
      distance *= 1.10; // زيادة 10% إضافية لو المدرج مبلول ومفيش Reversers
    } else {
      // DRY
      if (autobrake == 'LOW') distance += 10.0;
      // MED DRY = 0 Penalty for No Reversers (كما في QRH)
    }
  }

  // ح. تأثير تشغيل نظام الـ Anti-Ice (تعديل منطق الـ OFF, ENGINE, TOTAL)
  // تشغيله يرفع من الـ Approach Idle Thrust وبالتالي بيزود مسافة الهبوط
  if (antiIceOn.toUpperCase() == 'ENGINE') {
    if (autobrake == 'LOW') {
      distance += 70.0; // زيادة 70 متر (Engine Anti-Ice)
    } else {
      distance += 50.0;
    }
  } else if (antiIceOn.toUpperCase() == 'TOTAL') {
    // وضع TOTAL (Engine + Wing) يزيد الـ Thrust بشكل أكبر بكثير
    if (autobrake == 'LOW') {
      distance += 160.0; // زيادة تقديرية احترافية لـ Total Anti-Ice
    } else {
      distance += 120.0;
    }
  }
  // في حالة "OFF" لا توجد زيادة (Distance تظل كما هي)

  // ط. إضافة الـ Air Distance (المسافة من بداية المدرج لحد لمس العجل)
  distance += 305.0; // تقريباً 1000 قدم

  // المسافة القانونية بالأمان
  double factoredDistance = distance * 1.15;

  // =========================================================
  // 4. مقارنة المسافة بطول المدرج المتاح (Runway Length Check)
  // =========================================================
  double remainingRunway = runwayLength - factoredDistance;
  bool isSafeToLand = remainingRunway >= 0;

  String runwayStatusMessage;
  if (isSafeToLand) {
    runwayStatusMessage = "SAFE: ${remainingRunway.round()}m Remaining";
  } else {
    runwayStatusMessage = "OVERRUN WARNING: ${remainingRunway.abs().round()}m";
  }

  // =========================================================
  // 5. تجهيز التنسيقات المطلوبة للـ UI (Formatted Outputs)
  // =========================================================

  // تنسيق الحرارة (+21° أو -5°)
  String formattedTemp = (oat >= 0) ? "+${oat.round()}°" : "${oat.round()}°";

  // تنسيق الرياح (250/12)
  String formattedWind =
      "${windDir.round().toString().padLeft(3, '0')}/${windSpeed.round()}";

  // تنسيق الفلابس
  String formattedConf =
      ldgConf.toUpperCase().contains('3') ? "CONF 3" : "FULL";

  // =========================================================
  // 6. النتيجة النهائية
  // =========================================================
  return {
    "vapp": vapp.round(),
    "vls": vls.round(),
    "o_speed": oSpeed,
    "s_speed": sSpeed,
    "f_speed": fSpeed,
    "actual_distance": distance.round(),
    "factored_distance": factoredDistance.round(),

    // التنسيقات اللي طلبتها بالظبط عشان تتعرض في الشاشة
    "qnh_display": qnh.round().toString(),
    "temp_display": formattedTemp,
    "ldg_conf_display": formattedConf,
    "wind_display": formattedWind,

    // مخرجات الـ Runway Length الجيدة
    "remaining_runway": remainingRunway.round(),
    "is_safe": isSafeToLand,
    "runway_status_message": runwayStatusMessage,
  };
}
