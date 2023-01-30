import 'package:flutter/material.dart';

class Nolicense extends StatelessWidget {
  Nolicense(this.licensedMac, {Key? key}) : super(key: key);
  String licensedMac;
  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.all(20),
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Hi,\nThis is an Industrial Standard App to Communicate and Control HART device.',
              style: TextStyle(fontSize: 20),
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              " To Know More Please Contact",
              style: TextStyle(fontSize: 20),
              textAlign: TextAlign.center,
            ),
            Text(
              "XXXXX54321",
              style: TextStyle(fontSize: 20),
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              "Your Device ID",
              style: TextStyle(fontSize: 24),
            ),
            Text(
              "$licensedMac",
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
          ],
        ));
  }
}
