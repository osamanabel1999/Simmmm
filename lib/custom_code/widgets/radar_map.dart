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

import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart' as ll;
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:math' as math;

class RadarMap extends StatefulWidget {
  const RadarMap({
    Key? key,
    this.width,
    this.height,
    this.userNetworkId, // <-- تم إضافة متغير الآي دي الخاص باليوزر هنا
  }) : super(key: key);

  final double? width;
  final double? height;
  final String? userNetworkId; // <-- لاستقبال الآي دي من الـ App State

  @override
  _RadarMapState createState() => _RadarMapState();
}

class _RadarMapState extends State<RadarMap> {
  List<Marker> _planeMarkers = [];
  List<Marker> _airportMarkers = [];
  bool showVatsim = true;
  bool showIvao = true;
  bool showAirports = false; // <-- تم تغيير الافتراضي ليكون مقفول
  bool showCallsigns = false;
  bool showRadarMode = false;

  bool showLeftMenu = false;
  bool showRightMenu = false;
  String currentMapStyle =
      'https://{s}.basemaps.cartocdn.com/dark_all/{z}/{x}/{y}{r}.png';

  // --- متغير جديد للتحكم في طبقة الطقس (مطر، حرارة، رياح) ---
  String activeWeatherLayer = 'NONE';

  final MapController _mapController = MapController();
  Map<String, dynamic>? selectedItem;
  Timer? _refreshTimer;
  Timer? _clockTimer; // <-- مؤقت لتحديث ساعة الزولو
  String zuluTime = ""; // <-- متغير لتخزين الوقت

