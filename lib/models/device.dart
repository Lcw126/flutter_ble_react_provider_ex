import 'dart:typed_data';

import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';

class Device {
  final String id;
  final String name;
  final Map<Uuid, Uint8List> serviceData;
  final Uint8List manufacturerData;
  final int rssi;

  Device({this.id, this.name,this.serviceData,this.manufacturerData,this.rssi});

}