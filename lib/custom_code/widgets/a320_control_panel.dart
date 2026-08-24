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

class A320ControlPanel extends StatefulWidget {
  const A320ControlPanel({
    Key? key,
    this.width,
    this.height,
    // Door Actions (From Python Code)
    this.onToggleMainDoor,
    this.onOpenAllDoors,
    this.onCloseAllDoors,
    // Ground Services Actions (From Python Code)
    this.onToggleJetway,
    this.onToggleBaggage,
    this.onToggleCatering,
    this.onToggleGPU,
    this.onRequestFuel,
  }) : super(key: key);

  final double? width;
  final double? height;

  final Future Function()? onToggleMainDoor;
  final Future Function()? onOpenAllDoors;
  final Future Function()? onCloseAllDoors;

  final Future Function()? onToggleJetway;
  final Future Function()? onToggleBaggage;
  final Future Function()? onToggleCatering;
  final Future Function()? onToggleGPU;
  final Future Function()? onRequestFuel;

  @override
  _A320ControlPanelState createState() => _A320ControlPanelState();
}

class _A320ControlPanelState extends State<A320ControlPanel> {
  // ألوان الثيم الداكن
  final Color bgColor = const Color(0xFF161618);
  final Color panelColor = const Color(0xFF1E1E22);
  final Color borderColor = const Color(0xFFE0E0E0);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width ?? double.infinity,
      height: widget.height ?? double.infinity,
      color: bgColor,
      padding: const EdgeInsets.all(16.0),
      child: LayoutBuilder(
        builder: (context, constraints) {
          // تجاوب الشاشة: أكثر من 700 بكسل (أيباد) يعرضهم جنب بعض، أقل يعرضهم فوق بعض
          bool isWide = constraints.maxWidth > 700;

          if (isWide) {
            return Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(flex: 1, child: _buildDoorControlPanel()),
                const SizedBox(width: 16),
                Expanded(flex: 1, child: _buildEquipmentPanel()),
              ],
            );
          } else {
            return SingleChildScrollView(
              child: Column(
                children: [
                  _buildDoorControlPanel(),
                  const SizedBox(height: 16),
                  _buildEquipmentPanel(),
                ],
              ),
            );
          }
        },
      ),
    );
  }

  // ---------------------------------------------------------
  // 1. قسم الأبواب (يحتوي على الأيقونة وأزرار البايثون الخاصة بالأبواب)
  // ---------------------------------------------------------
  Widget _buildDoorControlPanel() {
    return Container(
      decoration: BoxDecoration(
        color: panelColor,
        border: Border.all(color: borderColor.withOpacity(0.5), width: 2),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              "AIRCRAFT DOORS",
              style: TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.5,
              ),
            ),
          ),
          Divider(color: borderColor.withOpacity(0.3), height: 1),
          const SizedBox(height: 30),

          // أيقونة الطائرة الكبيرة بدلاً من الرسمة
          Transform.rotate(
            angle: -1.5708, // تدوير الأيقونة 90 درجة لتبدو كأنها متجهة للأعلى
            child: Icon(
              Icons.flight,
              size: 140,
              color: borderColor.withOpacity(0.4),
            ),
          ),

          const SizedBox(height: 30),

          // أزرار الأبواب مستخرجة من كود البايثون فقط
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              children: [
                _buildEfbButton("Toggle Main Door", widget.onToggleMainDoor,
                    Icons.meeting_room_outlined),
                const SizedBox(height: 16),
                _buildEfbButton("Open All Doors", widget.onOpenAllDoors,
                    Icons.lock_open_outlined),
                const SizedBox(height: 16),
                _buildEfbButton("Close All Doors", widget.onCloseAllDoors,
                    Icons.lock_outline),
              ],
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  // ---------------------------------------------------------
  // 2. قسم الخدمات الأرضية (خاص بكود البايثون فقط)
  // ---------------------------------------------------------
  Widget _buildEquipmentPanel() {
    return Container(
      decoration: BoxDecoration(
        color: panelColor,
        border: Border.all(color: borderColor.withOpacity(0.5), width: 2),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.airport_shuttle, color: borderColor, size: 28),
                const SizedBox(width: 8),
                const Text(
                  "GROUND SERVICES",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.5,
                  ),
                ),
              ],
            ),
          ),
          Divider(color: borderColor.withOpacity(0.3), height: 1),
          const SizedBox(height: 24),

          // أزرار المعدات الأرضية مستخرجة من كود البايثون فقط
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              children: [
                _buildEfbButton("Toggle Jetway", widget.onToggleJetway,
                    Icons.compare_arrows),
                const SizedBox(height: 16),
                _buildEfbButton("Toggle Baggage Carts", widget.onToggleBaggage,
                    Icons.luggage),
                const SizedBox(height: 16),
                _buildEfbButton("Toggle Catering Truck",
                    widget.onToggleCatering, Icons.restaurant),
                const SizedBox(height: 16),
                _buildEfbButton("Toggle External Power (GPU)",
                    widget.onToggleGPU, Icons.power),
                const SizedBox(height: 16),
                _buildEfbButton("Request Fuel Truck", widget.onRequestFuel,
                    Icons.local_gas_station),
              ],
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  // ---------------------------------------------------------
  // تصميم الأزرار (باللون الأبيض كما طلبت وبحجم كامل للترتيب)
  // ---------------------------------------------------------
  Widget _buildEfbButton(
      String text, Future Function()? action, IconData icon) {
    return InkWell(
      onTap: action == null ? null : () => action(),
      borderRadius: BorderRadius.circular(8),
      splashColor: borderColor.withOpacity(0.3),
      child: Container(
        width: double.infinity, // الزر يأخذ العرض بالكامل ليكون مرتب
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.4),
          border: Border.all(color: borderColor.withOpacity(0.8), width: 1.5),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Icon(icon, color: borderColor, size: 22),
            const SizedBox(width: 16),
            Text(
              text,
              style: TextStyle(
                color: borderColor,
                fontSize: 16,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