  @override
  void initState() {
    super.initState();
    _updateClock(); // تشغيل الساعة فوراً
    _clockTimer =
        Timer.periodic(const Duration(seconds: 1), (_) => _updateClock());
    _refreshTimer =
        Timer.periodic(const Duration(seconds: 30), (_) => _fetchPlanes());
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchPlanes();
      _fetchAirports();
    });
  }

  @override
  void dispose() {
    _clockTimer?.cancel(); // إيقاف الساعة عند الخروج
    _refreshTimer?.cancel();
    super.dispose();
  }

  // --- دالة تحديث توقيت الزولو ---
  void _updateClock() {
    final now = DateTime.now().toUtc();
    if (mounted) {
      setState(() {
        zuluTime =
            "${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}:${now.second.toString().padLeft(2, '0')} ZULU";
      });
    }
  }

  // --- دالة مساعدة للحصول على رابط الطقس المناسب ---
  String _getWeatherUrl(String type) {
    const apiKey = "d2b9c49baa0f1dac5a0dada3a4c94cc1";
    if (type == 'RAIN')
      return "https://tile.openweathermap.org/map/precipitation_new/{z}/{x}/{y}.png?appid=$apiKey";
    if (type == 'TEMP')
      return "https://tile.openweathermap.org/map/temp_new/{z}/{x}/{y}.png?appid=$apiKey";
    if (type == 'WIND')
      return "https://tile.openweathermap.org/map/wind_new/{z}/{x}/{y}.png?appid=$apiKey";
    return "";
  }

  Future<void> _fetchAirports() async {
    try {
      final response = await http.get(Uri.parse(
          'https://gist.githubusercontent.com/tdreyno/4278655/raw/airports.json'));
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          _airportMarkers = data
              .map((ap) => Marker(
                    point: ll.LatLng(double.parse(ap['lat'].toString()),
                        double.parse(ap['lon'].toString())),
                    width: 80, // تم تكبير المساحة لاحتواء الدائرة والنص
                    height: 60,
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () => setState(() => selectedItem = {
                            'type': 'AIRPORT', // تحديد النوع كمطار
                            'data': ap,
                          }),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // الدائرة المميزة للمطار
                          Container(
                            width: 14,
                            height: 14,
                            decoration: BoxDecoration(
                              color: Colors.purpleAccent, // لون مميز للمطارات
                              shape: BoxShape.circle,
                              border:
                                  Border.all(color: Colors.white, width: 1.5),
                              boxShadow: const [
                                BoxShadow(
                                  color: Colors.black54,
                                  blurRadius: 2.0,
                                  offset: Offset(1.0, 1.0),
                                )
                              ],
                            ),
                          ),
                          const SizedBox(height: 2),
                          // نص الإيكاو تحت الدائرة
                          Text(
                            ap['icao']?.toString() ?? '',
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                shadows: [
                                  Shadow(
                                    blurRadius: 2.0,
                                    color: Colors.black,
                                    offset: Offset(1.0, 1.0),
                                  ),
                                ]),
                          ),
                        ],
                      ),
                    ),
                  ))
              .toList();
        });
      }
    } catch (e) {}
  }

  Future<void> _fetchPlanes() async {
    List<Marker> tempPlanes = [];
    if (showVatsim) {
      try {
        final res = await http
            .get(Uri.parse('https://data.vatsim.net/v3/vatsim-data.json'));
        if (res.statusCode == 200) {
          final pilots = json.decode(res.body)['pilots'] as List;
          for (var p in pilots)
            tempPlanes.add(_buildPlaneMarker(p, Colors.amber, "VATSIM", true));
        }
      } catch (e) {}
    }
    if (showIvao) {
      try {
        final res = await http
            .get(Uri.parse('https://api.ivao.aero/v2/tracker/whazzup'));
        if (res.statusCode == 200) {
          final pilots = json.decode(res.body)['clients']['pilots'] as List;
          for (var p in pilots)
            tempPlanes
                .add(_buildPlaneMarker(p, Colors.greenAccent, "IVAO", false));
        }
      } catch (e) {}
    }
    if (mounted) setState(() => _planeMarkers = tempPlanes);
  }

  Marker _buildPlaneMarker(
      dynamic p, Color baseColor, String net, bool isVatsim) {
    double lat = isVatsim
        ? (p['latitude'] ?? 0.0).toDouble()
        : (p['lastTrack']?['latitude'] ?? 0.0).toDouble();
    double lon = isVatsim
        ? (p['longitude'] ?? 0.0).toDouble()
        : (p['lastTrack']?['longitude'] ?? 0.0).toDouble();
    double hdg = isVatsim
        ? (p['heading'] ?? 0.0).toDouble()
        : (p['lastTrack']?['heading'] ?? 0.0).toDouble();
    String callsign = p['callsign'] ?? "N/A";

    int alt = isVatsim
        ? (p['altitude'] ?? 0).toInt()
        : (p['lastTrack']?['altitude'] ?? 0).toInt();
    int gs = isVatsim
        ? (p['groundspeed'] ?? 0).toInt()
        : (p['lastTrack']?['groundSpeed'] ?? 0).toInt();
    int vs = isVatsim
        ? (p['vertical_speed'] ?? 0).toInt()
        : (p['lastTrack']?['verticalSpeed'] ?? 0).toInt();

    IconData trendIcon = Icons.horizontal_rule;
    if (vs > 50) {
      trendIcon = Icons.arrow_upward;
    } else if (vs < -50) {
      trendIcon = Icons.arrow_downward;
    }

    // --- كود الصياعة: تحديد ما إذا كانت الطيارة تخص المستخدم ---
    String planeId =
        isVatsim ? p['cid']?.toString() ?? "" : p['userId']?.toString() ?? "";

    Color markerColor = baseColor;
    bool isUserPlane = false;

    // لو الآي دي موجود في التطبيق وبيطابق آي دي الطيارة، غير اللون لوردي فسفوري
    if (widget.userNetworkId != null &&
        widget.userNetworkId!.isNotEmpty &&
        planeId == widget.userNetworkId) {
      markerColor = Colors.redAccent;
      isUserPlane = true;
    }
    // ------------------------------------------------------------

    return Marker(
      point: ll.LatLng(lat, lon),
      width: showRadarMode ? 160 : 80,
      height: showRadarMode ? 80 : 60,
      child: showRadarMode
          ? Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () => setState(() => selectedItem = {
                        'type': 'PLANE',
                        'data': p,
                        'net': net,
                        'isVatsim': isVatsim
                      }),
                  child: Transform.rotate(
                      angle: hdg * (math.pi / 180),
                      child: Icon(Icons.airplanemode_active,
                          color: markerColor, size: isUserPlane ? 26 : 22)),
                ),
                const SizedBox(width: 4),
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.black87,
                    border: Border.all(
                        color: markerColor, width: isUserPlane ? 2 : 1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(callsign,
                          style: TextStyle(
                              color: markerColor,
                              fontSize: 10,
                              fontWeight: FontWeight.bold)),
                      Text("ALT: $alt | HDG: ${hdg.toInt()}°",
                          style: const TextStyle(
                              color: Colors.white, fontSize: 9)),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text("GS: $gs | VS: $vs ",
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 9)),
                          Icon(trendIcon, color: markerColor, size: 10),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            )
          : Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (showCallsigns)
                  Text(
                    callsign,
                    style: TextStyle(
                      color: markerColor,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      shadows: const [
                        Shadow(
                          blurRadius: 2.0,
                          color: Colors.black,
                          offset: Offset(1.0, 1.0),
                        ),
                      ],
                    ),
                  ),
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () => setState(() => selectedItem = {
                        'type': 'PLANE',
                        'data': p,
                        'net': net,
                        'isVatsim': isVatsim
                      }),
                  child: Transform.rotate(
                      angle: hdg * (math.pi / 180),
                      child: Icon(Icons.airplanemode_active,
                          color: markerColor, size: isUserPlane ? 26 : 22)),
                ),
              ],
            ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        FlutterMap(
          mapController: _mapController,
          options: MapOptions(
              initialCenter: ll.LatLng(30.0, 31.0),
              initialZoom: 7,
              onTap: (_, __) => setState(() => selectedItem = null)),
          children: [
            // طبقة الخريطة الأساسية
            TileLayer(
                urlTemplate: currentMapStyle, subdomains: ['a', 'b', 'c', 'd']),

            // طبقة الطقس (تظهر فقط إذا تم اختيار نوع طقس) وتكون فوق الخريطة وتحت المطارات
            if (activeWeatherLayer != 'NONE')
              Opacity(
                opacity: 1.0, // الشفافية هنا بتشتغل على أي ويدجت
                child: TileLayer(
                  urlTemplate: _getWeatherUrl(activeWeatherLayer),
                ),
              ),

            if (showAirports) MarkerLayer(markers: _airportMarkers),
            MarkerLayer(markers: _planeMarkers),
          ],
        ),

        // --- ساعة الزولو (Zulu Time) فوق خالص على اليمين ---
        Positioned(
          top: 15,
          right: 10,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.black
                  .withOpacity(0.7), // خلي الأسود شفاف شوية عشان يبان زجاجي
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: const Color(0xFF00E5FF)
                    .withOpacity(0.5), // نفس لون الخط بس شفاف
                width: 1.5,
              ),
            ),
            child: Text(
              zuluTime,
              style: const TextStyle(
                color: Color(0xFF00E5FF),
                fontSize: 14,
                fontWeight: FontWeight.bold,
                fontFamily: 'monospace',
                shadows: [
                  Shadow(
                    blurRadius: 5,
                    color: Color(0xFF00E5FF),
                  ),
                ],
              ),
            ),
          ),
        ),

        // --- القائمة اللي على الشمال ---
        Positioned(
          top: 65, // <-- نزلناها شوية عشان التناسق
          left: 10,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (showLeftMenu)
                Container(
                  width: 110,
                  decoration: BoxDecoration(
                      color: Colors.black87,
                      border: Border.all(color: Colors.white24)),
                  child: Column(mainAxisSize: MainAxisSize.min, children: [
                    _menuBtn("VATSIM", showVatsim, () {
                      setState(() => showVatsim = !showVatsim);
                      _fetchPlanes();
                    }),
                    _menuBtn("IVAO", showIvao, () {
                      setState(() => showIvao = !showIvao);
                      _fetchPlanes();
                    }),
                    _menuBtn("AIRPORT", showAirports,
                        () => setState(() => showAirports = !showAirports)),
                    _menuBtn("CALLSIGN", showCallsigns, () {
                      // <-- تم التعديل
                      setState(() => showCallsigns = !showCallsigns);
                      _fetchPlanes();
                    }),
                    _menuBtn("RADAR", showRadarMode, () {
                      setState(() => showRadarMode = !showRadarMode);
                      _fetchPlanes();
                    }),
                  ]),
                ),
              GestureDetector(
                onTap: () => setState(() => showLeftMenu = !showLeftMenu),
                child: Container(
                  margin: const EdgeInsets.only(left: 4),
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.black87,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.white24),
                  ),
                  child: Icon(
                    showLeftMenu ? Icons.chevron_left : Icons.menu,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ),
            ],
          ),
        ),

        // --- القائمة اللي على اليمين تحت الساعة ---
        Positioned(
          top: 65, // <-- نزلناها تحت الساعة بالظبط
          right: 10,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () => setState(() => showRightMenu = !showRightMenu),
                child: Container(
                  margin: const EdgeInsets.only(right: 4),
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.black87,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.white24),
                  ),
                  child: Icon(
                    showRightMenu ? Icons.chevron_right : Icons.layers,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ),
              if (showRightMenu)
                Container(
                  width: 110,
                  decoration: BoxDecoration(
                      color: Colors.black87,
                      border: Border.all(color: Colors.white24)),
                  child: Column(mainAxisSize: MainAxisSize.min, children: [
                    _menuBtn("DARK", currentMapStyle.contains('dark'), () {
                      setState(() => currentMapStyle =
                          'https://{s}.basemaps.cartocdn.com/dark_all/{z}/{x}/{y}{r}.png');
                    }),
                    _menuBtn("SATELLITE", currentMapStyle.contains('ArcGIS'),
                        () {
                      setState(() => currentMapStyle =
                          'https://server.arcgisonline.com/ArcGIS/rest/services/World_Imagery/MapServer/tile/{z}/{y}/{x}');
                    }),
                    const Divider(color: Colors.white24, height: 1), // فاصل
                    // أزرار الطقس باستخدام الدالة الجديدة ليكون لونها مختلف (برتقالي)
                    _weatherMenuBtn("RAIN", activeWeatherLayer == 'RAIN', () {
                      setState(() => activeWeatherLayer =
                          activeWeatherLayer == 'RAIN' ? 'NONE' : 'RAIN');
                    }),
                    _weatherMenuBtn("TEMP", activeWeatherLayer == 'TEMP', () {
                      setState(() => activeWeatherLayer =
                          activeWeatherLayer == 'TEMP' ? 'NONE' : 'TEMP');
                    }),
                    _weatherMenuBtn("WIND", activeWeatherLayer == 'WIND', () {
                      setState(() => activeWeatherLayer =
                          activeWeatherLayer == 'WIND' ? 'NONE' : 'WIND');
                    }),
                  ]),
                ),
            ],
          ),
        ),

        // --- عرض نوافذ المعلومات حسب العنصر المحدد (طيارة أو مطار) ---
        if (selectedItem != null && selectedItem!['type'] == 'PLANE')
          _buildInfoBox(selectedItem!['data'], selectedItem!['net'],
              selectedItem!['isVatsim']),
        if (selectedItem != null && selectedItem!['type'] == 'AIRPORT')
          _buildAirportInfoBox(selectedItem!['data']),
      ],
    );
  }

  // --- تصميم نافذة المطار لما يتم الضغط عليه ---
  Widget _buildAirportInfoBox(dynamic ap) {
    String name = ap['name'] ?? "Unknown Airport";
    String icao = ap['icao'] ?? "N/A";
    String city = ap['city'] ?? "Unknown City";
    String country = ap['country'] ?? "Unknown Country";

    return Positioned(
      bottom: 15,
      left: 10,
      right: 10,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF0F172A).withOpacity(0.95),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
              color: Colors.purpleAccent.withOpacity(0.5), width: 1.5),
        ),
        child: Row(
          children: [
            const Icon(Icons.local_airport,
                color: Colors.purpleAccent, size: 40),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(name,
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold)),
                  Text("$city, $country",
                      style:
                          const TextStyle(color: Colors.white70, fontSize: 13)),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.purpleAccent.withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(icao,
                  style: const TextStyle(
                      color: Colors.purpleAccent,
                      fontWeight: FontWeight.bold,
                      fontSize: 16)),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildInfoBox(dynamic p, String net, bool isVatsim) {
    String call = p['callsign'] ?? "N/A";
    String dep = isVatsim
        ? (p['flight_plan']?['departure'] ?? "N/A")
        : (p['flightPlan']?['departureId'] ?? "N/A");
    String arr = isVatsim
        ? (p['flight_plan']?['arrival'] ?? "N/A")
        : (p['flightPlan']?['arrivalId'] ?? "N/A");
    String acft = isVatsim
        ? (p['flight_plan']?['aircraft_short'] ?? "ACFT")
        : (p['flightPlan']?['aircraft']['icaoCode'] ?? "ACFT");

    int alt = isVatsim
        ? (p['altitude'] ?? 0).toInt()
        : (p['lastTrack']?['altitude'] ?? 0).toInt();
    int gs = isVatsim
        ? (p['groundspeed'] ?? 0).toInt()
        : (p['lastTrack']?['groundSpeed'] ?? 0).toInt();
    int vs = isVatsim
        ? (p['vertical_speed'] ?? 0).toInt()
        : (p['lastTrack']?['verticalSpeed'] ?? 0).toInt();
    int hdg = isVatsim
        ? (p['heading'] ?? 0).toInt()
        : (p['lastTrack']?['heading'] ?? 0).toInt();

    String squawk = isVatsim
        ? "${p['transponder'] ?? '7000'}"
        : "${p['lastTrack']?['squawk'] ?? '7000'}";
    String pilot =
        isVatsim ? (p['name'] ?? "Unknown Pilot") : "Pilot ID: ${p['userId']}";
    String route = isVatsim
        ? (p['flight_plan']?['route'] ?? "N/A")
        : (p['flightPlan']?['route'] ?? "N/A");

    String cleanCall = call.trim().toUpperCase();
    String icao3 = "GEN";
    final match = RegExp(r'^[A-Z]{3}').firstMatch(cleanCall);
    if (match != null) {
      icao3 = match.group(0)!;
    } else if (cleanCall.length >= 3) {
      icao3 = cleanCall.substring(0, 3);
    }
    String logoUrl =
        "https://www.flightaware.com/images/airline_logos/90p/$icao3.png";

    String startTime =
        isVatsim ? (p['logon_time'] ?? "") : (p['createdAt'] ?? "");
    int onlineMinutes = 0;
    if (startTime.isNotEmpty) {
      try {
        DateTime start = DateTime.parse(startTime);
        Duration diff = DateTime.now().toUtc().difference(start);
        onlineMinutes = diff.inMinutes;
      } catch (e) {}
    }
    String timeOnline = "${onlineMinutes ~/ 60}h ${onlineMinutes % 60}m";

    int totalPlannedMins = 0;
    if (isVatsim) {
      String enroute = p['flight_plan']?['enroute_time'] ?? "0000";
      if (enroute.length == 4) {
        int h = int.tryParse(enroute.substring(0, 2)) ?? 0;
        int m = int.tryParse(enroute.substring(2, 4)) ?? 0;
        totalPlannedMins = h * 60 + m;
      }
    } else {
      int eet = int.tryParse(p['flightPlan']?['eet']?.toString() ?? '0') ?? 0;
      totalPlannedMins = eet > 1000 ? eet ~/ 60 : eet;
    }

    double progress = 0.5;
    String remaining = "N/A";
    if (totalPlannedMins > 0 && onlineMinutes > 0) {
      progress = onlineMinutes / totalPlannedMins;
      if (progress > 1.0) progress = 1.0;
      int remMins = totalPlannedMins - onlineMinutes;
      if (remMins < 0) remMins = 0;
      remaining = "${remMins ~/ 60}h ${remMins % 60}m";
    }

    double alignX = (progress * 2) - 1.0;
    int distFlown = (gs * (onlineMinutes / 60.0)).round();

    return Positioned(
      bottom: 15,
      left: 10,
      right: 10,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF0F172A).withOpacity(0.95),
          borderRadius: BorderRadius.circular(20),
          border:
              Border.all(color: Colors.blueAccent.withOpacity(0.5), width: 1.5),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: Image.network(
                        logoUrl,
                        width: 45,
                        height: 45,
                        fit: BoxFit.contain,
                        errorBuilder: (c, e, s) => const Icon(Icons.flight,
                            color: Colors.black54, size: 40),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(call,
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold)),
                        Text(pilot,
                            style: const TextStyle(
                                color: Colors.white70, fontSize: 13)),
                        const SizedBox(height: 4),
                        Text(
                          "Total Hrs: N/A (API) | Online: $timeOnline",
                          style: const TextStyle(
                              color: Colors.blueAccent,
                              fontSize: 10,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: isVatsim
                          ? Colors.amber.withOpacity(0.15)
                          : Colors.greenAccent.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                          color: isVatsim ? Colors.amber : Colors.greenAccent),
                    ),
                    child: Text(net,
                        style: TextStyle(
                            color: isVatsim ? Colors.amber : Colors.greenAccent,
                            fontWeight: FontWeight.bold,
                            fontSize: 11)),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(dep,
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w900)),
                  const Icon(Icons.flight_takeoff,
                      color: Colors.white38, size: 16),
                  const Icon(Icons.flight_land,
                      color: Colors.white38, size: 16),
                  Text(arr,
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w900)),
                ],
              ),
              const SizedBox(height: 8),
              Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                      height: 2, width: double.infinity, color: Colors.white24),
                  Align(
                    alignment: Alignment(alignX, 0),
                    child: Transform.rotate(
                      angle: math.pi / 2,
                      child: const Icon(Icons.airplanemode_active,
                          color: Colors.blueAccent, size: 24),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Dist: $distFlown nm",
                      style:
                          const TextStyle(color: Colors.white54, fontSize: 11)),
                  Text("ETA: $remaining",
                      style:
                          const TextStyle(color: Colors.white54, fontSize: 11)),
                ],
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 12),
                child: Divider(color: Colors.white10, height: 1),
              ),
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 3,
                childAspectRatio: 2.2,
                children: [
                  _stat("GS", "$gs kts"),
                  _stat("ALT", "$alt ft"),
                  _stat("VS", "$vs fpm"),
                  _stat("HDG", "$hdg°"),
                  _stat("SQUAWK", squawk),
                  _stat("TYPE", acft),
                ],
              ),
              const SizedBox(height: 12),
              const Text("FLIGHT PLAN / ROUTE:",
                  style: TextStyle(
                      color: Colors.blueAccent,
                      fontSize: 10,
                      fontWeight: FontWeight.bold)),
              const SizedBox(height: 6),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.black26,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.white10),
                ),
                child: Text(
                  route,
                  style: const TextStyle(color: Colors.white70, fontSize: 12),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _stat(String l, String v) => Column(
        children: [
          Text(l, style: const TextStyle(color: Colors.white38, fontSize: 9)),
          Text(v,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.bold)),
        ],
      );

  // زرار القوائم العادية (لونه أزرق)
  Widget _menuBtn(String label, bool active, VoidCallback onTap) => InkWell(
      onTap: onTap,
      child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 12),
          color: active ? Colors.blue.withOpacity(0.2) : Colors.transparent,
          child: Center(
              child: Text(label,
                  style: TextStyle(
                      color: active ? Colors.blueAccent : Colors.white,
                      fontSize: 9,
                      fontWeight: FontWeight.bold)))));

  // زرار جديد مخصص للطقس (لونه برتقالي للتمييز)
  Widget _weatherMenuBtn(String label, bool active, VoidCallback onTap) =>
      InkWell(
          onTap: onTap,
          child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 12),
              color:
                  active ? Colors.orange.withOpacity(0.2) : Colors.transparent,
              child: Center(
                  child: Text(label,
                      style: TextStyle(
                          color: active ? Colors.orangeAccent : Colors.white,
                          fontSize: 9,
                          fontWeight: FontWeight.bold)))));
}
