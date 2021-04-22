import 'package:flutter/material.dart';
import 'package:flutter_react_ble_provider_ex/screens/DeviceDetail.dart';
import 'package:flutter_react_ble_provider_ex/widgetStyle.dart';


class DeviceTile extends StatelessWidget {
  final String id;
  final String name;
  final int rssi;

  DeviceTile({this.id, this.name, this.rssi});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [Text(name), Text(id)],
      ),
      trailing: ElevatedButton(
        child: Text('CONNECT'),
        style: textButtonStyle,
        onPressed: (){
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => DeviceDetail()),
          );
        },
      ),
    );
  }
}
