import 'package:flutter/material.dart';
import 'package:flutter_react_ble_provider_ex/util/Dynamixel.dart';
import 'package:flutter_react_ble_provider_ex/widgetStyle.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';


class DeviceDetail extends StatefulWidget {
  @override
  _DeviceDetailState createState() => _DeviceDetailState();
}

class _DeviceDetailState extends State<DeviceDetail> {
  final FlutterReactiveBle flutterReactiveBle = FlutterReactiveBle();

  final String foundDeviceId = 'DB:E7:DF:00:1A:BC';
  final Uuid serviceId = Uuid.parse('6e400001-b5a3-f393-e0a9-e50e24dcca9e');
  final Uuid subscribeCharacteristicUuid =
      Uuid.parse('6e400003-b5a3-f393-e0a9-e50e24dcca9e');
  final Uuid writeCharacteristicUuid =
      Uuid.parse('6e400002-b5a3-f393-e0a9-e50e24dcca9e');

  String readResponse = '';
  bool isRead = false;

  @override
  void initState() {
    subscribe();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    //TODO: 연결 해제 기능 추가
    print('dispose');
  }

  @override
  Widget build(BuildContext context) {
    final QualifiedCharacteristic writeCharacteristic = QualifiedCharacteristic(
        serviceId: serviceId,
        characteristicId: writeCharacteristicUuid,
        deviceId: foundDeviceId);

    return Scaffold(
      appBar: AppBar(
        title: Text('AppBar Title'),
    ),
    body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () async {
                  List<int> data =
                      Dynamixel.writeBytePacket(200, 79, 1); //  led on packet
                  await flutterReactiveBle.writeCharacteristicWithResponse(
                      writeCharacteristic,
                      value: data);
                },
                style: textButtonStyle,
                child: Text('On'),
              ),
              ElevatedButton(
                onPressed: () async {
                  List<int> data =
                      Dynamixel.writeBytePacket(200, 79, 0); //  led off packet
                  await flutterReactiveBle.writeCharacteristicWithResponse(
                      writeCharacteristic,
                      value: data);
                },
                style: textButtonStyle,
                child: Text('Off'),
              ),
              ElevatedButton(
                onPressed: () async {
                  List<int> data =
                      Dynamixel.readPacket(200, 79, 3); //  led read packet
                  await flutterReactiveBle.writeCharacteristicWithResponse(
                      writeCharacteristic,
                      value: data);
                  isRead = true;
                },
                style: textButtonStyle,
                child: Text('Read'),
              ),
            ],
          ),
          Text('$readResponse'),
          StreamBuilder(
            stream: flutterReactiveBle.connectedDeviceStream,
            builder: (c, snapshot) {
              if (snapshot.hasData) {
                AsyncSnapshot<ConnectionStateUpdate> deviceState =
                    snapshot.inState(snapshot.connectionState);
                String state = deviceState.data.connectionState.toString();
                int stateIndex = deviceState.data.connectionState.index;
                bool stateIcon = false;
                if (stateIndex == 1) {
                  stateIcon = true;
                }
                return Row(
                  children: [
                    Text(
                      'Bluetooth Device state: $state',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Icon(
                      stateIcon ? Icons.check : Icons.clear,
                    ),
                  ],
                );
              } else {
                return Container();
              }
            },
          ),
          StreamBuilder(
            stream: flutterReactiveBle.characteristicValueStream,
            builder: (c, snapshot) {
              // print('state Chracteristic snapshot:$snapshot');
              return Row(
                children: [
                  Text(
                    'Bluetooth Chracteristic state: ${snapshot.connectionState}',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Icon(
                    snapshot.hasData ? Icons.check : Icons.clear,
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Future<void> subscribe() async {
    final subscribeCharacteristic = QualifiedCharacteristic(
        serviceId: serviceId,
        characteristicId: subscribeCharacteristicUuid,
        deviceId: foundDeviceId);

    flutterReactiveBle
        .subscribeToCharacteristic(subscribeCharacteristic)
        .listen((data) {
      if (isRead) {
        setState(() {
          readResponse = data.toString();
          isRead = false;
        });
      }
    }, onError: (dynamic error) {
      debugPrint('subscribeToCharacteristic Error');
    });
  }
}
