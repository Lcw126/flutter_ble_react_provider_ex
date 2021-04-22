import 'dart:collection';
import 'package:flutter/cupertino.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';

class BluetoothDeviceData extends ChangeNotifier {
  List<DiscoveredDevice> _devices = [];

  void addDevice(DiscoveredDevice newDevice) {
    _devices.add(newDevice);
    notifyListeners();
  }

  void changeDevice(int index, DiscoveredDevice changeDevice) {
    _devices[index] = changeDevice;
    notifyListeners();
  }

  void clearDevice() {
    _devices.clear();
    notifyListeners();
  }

  int get deviceCount {
    return _devices.length;
  }

  UnmodifiableListView<DiscoveredDevice> get devices {
    return UnmodifiableListView(_devices);
  }
}
