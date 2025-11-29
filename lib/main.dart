import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

// ========================== APP ROOT ==========================

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isLoggedIn = false;

  @override
  void initState() {
    super.initState();
    _checkLogin();
  }

  void _checkLogin() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      isLoggedIn = prefs.getBool("isLoggedIn") ?? false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: isLoggedIn ? const TripInputPage() : const RegisterPage(),
    );
  }
}

// ========================== PAGE 1: REGISTRATION ==========================

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  void _register(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool("isLoggedIn", true);

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const TripInputPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final nameCtrl = TextEditingController();
    final phoneCtrl = TextEditingController();
    final emailCtrl = TextEditingController();

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.deepPurple, Colors.blue],
          ),
        ),
        child: Center(
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            margin: const EdgeInsets.all(20),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text("User Registration",
                      style:
                          TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 20),
                  TextField(controller: nameCtrl, decoration: const InputDecoration(labelText: "Name")),
                  TextField(controller: phoneCtrl, decoration: const InputDecoration(labelText: "Phone")),
                  TextField(controller: emailCtrl, decoration: const InputDecoration(labelText: "Email")),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => _register(context),
                      child: const Text("REGISTER"),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ========================== PAGE 2: SOURCE / DESTINATION / TIME ==========================

class TripInputPage extends StatefulWidget {
  const TripInputPage({super.key});

  @override
  State<TripInputPage> createState() => _TripInputPageState();
}

class _TripInputPageState extends State<TripInputPage> {
  final sourceCtrl = TextEditingController();
  final destinationCtrl = TextEditingController();
  final timeCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Trip Details")),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.orange, Colors.pink],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              TextField(
                controller: sourceCtrl,
                decoration: const InputDecoration(
                  labelText: "Source",
                  filled: true,
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: destinationCtrl,
                decoration: const InputDecoration(
                  labelText: "Destination",
                  filled: true,
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: timeCtrl,
                decoration: const InputDecoration(
                  labelText: "Preferred Time (e.g. 9:00 AM)",
                  filled: true,
                ),
              ),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.directions_bus),
                  label: const Text("CHECK LIVE KSRTC BUSES"),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const KsrtcWebViewPage(),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ========================== PAGE 3: KSRTC LIVE WEBSITE ==========================

class KsrtcWebViewPage extends StatelessWidget {
  const KsrtcWebViewPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Live KSRTC Timetable"),
        backgroundColor: Colors.red,
        actions: [
          IconButton(
            icon: const Icon(Icons.map),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const LiveTrackingPage()),
              );
            },
          )
        ],
      ),
      body: const WebView(
        initialUrl:
            "https://ksrtc.karnataka.gov.in/49/Time%20Table/en",
        javascriptMode: JavascriptMode.unrestricted,
      ),
    );
  }
}

// ========================== PAGE 4: LIVE MAP TRACKING ==========================

class LiveTrackingPage extends StatefulWidget {
  const LiveTrackingPage({super.key});

  @override
  State<LiveTrackingPage> createState() => _LiveTrackingPageState();
}

class _LiveTrackingPageState extends State<LiveTrackingPage> {
  final MapController mapController = MapController();

  LatLng sourcePoint = const LatLng(12.9716, 77.5946); // Bangalore
  LatLng destinationPoint = const LatLng(13.0358, 77.5970); // Hebbal

  double busLat = 12.9716;
  double busLng = 77.5946;

  double distanceKm = 18;
  double etaMin = 45;

  late Timer timer;

  @override
  void initState() {
    super.initState();
    _startBus();
  }

  void _startBus() {
    timer = Timer.periodic(const Duration(seconds: 3), (timer) {
      setState(() {
        busLat += 0.001;
        busLng += 0.001;

        distanceKm -= 0.5;
        etaMin -= 1;

        mapController.move(LatLng(busLat, busLng), 14);

        double dist = (busLat - destinationPoint.latitude).abs() +
            (busLng - destinationPoint.longitude).abs();

        if (dist < 0.003) {
          timer.cancel();
          etaMin = 0;
        }
      });
    });
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Live Bus Tracking")),
      body: Column(
        children: [
          Card(
            margin: const EdgeInsets.all(10),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Distance: ${distanceKm.toStringAsFixed(1)} km"),
                  Text("ETA: ${etaMin.toStringAsFixed(0)} min"),
                ],
              ),
            ),
          ),
          Expanded(
            child: FlutterMap(
              mapController: mapController,
              options: MapOptions(
                initialCenter: sourcePoint,
                initialZoom: 14,
              ),
              children: [
                TileLayer(
                  urlTemplate:
                      "https://tile.openstreetmap.fr/hot/{z}/{x}/{y}.png",
                ),
                PolylineLayer(
                  polylines: [
                    Polyline(
                      points: [sourcePoint, destinationPoint],
                      strokeWidth: 4,
                      color: Colors.blue,
                    ),
                  ],
                ),
                MarkerLayer(
                  markers: [
                    Marker(
                      point: LatLng(busLat, busLng),
                      width: 40,
                      height: 40,
                      child: const Icon(Icons.directions_bus,
                          color: Colors.red, size: 36),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
