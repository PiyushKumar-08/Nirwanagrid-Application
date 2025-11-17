// lib/models/appliance_model.dart

import 'package:flutter/material.dart';

// A map to easily select and save icons for our appliances
const Map<String, IconData> availableIcons = {
  'AC': Icons.ac_unit,
  'Fridge': Icons.kitchen,
  'Light': Icons.lightbulb_outline,
  'TV': Icons.tv,
  'Fan': Icons.air_outlined,
  'Washer': Icons.local_laundry_service,
  'Oven': Icons.microwave,
  'Generic': Icons.devices,
};

// Data model for a single appliance
class Appliance {
  String id;
  String name;
  String iconName;
  bool isOn;

  Appliance({
    required this.id,
    required this.name,
    this.iconName = 'Generic',
    this.isOn = false,
  });

  // Methods to convert our object to and from a map for JSON storage
  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'iconName': iconName,
        'isOn': isOn,
      };

  factory Appliance.fromJson(Map<String, dynamic> json) => Appliance(
        id: json['id'],
        name: json['name'],
        iconName: json['iconName'],
        isOn: json['isOn'],
      );
}