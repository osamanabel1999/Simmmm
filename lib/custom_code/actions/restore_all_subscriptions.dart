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

Future<dynamic> restoreAllSubscriptions() async {
  try {
    // 1. استعادة المشتريات من سيرفر RevenueCat/Apple
    CustomerInfo customerInfo = await Purchases.restorePurchases();

    bool isXplaneActive = false;
    bool isMsfsActive = false;
    bool hasExpiredSubscription = false;

    String activeSimTitle = 'NO SIMULATOR';
    String planType = 'No Active Plan';
    String expiryDate = 'Not Active';
    String priceText = '\$0.00';
    String responseMessage = '';

    // 2. فحص الباقة المجمعة (Bundle) أولاً
    EntitlementInfo? bundleEnt =
        customerInfo.entitlements.all['simulator_station_msfs_xplane'];
    if (bundleEnt != null) {
      if (bundleEnt.isActive) {
        isXplaneActive = true;
        isMsfsActive = true;
        activeSimTitle = 'MSFS & X-PLANE';

        String prodId = bundleEnt.productIdentifier.toLowerCase();
        if (prodId.contains('yearly') || prodId.contains('1y'))
          planType = 'Yearly Pass';
        else if (prodId.contains('lifetime') ||
            bundleEnt.expirationDate == null)
          planType = 'Lifetime Pass';
        else
          planType = 'Monthly Pass';

        if (bundleEnt.expirationDate != null) {
          DateTime? pDate =
              DateTime.tryParse(bundleEnt.expirationDate!)?.toLocal();
          if (pDate != null)
            expiryDate =
                "${pDate.year}-${pDate.month.toString().padLeft(2, '0')}-${pDate.day.toString().padLeft(2, '0')}";
        } else {
          expiryDate = 'Lifetime';
        }
      } else {
        hasExpiredSubscription = true;
      }
    }

    // 3. فحص باقة MSFS المستقلة
    EntitlementInfo? msfsEnt =
        customerInfo.entitlements.all['simulator_station_pro'];
    if (msfsEnt != null) {
      if (msfsEnt.isActive) {
        isMsfsActive = true;
        if (!isXplaneActive) activeSimTitle = 'MSFS 2020/2024';

        String prodId = msfsEnt.productIdentifier.toLowerCase();
        if (prodId.contains('yearly') || prodId.contains('1y'))
          planType = 'Yearly Pass';
        else if (prodId.contains('lifetime') || msfsEnt.expirationDate == null)
          planType = 'Lifetime Pass';
        else
          planType = 'Monthly Pass';

        if (msfsEnt.expirationDate != null) {
          DateTime? pDate =
              DateTime.tryParse(msfsEnt.expirationDate!)?.toLocal();
          if (pDate != null)
            expiryDate =
                "${pDate.year}-${pDate.month.toString().padLeft(2, '0')}-${pDate.day.toString().padLeft(2, '0')}";
        } else {
          expiryDate = 'Lifetime';
        }
      } else {
        hasExpiredSubscription = true;
      }
    }

    // 4. فحص باقة X-Plane المستقلة
    EntitlementInfo? xplaneEnt =
        customerInfo.entitlements.all['simulator_station_xplane'];
    if (xplaneEnt != null) {
      if (xplaneEnt.isActive) {
        isXplaneActive = true;
        if (isMsfsActive) {
          activeSimTitle = 'MSFS & X-PLANE';
        } else {
          activeSimTitle = 'X-PLANE';
        }

        String prodId = xplaneEnt.productIdentifier.toLowerCase();
        if (prodId.contains('yearly') || prodId.contains('1y'))
          planType = 'Yearly Pass';
        else if (prodId.contains('lifetime') ||
            xplaneEnt.expirationDate == null)
          planType = 'Lifetime Pass';
        else
          planType = 'Monthly Pass';

        if (xplaneEnt.expirationDate != null) {
          DateTime? pDate =
              DateTime.tryParse(xplaneEnt.expirationDate!)?.toLocal();
          if (pDate != null)
            expiryDate =
                "${pDate.year}-${pDate.month.toString().padLeft(2, '0')}-${pDate.day.toString().padLeft(2, '0')}";
        } else {
          expiryDate = 'Lifetime';
        }
      } else {
        hasExpiredSubscription = true;
      }
    }

    bool hasAnyActive = isXplaneActive || isMsfsActive;

    // 5. صياغة الرسالة التلقائية بناءً على النتيجة
    if (isXplaneActive && isMsfsActive) {
      responseMessage =
          'تم استعادة اشتراك الباقة المجمعة (MSFS & X-Plane) بنجاح!';
    } else if (isXplaneActive) {
      responseMessage = 'تم استعادة اشتراك محاكي X-Plane بنجاح!';
    } else if (isMsfsActive) {
      responseMessage = 'تم استعادة اشتراك محاكي MSFS بنجاح!';
    } else if (hasExpiredSubscription) {
      responseMessage =
          'اشتراكك السابق قد انتهى، يرجى تجديد الاشتراك لاستخدام المحاكي.';
    } else {
      responseMessage = 'لم نجد أي اشتراكات مرتبطة بهذا الحساب.';
    }

    return {
      'is_active': hasAnyActive,
      'is_xplane_active': isXplaneActive,
      'is_msfs_active': isMsfsActive,
      'status': hasAnyActive ? 'ACTIVE' : 'INACTIVE',
      'simulator_type': activeSimTitle,
      'plan_type': planType,
      'expiration_date': expiryDate,
      'price_text': priceText,
      'message': responseMessage,
    };
  } catch (e) {
    debugPrint('Error restoring purchases: $e');
  }

  return {
    'is_active': false,
    'is_xplane_active': false,
    'is_msfs_active': false,
    'status': 'INACTIVE',
    'simulator_type': 'NO SIMULATOR',
    'plan_type': 'No Active Plan',
    'expiration_date': 'Not Active',
    'price_text': '\$0.00',
    'message': 'حدث خطأ أثناء الاتصال بالمتجر، يرجى المحاولة لاحقاً.',
  };
}
