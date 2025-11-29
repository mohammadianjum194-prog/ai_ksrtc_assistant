import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'map.dart';

class ResultScreen extends StatefulWidget {
  final String source;
  final String destination;
  final String time;

  const ResultScreen({
    super.key,
    required this.source,
    required this.destination,
    required this.time,
  });

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  List allBuses = [];
  List filteredBuses = [];

  @override
  void initState() {
    super.initState();
    loadBusData();
  }

  Future<void> loadBusData() async {
    final data = await rootBundle.loadString('assets/ksrtc_buses.json');
    final jsonResult = json.decode(data);

    setState(() {
      allBuses = jsonResult;

      filteredBuses = allBuses.where((bus) {
        return bus["source"]
                .toString()
                .toLowerCase()
                .contains(widget.source.toLowerCase()) ||
            bus["destination"]
                .toString()
                .toLowerCase()
                .contains(widget.destination.toLowerCase());
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Available KSRTC Buses"),
        backgroundColor: Colors.red,
      ),
      body: filteredBuses.isEmpty
          ? const Center(
              child: Text(
                "No buses found for this route 😓",
                style: TextStyle(fontSize: 16),
              ),
            )
          : ListView.builder(
              itemCount: filteredBuses.length,
              itemBuilder: (context, index) {
                final bus = filteredBuses[index];

                return Card(
                  child: ListTile(
                    leading: const Icon(Icons.directions_bus,
                        color: Colors.red),
                    title: Text("Bus No: ${bus["bus_no"]}"),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("From: ${bus["source"]}"),
                        Text("To: ${bus["destination"]}"),
                        Text("Arrival Time: ${bus["arrival"]}"),
                      ],
                    ),
                    trailing: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => MapScreen(
                              source: bus["source"],
                              destination: bus["destination"],
                              time: bus["arrival"],
                            ),
                          ),
                        );
                      },
                      child: const Text("Track"),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
