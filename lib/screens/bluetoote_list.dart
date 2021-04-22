import 'package:flutter/material.dart';
import 'package:flutter_react_ble_provider_ex/models/bluetooth_device_data.dart';
import 'package:flutter_react_ble_provider_ex/util/permission_check.dart';
import 'package:flutter_react_ble_provider_ex/widgetStyle.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:provider/provider.dart';
import 'package:flutter_react_ble_provider_ex/widgets/device_list.dart';

class BluetoothList extends StatefulWidget {
  @override
  _BluetoothListState createState() => _BluetoothListState();
}

class _BluetoothListState extends State<BluetoothList> {
  @override
  void initState() {
    checkPermissions(); //  permission check
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final flutterReactiveBle = FlutterReactiveBle();
    return Scaffold(
      appBar: AppBar(
        title: Text('AppBar Title'),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () async {

                    Provider.of<BluetoothDeviceData>(context, listen: false)
                        .clearDevice();

                    flutterReactiveBle.scanForDevices().listen((device) {
                      final knownDeviceIndex = Provider.of<BluetoothDeviceData>(
                              context,
                              listen: false)
                          .devices
                          .indexWhere((d) => d.id == device.id);
                      if (knownDeviceIndex >= 0) {
                        Provider.of<BluetoothDeviceData>(context, listen: false)
                            .changeDevice(knownDeviceIndex, device);
                      } else {
                        Provider.of<BluetoothDeviceData>(context, listen: false)
                            .addDevice(device);
                      }
                    },
                        onError: (e) =>
                            print('Device scan fails with error: $e'));
                  },
                  style: textButtonStyle,
                  child: Text('Scan'),
                ),
                ElevatedButton(
                  onPressed: (){
                    //TODO: 스캔 멈춤 기능 추가
                  },
                  style: textButtonStyle,
                  child: Text('Stop'),
                ),
                Text(
                  'count:${Provider.of<BluetoothDeviceData>(context,).deviceCount}',
                ),
              ],
            ),
            Expanded(child: DevicesList()),
          ],
        ),
      ),
    );
  }
}
