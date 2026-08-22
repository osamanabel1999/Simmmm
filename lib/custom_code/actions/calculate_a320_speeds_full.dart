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

Future<dynamic> calculateA320SpeedsFull(
  double weight,
  String flapsIndex,
  double elevation,
  double oat,
  double runwayHeading, // تم الإضافة: اتجاه المدرج
  double windDirection, // تم الإضافة: اتجاه الرياح
  double windSpeed, // تم الإضافة: سرعة الرياح
  double runwayLength,
  double slope,
  String isWet,
  String isPacksOn,
  String antiIceIndex,
  double cg,
  double qnh, // تم إضافة المتغير هنا عشان FlutterFlow ميمسحوش
) async {
  // ---------------------------------------------------------
  // حساب مركبة الرياح أوتوماتيكياً (Wind Component Calculation)
  // ---------------------------------------------------------
  double angleDifference = windDirection - runwayHeading;
  double angleInRadians = angleDifference * (math.pi / 180.0);
  double wind = windSpeed * math.cos(angleInRadians);
  // ---------------------------------------------------------

  // --- إضافة بسيطة لتحويل النصوص إلى أرقام وحالات يفهمها باقي الكود ---
  int parsedFlaps = 0;
  if (flapsIndex.contains('2'))
    parsedFlaps = 1;
  else if (flapsIndex.contains('3')) parsedFlaps = 2;

  bool parsedWet = (isWet == 'WET');
  bool parsedPacks = (isPacksOn == 'ON');

  int parsedAntiIce = 0;
  if (antiIceIndex == 'Engine')
    parsedAntiIce = 1;
  else if (antiIceIndex == 'Total') parsedAntiIce = 2;
  // ---------------------------------------------------------

  // ---------------------------------------------------------
  // 1. السرعات الأساسية (Base Calculation)
  // معادلة خطية (Linear Regression) مستنتجة من جداول QRH لـ A320-214
  // ---------------------------------------------------------
  double baseVr = (1.21 * (weight - 50.0)) + 121.5;

  // ---------------------------------------------------------
  // 2. تصحيح وضعية الفلابس (Flaps Correction)
  // ---------------------------------------------------------
  if (parsedFlaps == 1) {
    baseVr -= 4.0; // Configuration 2
  } else if (parsedFlaps == 2) {
    baseVr -= 8.0; // Configuration 3
  }
  // ملاحظة: Index 0 هو Configuration 1+F (الأساسي)

  double v1 = baseVr - 1.0;
  double vr = baseVr;
  double v2 = baseVr + 4.5; // الـ V2 دايماً أعلى من VR بمتوسط 4-5 عقد

  // ---------------------------------------------------------
  // 3. تصحيح البيئة (Environment: Altitude & Temperature)
  // ---------------------------------------------------------
  // تأثير الارتفاع: +1 عقدة لكل 1000 قدم
  double altCorr = (elevation / 1000.0);

  // تأثير الحرارة: ISA هي 15 درجة. أي زيادة تطلب سرعة أعلى للرفع
  double tempCorr = 0.0;
  if (oat > 15.0) {
    tempCorr = (oat - 15.0) * 0.45;
  }

  v1 += (altCorr + tempCorr);
  vr += (altCorr + tempCorr);
  v2 += (altCorr + tempCorr);

  // ---------------------------------------------------------
  // 4. تصحيح الأنظمة (Systems: Packs & Anti-Ice)
  // تشغيل التكييف والـ Anti-Ice بيسحب من قدرة المحرك (Thrust Reduction)
  // ---------------------------------------------------------
  if (parsedPacks) {
    v1 += 1.0;
    vr += 1.0;
    v2 += 1.0;
  }

  if (parsedAntiIce == 1) {
    // Engine Anti-Ice ON
    v1 += 1.2;
    vr += 1.2;
    v2 += 1.2;
  } else if (parsedAntiIce == 2) {
    // Total Anti-Ice (Engine + Wing) ON
    v1 += 2.5;
    vr += 2.5;
    v2 += 2.5;
  }

  // ---------------------------------------------------------
  // 5. تأثير مركز الثقل (CG - Center of Gravity)
  // ---------------------------------------------------------
  // الـ Forward CG (أقل من 26%) بيصعب عملية الـ Rotation
  if (cg < 26.0) {
    vr += 1.5;
    v2 += 1.0;
  }
  // الـ Aft CG (أكبر من 32%) بيسهل الـ Rotation
  else if (cg > 32.0) {
    vr -= 1.0;
  }

  // ---------------------------------------------------------
  // 6. تصحيحات سرعة القرار (V1 Specific Corrections)
  // العوامل اللي بتأثر على القدرة على التوقف قبل نهاية المدرج
  // ---------------------------------------------------------

  // أ. الرياح (Wind)
  if (wind > 0) {
    // Headwind: بيساعد على التوقف، فممكن نزود V1 سنة
    v1 += (wind / 10.0);
  } else if (wind < 0) {
    // Tailwind: بيزود مسافة التوقف، لازم نقلل V1 للقرار البدري
    v1 -= (wind.abs() * 0.4);
  }

  // ب. ميل المدرج (Runway Slope)
  if (slope > 0) {
    // Uphill: الجاذبية بتساعدك تفرمل
    v1 += (slope * 0.8);
  } else if (slope < 0) {
    // Downhill: الجاذبية بتشدك، لازم تقلل V1
    v1 -= (slope.abs() * 1.5);
  }

  // ج. طول المدرج (Runway Length)
  // المرجع هو 2200 متر لـ A320. لو أقل، بنقلل V1 للأمان
  if (runwayLength < 2200.0) {
    v1 -= ((2200.0 - runwayLength) / 100.0) * 1.8;
  }

  // د. حالة المدرج (Runway Condition)
  if (parsedWet) {
    v1 -= 7.0; // تقليل V1 بمقدار كبير في حالة المدرج المبلول لضمان مسافة التوقف
  }

  // ---------------------------------------------------------
  // 7. حواجز الأمان (Safety Clamps)
  // قواعد الطيران الصارمة لضمان عدم خروج الأرقام عن المنطق
  // ---------------------------------------------------------

  // V1 لا يمكن أن تتخطى VR
  if (v1 > vr) {
    v1 = vr;
  }

  // V2 يجب أن تكون أعلى من VR بحد أدنى لضمان الـ Climb Gradient
  if (v2 < (vr + 2.0)) {
    v2 = vr + 2.0;
  }

  // الحدود الدنيا للتشغيل (Minimum Speeds) لـ A320
  if (v1 < 105.0) v1 = 105.0;
  if (vr < 110.0) vr = 110.0;
  if (v2 < 115.0) v2 = 115.0;

  // ---------------------------------------------------------
  // استدعاء الدوال الإضافية لتجهيز المخرجات الجديدة
  // ---------------------------------------------------------
  double pressureAlt = calculatePressureAltitude(elevation, qnh);
  String flexTemp =
      calculateFlexTemp(oat, weight, runwayLength, parsedWet, parsedAntiIce);
  Map<String, int> maneuveringSpeeds = calculateManeuveringSpeeds(weight);

  // --- التعديل: استخراج رقم الفلابس ودمجه مع نتيجة الـ THS ---
  String flapPrefix = "1";
  if (parsedFlaps == 1) {
    flapPrefix = "2";
  } else if (parsedFlaps == 2) {
    flapPrefix = "3";
  }
  String ths = "$flapPrefix/${calculateTHS(cg)}";
  // -----------------------------------------------------------

  double eoAcc = calculateEOAcc(elevation);

  // ---------------------------------------------------------
  // 8. تجهيز النتيجة النهائية (Return JSON)
  // ---------------------------------------------------------
  return {
    "v1": v1.round(),
    "vr": vr.round(),
    "v2": v2.round(),
    "is_safe": (runwayLength > 1600.0) ? true : false,
    "calculation_timestamp": DateTime.now().toIso8601String(),

    // النواتج الإضافية المدمجة
    "pressure_altitude": pressureAlt,
    "flex_temp": flexTemp,
    "f_speed": maneuveringSpeeds["F"],
    "s_speed": maneuveringSpeeds["S"],
    "green_dot_speed": maneuveringSpeeds["O"],
    "ths": ths,
    "eo_acc": eoAcc
  };
}

