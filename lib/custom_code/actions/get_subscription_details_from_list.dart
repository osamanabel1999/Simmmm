// Automatic FlutterFlow imports
import '/actions/actions.dart' as action_blocks;
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom actions
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

// Automatic Imports for FlutterFlow

// Required RevenueCat Import
import 'package:purchases_flutter/purchases_flutter.dart';

Future<dynamic> getSubscriptionDetailsFromList() async {
  // قائمة الـ IDs المحددة مباشرة داخل الكود
  final List<String> entitlementIds = [
    'simulator_station_msfs_xplane',
    'simulator_station_pro',
    'simulator_station_xplane',
  ];

  try {
    CustomerInfo customerInfo = await Purchases.getCustomerInfo();

    for (String entitlementId in entitlementIds) {
      EntitlementInfo? entitlement =
          customerInfo.entitlements.all[entitlementId];

      if (entitlement != null && entitlement.isActive) {
        String planType = 'Unknown';
        String formattedDate = 'Lifetime';

        String productId = entitlement.productIdentifier.toLowerCase();

        if (productId.contains('monthly') || productId.contains('1m')) {
          planType = 'Monthly';
        } else if (productId.contains('yearly') ||
            productId.contains('annual') ||
            productId.contains('1y')) {
          planType = 'Yearly';
        } else if (productId.contains('lifetime') ||
            entitlement.expirationDate == null) {
          planType = 'Lifetime';
        } else {
          planType = 'Active Subscription';
        }

        if (entitlement.expirationDate != null &&
            entitlement.expirationDate!.isNotEmpty) {
          DateTime? parsedDate =
              DateTime.tryParse(entitlement.expirationDate!)?.toLocal();
          if (parsedDate != null) {
            formattedDate =
                "${parsedDate.year}-${parsedDate.month.toString().padLeft(2, '0')}-${parsedDate.day.toString().padLeft(2, '0')}";
          }
        } else {
          planType = 'Lifetime';
          formattedDate = 'Lifetime';
        }

        return {
          'is_active': true,
          'active_entitlement': entitlementId,
          'plan_type': planType,
          'expiration_date': formattedDate
        };
      }
    }
  } catch (e) {
    debugPrint('Error checking entitlement list: $e');
  }

  return {
    'is_active': false,
    'active_entitlement': 'none',
    'plan_type': 'None',
    'expiration_date': 'Not Active'
  };
}
