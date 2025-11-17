// lib/services/mqtt_service.dart

import 'dart:async';
import 'dart:convert';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

/// --------------------------------------------------------------------------
/// MQTT Service (Handles real-time communication)
/// --------------------------------------------------------------------------
class MqttService {
  static final MqttService _instance = MqttService._internal();
  factory MqttService() => _instance;
  MqttService._internal();

  final String _broker = "broker.hivemq.com";
  final String _topicStatus = "pzem/relay/status";
  final String _topicPublish = "pzem/control";

  late MqttServerClient _client;
  final StreamController<Map<String, dynamic>> _dataStreamController =
      StreamController.broadcast();
  final StreamController<bool> _connectionStateController =
      StreamController.broadcast();

  Stream<Map<String, dynamic>> get dataStream => _dataStreamController.stream;
  Stream<bool> get connectionStateStream => _connectionStateController.stream;

  bool _isConnected = false;
  bool get isConnected => _isConnected;

  Future<void> connect() async {
    if (_isConnected) {
      _connectionStateController.add(true);
      return;
    }

    final clientIdentifier =
        "flutter-ac-client-${DateTime.now().millisecondsSinceEpoch}";
    _client = MqttServerClient(_broker, clientIdentifier);
    _client.port = 1883;
    _client.keepAlivePeriod = 30;
    _client.onConnected = _onConnected;
    _client.onDisconnected = _onDisconnected;
    _client.onSubscribed = _onSubscribed;
    _client.autoReconnect = true;

    try {
      await _client.connect();
    } catch (e) {
      _client.disconnect();
    }
  }

  void _onConnected() {
    _isConnected = true;
    _connectionStateController.add(true);
    _client.subscribe(_topicStatus, MqttQos.atMostOnce);

    _client.updates?.listen((c) {
      final recMess = c[0].payload as MqttPublishMessage;
      final String payload =
          MqttPublishPayload.bytesToStringAsString(recMess.payload.message);
      try {
        final data = json.decode(payload);
        _dataStreamController.add(data);
      } catch (_) {}
    });
  }

  void _onDisconnected() {
    _isConnected = false;
    _connectionStateController.add(false);
  }

  void _onSubscribed(String topic) {}

  void publishCommand(String command) {
    if (_isConnected) {
      final builder = MqttClientPayloadBuilder();
      builder.addString(command);
      _client.publishMessage(
          _topicPublish, MqttQos.atLeastOnce, builder.payload!);
    }
  }

  void disconnect() {
    if (_isConnected) {
      _client.disconnect();
    }
  }
}