import 'dart:async';
import 'dart:io';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:testingone/data/addressData.dart';
import 'package:testingone/widgets/license_page.dart';
import 'package:testingone/screen/webviewscreen.dart';
import 'ChatPage.dart';
import '../extraScreen/DiscoveryPage.dart';
import '../extraScreen/SelectBondedDevicePage.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPage createState() => new _MainPage();
}

class _MainPage extends State<MainPage> {
  final PdfDocument document = PdfDocument();
  BluetoothState _bluetoothState = BluetoothState.UNKNOWN;
  String LicensedMac = '';
  List<String> grantedDevice = Address().address;
  String? deviceId;
  String _address = "...";
  String _name = "...";
  Timer? _discoverableTimeoutTimer;
  bool _autoAcceptPairingRequests = false;
  String _platformVersion = 'Unknown';
  IosDeviceInfo? iosDeviceInfo;
  AndroidDeviceInfo? androidDeviceInfo;
  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  late AndroidDeviceInfo androidInfo;
  Future<String> fetchDetail() async {
    androidInfo = await deviceInfo.androidInfo;
    setState(() {
      LicensedMac = androidInfo.androidId ?? '';
      _address = androidInfo.id ?? "";
    });
    return 'success';
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<String?> _getId() async {
    var deviceInfo = DeviceInfoPlugin();
    if (Platform.isIOS) {
      // import 'dart:io'
      iosDeviceInfo = await deviceInfo.iosInfo;
      return iosDeviceInfo!.identifierForVendor; // unique ID on iOS
    } else {
      androidDeviceInfo = await deviceInfo.androidInfo;
      setState(() {
        LicensedMac = androidDeviceInfo!.androidId ?? '';
      });
      return androidDeviceInfo!.androidId; // unique ID on Android
    }
  }

  void initPlatformState() async {
    var data = await _getId();
    setState(() {
      deviceId = data;
    });
  }

  @override
  void initState() {
    super.initState();
    initPlatformState();
    _getId();
  
    FlutterBluetoothSerial.instance.state.then((state) {
      setState(() {
        _bluetoothState = state;
      });
    });

    Future.doWhile(() async {
      // Wait if adapter not enabled
      if ((await FlutterBluetoothSerial.instance.isEnabled) ?? false) {
        return false;
      }
      await Future.delayed(Duration(milliseconds: 0xFF));
      return true;
    }).then((_) {
      // Update the address field
      FlutterBluetoothSerial.instance.address.then((address) {
        setState(() {
          _address = address!;
        });
      });
    });

    FlutterBluetoothSerial.instance.name.then((name) {
      setState(() {
        _name = name!;
      });
    });

    // Listen for futher state changes
    FlutterBluetoothSerial.instance
        .onStateChanged()
        .listen((BluetoothState state) {
      setState(() {
        _bluetoothState = state;

        // Discoverable mode is disabled when Bluetooth gets disabled
        _discoverableTimeoutTimer = null;
    
      });
    });
  }

  @override
  void dispose() {
    FlutterBluetoothSerial.instance.setPairingRequestHandler(null);
    _discoverableTimeoutTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          shadowColor: Colors.blue,
          leading: Container(
              margin: EdgeInsets.all(5),
              child: Image.asset(
                'assets/fluke.png',
                fit: BoxFit.fill,
              )),
          centerTitle: true,
          actions: [
            Container(
                margin: EdgeInsets.all(5),
                child: Image.asset('assets/HURLLOGO.jpg')),
           
          ],
        ),
        body: grantedDevice.contains(LicensedMac)
            ? Container(
                margin: EdgeInsets.all(10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(
                      height: 20,
                    ),
                    Center(
                      child: Text(
                        'Connection Setting',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
                    SwitchListTile(
                      title: const Text('Enable Bluetooth'),
                      value: _bluetoothState.isEnabled,
                      onChanged: (bool value) {
                        // Do the request and update with the true value then
                        future() async {
                          // async lambda seems to not working
                          if (value)
                            await FlutterBluetoothSerial.instance
                                .requestEnable();
                          else
                            await FlutterBluetoothSerial.instance
                                .requestDisable();
                        }

                        future().then((_) {
                          setState(() {});
                        });
                      },
                    ),
                    ListTile(
                      title: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => WebViewExample()),
                            );
                          },
                          child: Text("User Manual")),
                    ),
                    ListTile(
                      title: ElevatedButton(
                          child: const Text(
                            'Explore Bluetooth devices',
                            style: TextStyle(
                              fontSize: 15,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            primary: Colors.blue,
                          ),
                          onPressed: () async {
                            Fluttertoast.showToast(
                              msg: 'Select The Hart Device To Connect',
                              gravity: ToastGravity.CENTER,
                            );

                            final BluetoothDevice? selectedDevice =
                                await Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) {
                                  return DiscoveryPage();
                                },
                              ),
                            );

                            if (selectedDevice != null) {
                              Fluttertoast.showToast(
                                msg: 'Discovery of ${selectedDevice.name}',
                                gravity: ToastGravity.CENTER,
                              );
                            } else {
                              Fluttertoast.showToast(
                                msg: 'No Bluetooth Device Discovered',
                                gravity: ToastGravity.CENTER,
                              );
                            }
                          }),
                    ),
                    SizedBox(
                      height: 50,
                    ),
                    GestureDetector(
                      onTap: () async {
                        Fluttertoast.showToast(
                          msg: 'Select The Hart Device',
                          gravity: ToastGravity.CENTER,
                        );

                        final BluetoothDevice? selectedDevice =
                            await Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) {
                              return SelectBondedDevicePage(
                                  checkAvailability: false);
                            },
                          ),
                        );

                        if (selectedDevice != null) {
                          Fluttertoast.showToast(
                            msg: 'Connected to ${selectedDevice.name}',
                            gravity: ToastGravity.CENTER,
                          );

                          _startChat(context, selectedDevice);
                        } else {
                          Fluttertoast.showToast(
                            msg: 'No Device Connected',
                            gravity: ToastGravity.CENTER,
                          );
                        }
                      },
                      child: AvatarGlow(
                        startDelay: Duration(seconds: 1),
                        glowColor: Colors.red,
                        endRadius: 150.0,
                        duration: Duration(milliseconds: 2000),
                        repeat: true,
                        showTwoGlows: true,
                        repeatPauseDuration: Duration(milliseconds: 100),
                        child: Container(
                          margin: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                          height: 150,
                          // alignment: AlignmentGeometry.lerp(0, , t),
                          width: 150,
                          decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.all(Radius.circular(750)),
                            color: Colors.blue,
                          ),
                          child: Center(
                            child: Text(
                              'Connect to Device',
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w800,
                                  color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            : Nolicense(LicensedMac));
  }

  void _startChat(BuildContext context, BluetoothDevice server) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) {
          return grantedDevice.contains(LicensedMac)
              ? ChatPage(server: server)
              : Nolicense(LicensedMac);
        },
      ),
    );
  }
}