// 1. حساب الارتفاع الضغطي (Pressure Altitude)
// QNH: المدخل من المستخدم، elevation: ارتفاع المطار
double calculatePressureAltitude(double elevation, double qnh) {
  double pressureAlt = elevation + ((1013.25 - qnh) * 30.0);
  return (pressureAlt < 0) ? 0.0 : pressureAlt;
}

// 2. حساب الـ FLEX TEMP مع الشروط
// oat: حرارة الجو، weight: الوزن، runway: طول المدرج
String calculateFlexTemp(
    double oat, double weight, double runwayLength, bool isWet, int antiIce) {
  // معادلة مرجعية لـ A320 (CFM Engines)
  double flex =
      72.0 - ((weight - 50.0) * 1.5) + ((runwayLength - 2200.0) / 200.0);

  // شروط التقليل (Constraints)
  if (isWet) flex -= 5.0; // المدرج المبلول يتطلب قوة أكبر (Flex أقل)
  if (antiIce > 0) flex -= 3.0; // تشغيل الـ Anti-ice يستهلك قوة المحرك

  // شروط الحدود (Safety Limits)
  if (flex > 73.0) flex = 73.0; // TMaxFlex limit

  // شرط TOGA: لو الـ Flex المحسوب أقل من حرارة الجو بـ 5 درجات، لازم نطلع بـ TOGA
  if (flex <= (oat + 5.0)) {
    return "TOGA";
  }

  return "${flex.round()}°";
}

// 3. حساب سرعات المناورة (F, S, Green Dot) بناءً على أرقام Airbus الفنية
Map<String, int> calculateManeuveringSpeeds(double weight) {
  // هذه المعادلات مستنتجة من جداول QRH لوزن بين 50 إلى 78 طن
  double oSpeed = (2.0 * weight) + 85.0; // Green Dot
  double sSpeed = (1.8 * weight) + 75.0; // Slat Speed
  double fSpeed = (1.25 * weight) + 70.0; // Flap Speed

  return {
    "F": fSpeed.round(),
    "S": sSpeed.round(),
    "O": oSpeed.round(),
  };
}

// 4. حساب الـ THS (Pitch Trim)
// cg: Center of Gravity (نسبة مئوية)
String calculateTHS(double cg) {
  // معادلة Airbus القياسية: (32 - CG) / 4.7
  double trimValue = (32.0 - cg) / 4.7;

  if (trimValue >= 0) {
    return "UP ${trimValue.toStringAsFixed(1)}";
  } else {
    return "DN ${trimValue.abs().toStringAsFixed(1)}";
  }
}

// 5. حساب Engine Out Acceleration (EO ACC)
double calculateEOAcc(double elevation) {
  // القاعدة العامة: ارتفاع المطار + 1500 قدم
  // أو حسب الـ Obstacles (نستخدم 1500 كمعيار افتراضي آمن)
  return elevation + 1500.0;
}
