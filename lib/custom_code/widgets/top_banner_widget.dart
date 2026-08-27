// Automatic FlutterFlow imports
import '/actions/actions.dart' as action_blocks;
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom widgets
import '/custom_code/actions/index.dart'; // Imports custom actions
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart';
// Begin custom widget code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

class TopBannerWidget extends StatefulWidget {
  const TopBannerWidget({
    Key? key,
    this.width,
    this.height,
    // ==========================================
    // Parameters (متغيرات الـ API)
    // ==========================================
    this.latValue,
    this.lonValue,
    this.iasValue,
    this.altValue,
    this.hdgValue,
    this.simSpeedValue,
    this.connectionStatus,
    this.connectionColor, // المتغير الجديد الخاص بلون حالة الاتصال
  }) : super(key: key);

  final double? width;
  final double? height;

  // المتغيرات
  final String? latValue;
  final String? lonValue;
  final String? iasValue;
  final String? altValue;
  final String? hdgValue;
  final String? simSpeedValue;
  final String? connectionStatus;
  final Color? connectionColor;

  @override
  State<TopBannerWidget> createState() => _TopBannerWidgetState();
}

class _TopBannerWidgetState extends State<TopBannerWidget> {
  // الألوان مطابقة للصورة تماماً
  final Color bgColor = const Color(0xFF0F1115); // لون الخلفية الأساسي
  final Color cardColor = const Color(0xFF15191E); // لون الكروت
  final Color borderColor = const Color(0xFF2A2E35); // لون حواف الكروت والفواصل
  final Color labelColor =
      const Color(0xFF8B949E); // لون الكلمات (LAT, LON, الخ)
  final Color valueColor =
      const Color(0xFF3B82F6); // اللون الأزرق للأرقام والأيقونات
  final Color dangerColor =
      const Color(0xFFE53935); // اللون الأحمر للـ Disconnected الافتراضي

  // تصميم صف الداتا الصغير (مثلاً LAT و 0.0)
  Widget _buildDataRow(String label, String value) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: 32, // عرض ثابت للكلمة عشان الأرقام تطلع مظبوطة تحت بعض
          child: Text(
            label,
            style: TextStyle(
              color: labelColor,
              fontSize: 11,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.5,
            ),
          ),
        ),
        Text(
          value,
          style: TextStyle(
            color: valueColor,
            fontSize: 13,
            fontWeight: FontWeight.w500,
            fontFamily: 'Monospace', // خط أرقام دقيق
          ),
        ),
      ],
    );
  }

  // تصميم عمود الداتا الفردي (مثلاً HDG أو SIM SPEED)
  Widget _buildDataColumn(String label, String value) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: labelColor,
            fontSize: 10,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            color: valueColor,
            fontSize: 14,
            fontWeight: FontWeight.w500,
            fontFamily: 'Monospace',
          ),
        ),
      ],
    );
  }

  // تصميم الفاصل الرأسي بين البيانات
  Widget _buildVerticalDivider() {
    return Container(
      width: 1,
      height: 30,
      color: borderColor,
      margin: const EdgeInsets.symmetric(horizontal: 16),
    );
  }

  @override
  Widget build(BuildContext context) {
    // ارتفاع البانر 75 عشان الكروت تاخد راحتها جوا
    return Container(
      width: widget.width ?? double.infinity,
      height: widget.height ?? 75.0,
      color: bgColor,
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      // Scroll أفقي عشان لو الشاشة صغيرة (موبايل) ميعملش إيرور، وفي الايباد هيفرد براحته
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        child: Row(
          children: [
            // ==========================================
            // الكارت الأول: الإحداثيات (Globe)
            // ==========================================
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: borderColor, width: 1),
              ),
              child: Row(
                children: [
                  Icon(Icons.language,
                      color: valueColor, size: 22), // أيقونة الكرة الأرضية
                  const SizedBox(width: 12),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildDataRow("LAT", widget.latValue ?? "0.0"),
                      const SizedBox(height: 4),
                      _buildDataRow("LON", widget.lonValue ?? "0.0"),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(width: 8),

            // ==========================================
            // الكارت الثاني: بيانات الطيران (Airplane)
            // ==========================================
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: borderColor, width: 1),
              ),
              child: Row(
                children: [
                  // الأيقونة والسرعة/الارتفاع
                  Icon(Icons.flight, color: valueColor, size: 22),
                  const SizedBox(width: 12),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildDataRow("IAS", widget.iasValue ?? "0"),
                      const SizedBox(height: 4),
                      _buildDataRow("ALT", widget.altValue ?? "0"),
                    ],
                  ),

                  _buildVerticalDivider(),

                  // الاتجاه (HDG)
                  _buildDataColumn("HDG", widget.hdgValue ?? "000°"),

                  _buildVerticalDivider(),

                  // سرعة المحاكي (SIM SPEED)
                  _buildDataColumn("SIM SPEED", widget.simSpeedValue ?? "1"),
                ],
              ),
            ),

            const SizedBox(width: 8),

            // ==========================================
            // الكارت الثالث: حالة الاتصال (Disconnected)
            // ==========================================
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: borderColor, width: 1),
              ),
              child: Row(
                children: [
                  Icon(Icons.radio_button_checked,
                      color: widget.connectionColor ?? dangerColor, size: 16),
                  const SizedBox(width: 10),
                  Text(
                    widget.connectionStatus ?? "Disconnected",
                    style: TextStyle(
                      color: widget.connectionColor ??
                          dangerColor, // استخدام المتغير الجديد أو اللون الافتراضي
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Icon(Icons.adjust,
                      color: widget.connectionColor ?? dangerColor, size: 16),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
