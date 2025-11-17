// lib/screens/ac_control_screen.dart

import 'dart:async';
import 'dart:convert';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http; // --- ADDED: For making HTTP requests
import 'mqtt_service.dart';
// import 's3_service.dart'; // --- REMOVED: No longer needed for this implementation

/// --------------------------------------------------------------------------
/// AC Control Screen (UI and State Management)
/// --------------------------------------------------------------------------
class AcControlScreen extends StatefulWidget {
  const AcControlScreen({super.key});

  @override
  State<AcControlScreen> createState() => _AcControlScreenState();
}

class _AcControlScreenState extends State<AcControlScreen> {
  final MqttService _mqttService = MqttService();
  // final S3Service _s3Service = S3Service(); // --- REMOVED

  Map<String, dynamic> _latestData = {};
  bool _isConnected = false;
  bool _isSwitching = false;

  StreamSubscription? _dataSub;
  StreamSubscription? _connectionSub;
  Timer? _refreshTimer;

  late Future<String> _predictionFuture;

  @override
  void initState() {
    super.initState();
    _connectionSub =
        _mqttService.connectionStateStream.listen((status) {
      if (mounted) setState(() => _isConnected = status);
    });

    _dataSub = _mqttService.dataStream.listen((data) {
      if (mounted && data.containsKey('relay')) {
        setState(() {
          _latestData = data;
          _isSwitching = false;
        });
      }
    });

    _mqttService.connect();
    _predictionFuture = _fetchLatestPrediction();

    _refreshTimer = Timer.periodic(const Duration(seconds: 30), (timer) {
      safePrint("⏱️ Auto-refreshing prediction data...");
      _fetchLatestPredictionAndRefreshUi();
    });
  }

  // --- MODIFIED: Fetches prediction data directly from a static URL ---
  Future<String> _fetchLatestPrediction() async {
    // NOTE: This URL is for testing purposes. It will eventually expire.
    // In a production app, this URL should be fetched dynamically and securely from a backend.
    const String predictionUrl =
        'https://pzem-data-storage.s3.us-east-1.amazonaws.com/prediction/1758976869508.json?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=AKIA3VE5LTDRPSTEHDML%2F20250928%2Fus-east-1%2Fs3%2Faws4_request&X-Amz-Date=20250928T015615Z&X-Amz-Expires=172800&X-Amz-SignedHeaders=host&X-Amz-Signature=84e0e30a8859224b197e1ef467a2dbe0f245f1093f8ec0a69ff0ca470d8ddc98';

    try {
      final response = await http.get(Uri.parse(predictionUrl));
      if (response.statusCode == 200) {
        // Successfully fetched the data.
        return response.body;
      } else {
        // If the server did not return a 200 OK response, throw an exception.
        throw Exception('Failed to load prediction data. Status Code: ${response.statusCode}');
      }
    } catch (e) {
      // Catch any network or other errors.
      throw Exception('Failed to fetch prediction data: $e');
    }
  }

  void _fetchLatestPredictionAndRefreshUi() {
    if (mounted) {
      setState(() {
        _predictionFuture = _fetchLatestPrediction();
      });
    }
  }

  Future<void> _refreshConnection() async {
    _mqttService.disconnect();
    await Future.delayed(const Duration(milliseconds: 500));
    await _mqttService.connect();
    _fetchLatestPredictionAndRefreshUi();
    if (mounted) {
      setState(() {
      });
    }
  }

  void _toggleRelay() {
    if (_isSwitching) return;
    setState(() => _isSwitching = true);

    final currentState =
        _latestData['relay']?.toString().toUpperCase() ?? 'OFF';
    final command = currentState == 'ON' ? 'off' : 'on';
    _mqttService.publishCommand(command);
  }

  @override
  void dispose() {
    _dataSub?.cancel();
    _connectionSub?.cancel();
    _refreshTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final String status =
        _latestData['relay']?.toString().toUpperCase() ?? '---';
    final bool isOn = status == 'ON';

    return Scaffold(
      backgroundColor: const Color(0xFFF0F4F8),
      appBar: AppBar(
        title: const Text("Air Conditioner"),
        backgroundColor: Colors.white,
        elevation: 1,
        shadowColor: Colors.black26,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded, color: Colors.black54),
            onPressed: _refreshConnection,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: _isConnected && !_isSwitching ? _toggleRelay : null,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                width: 180,
                height: 180,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: isOn
                          ? Colors.blue.withOpacity(0.3)
                          : Colors.black.withOpacity(0.1),
                      blurRadius: 20,
                      spreadRadius: 5,
                    )
                  ],
                  border: Border.all(
                      color: isOn
                          ? Colors.blue.shade300
                          : Colors.grey.shade300,
                      width: 4),
                ),
                child: Center(
                  child: _isSwitching
                      ? const CircularProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.blue),
                        )
                      : Icon(Icons.power_settings_new_rounded,
                          size: 80,
                          color: _isConnected
                              ? (isOn
                                  ? Colors.blue
                                  : Colors.grey.shade500)
                              : Colors.grey.shade300),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              _isSwitching ? 'Switching...' : 'Status: $status',
              style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: isOn ? Colors.blue.shade700 : Colors.black54),
            ),
            const SizedBox(height: 32),
            FutureBuilder<String>(
              future: _predictionFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Text(
                    "Error: ${snapshot.error}",
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.red),
                  );
                } else if (snapshot.hasData && snapshot.data != null) {
                  try {
                    final Map<String, dynamic> data =
                        jsonDecode(snapshot.data!);
                    return _buildPredictionCard(data);
                  } catch (e) {
                    return Text("Error parsing JSON: $e");
                  }
                }
                return const Text("No prediction data available.");
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPredictionCard(Map<String, dynamic> data) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Prediction Details",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const Divider(),
            _buildTableRow("Efficiency", data["efficiency"].toString()),
            _buildTableRow("Diagnosis", (data["diagnosis"] as List).join(", ")),
            _buildTableRow("CO₂ Emission (kg)", data["CO2_Emission_kg"].toString()),
            _buildTableRow("Projected Bill (₹)", data["projected_bill_28days_₹"].toString()),
            _buildTableRow("Processed Time", data["processed_timestamp"].toString()),
            _buildTableRow("Node ID", data["nodeid"].toString()),
            _buildTableRow("Original File", data["original_file"].toString()),
          ],
        ),
      ),
    );
  }

  Widget _buildTableRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black87),
            ),
          ),
          Expanded(
            flex: 4,
            child: Text(
              value,
              style: const TextStyle(color: Colors.black87),
            ),
          ),
        ],
      ),
    );
  }
}

