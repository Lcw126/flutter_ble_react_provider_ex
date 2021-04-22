import 'package:flutter/material.dart';
import 'package:flutter_react_ble_provider_ex/models/bluetooth_device_data.dart';
import 'package:flutter_react_ble_provider_ex/widgets/deviceTile.dart';
import 'package:provider/provider.dart';

class DevicesList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<BluetoothDeviceData>(
      builder: (context, DeviceData, child) {
        return ListView.builder(
          itemBuilder: (context, index) {
            final device = DeviceData.devices[index];
            return DeviceTile(
              id: device.id,
              name: device.name,
              rssi: device.rssi,
            );
          },
          itemCount: DeviceData.deviceCount,
        );
      },
    );
  }
}
