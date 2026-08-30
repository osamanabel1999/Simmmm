// Automatic FlutterFlow imports
import '/actions/actions.dart' as action_blocks;
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom actions
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'package:purchases_flutter/purchases_flutter.dart';

Future<dynamic> getSubscriptionDetailsFromList(String? simulatorType) async {
  List<String> entitlementIds = [];

  if (simulatorType == 'XPLANE') {
    entitlementIds = [
      'simulator_station_xplane',
      'simulator_station_msfs_xplane',
    ];
  } else if (simulatorType == 'MSFS') {
    entitlementIds = [
      'simulator_station_pro',
      'simulator_station_msfs_xplane',
    ];
  } else {
    entitlementIds = [
      'simulator_station_msfs_xplane',
      'simulator_station_pro',
      'simulator_station_xplane',
    ];
  }

  try {
    CustomerInfo customerInfo = await Purchases.getCustomerInfo();

    for (String entitlementId in entitlementIds) {
      EntitlementInfo? entitlement =
          customerInfo.entitlements.all[entitlementId];

      if (entitlement != null && entitlement.isActive) {
        String planType = 'Monthly';
        String simTitle = 'X-PLANE';
        String priceText = '\$0.00';
        String formattedDate = 'Lifetime';

        // 1. استخراج السعر الحقيقي من المتجر لو متوفر في بيانات الـ Entitlement
        // RevenueCat يوفر الـ productIdentifier لربط السعر
        String productId = entitlement.productIdentifier.toLowerCase();

        // 2. تحديد اسم المحاكي
        if (entitlementId == 'simulator_station_msfs_xplane') {
          simTitle = 'MSFS & X-PLANE';
        } else if (entitlementId == 'simulator_station_pro') {
          simTitle = 'MSFS 2020/2024';
        } else {
          simTitle = 'X-PLANE';
        }

        // 3. تحديد نوع الخطة
        if (productId.contains('yearly') ||
            productId.contains('annual') ||
            productId.contains('1y')) {
          planType = 'Yearly Pass';
        } else if (productId.contains('lifetime') ||
            entitlement.expirationDate == null) {
          planType = 'Lifetime Pass';
        } else {
          planType = 'Monthly Pass';
        }

        // 4. استدعاء السعر المباشر للباقة المفعلة من سيرفر RevenueCat
        try {
          List<StoreProduct> products =
              await Purchases.getProducts([entitlement.productIdentifier]);
          if (products.isNotEmpty) {
            priceText = products.first
                .priceString; // يرجع السعر مع عملة حساب المستخدم (مثلاً $2.99 أو EGP 150)
          }
        } catch (e) {
          debugPrint('Error fetching product price: $e');
        }

        // 5. تنسيق تاريخ الانتهاء
        if (entitlement.expirationDate != null &&
            entitlement.expirationDate!.isNotEmpty) {
          DateTime? parsedDate =
              DateTime.tryParse(entitlement.expirationDate!)?.toLocal();
          if (parsedDate != null) {
            formattedDate =
                "${parsedDate.year}-${parsedDate.month.toString().padLeft(2, '0')}-${parsedDate.day.toString().padLeft(2, '0')}";
          }
        } else {
          planType = 'Lifetime Pass';
          formattedDate = 'Lifetime';
        }

        return {
          'is_active': true,
          'status': 'ACTIVE',
          'simulator_type': simTitle,
          'plan_type': planType,
          'expiration_date': formattedDate,
          'price_text': priceText,
        };
      }
    }
  } catch (e) {
    debugPrint('Error checking entitlement list: $e');
  }

  return {
    'is_active': false,
    'status': 'INACTIVE',
    'simulator_type': 'NO SIMULATOR',
    'plan_type': 'No Active Plan',
    'expiration_date': 'Not Active',
    'price_text': '\$0.00',
  };
}
