import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class MapScreen extends StatefulWidget {
  final String source;
  final String destination;
  final String time;

  const MapScreen({
    super.key,
    required this.source,
    required this.destination,
    required this.time,
  });

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  LatLng busPosition = LatLng(12.9716, 77.5946); // Start Bengaluru
  Timer? timer;

  @override
  void initState() {
    super.initState();
    startBusMovement();
  }

  void startBusMovement() {
    timer = Timer.periodic(const Duration(seconds: 2), (timer) {
      setState(() {
        busPosition = LatLng(
          busPosition.latitude + 0.0015,
          busPosition.longitude + 0.0015,
        );
      });
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Live Bus Tracking (Simulated)"),
        backgroundColor: Colors.red,
      ),
      body: FlutterMap(
        options: MapOptions(
          center: busPosition,
          zoom: 13,
        ),
        children: [
          TileLayer(
            urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
          ),
          MarkerLayer(
            markers: [
              Marker(
                point: busPosition,
                width: 60,
                height: 60,
                child: const Icon(
                  Icons.directions_bus,
                  color: Colors.red,
                  size: 40,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

