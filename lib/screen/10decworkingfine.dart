import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:testingone/data/unitsData.dart';
import 'package:testingone/service/get_check_cum.dart';
import 'package:testingone/service/get_device_address.dart';
import 'package:testingone/service/get_number_conversation.dart';
import 'package:testingone/service/int_to_text_conversation.dart';
import 'package:testingone/service/is_subarray.dart';
import 'package:testingone/service/text_to_int_conversation.dart';
import 'package:testingone/widgets/connection_widgets.dart';
import 'package:testingone/service/validateLclUcl.dart';
import 'package:testingone/data/command.dart';
import 'package:testingone/service/conversion.dart';
import 'package:testingone/service/servicePage.dart';
import 'package:testingone/model/units.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

import 'dart:typed_data';
import 'package:flutter/services.dart' show rootBundle;

import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';

import '../service/mobile.dart' if (dart.library.html) 'web.dart';

class ChatPage extends StatefulWidget {
  final BluetoothDevice server;

  const ChatPage({required this.server});

  @override
  _ChatPage createState() => new _ChatPage();
}

class _Message {
  int whom;
  String text;

  _Message(this.whom, this.text);
}

class _ChatPage extends State<ChatPage> {
  //Controllers
  TextEditingController lclController = TextEditingController();

  TextEditingController uclController = TextEditingController();
  TextEditingController textEditingController = new TextEditingController();
  ScrollController listScrollController = new ScrollController();
  //bluetooth essential
  BluetoothConnection? connection;
  bool loadscreen = false;
  String WaitingScreenText = 'Waiting for the connection';

  List<int> lll = [
    255,
    255,
    255,
    255,
    255,
    134,
    183,
    92,
    54,
    30,
    86,
    2,
    10,
    0,
    80,
    64,
    128,
    0,
    0,
    0,
    0,
    0,
    0,
    139,
    224
  ];
  bool ucllclFlag = true;
  bool isConnecting = true;
  bool get isConnected => (connection?.isConnected ?? false);
  bool isDisconnecting = false;
  bool outer = true;
  bool higher = true;
  bool lower = true;
  bool current_process = false;
  bool stopFlag = false;
  bool setTagtestFlag = false;
  bool setUcltestFlag = false;
  bool looptestFlag = false;
  bool manuFact = true;
  bool tagDesp = true;
  bool fetchlcluclCMD = false;
  bool isValidUCLLCL = false;
  bool isValidLoop = false;
  bool outerlowCHECK = false;
  bool outerHIGHCHECK = false;
  bool screenLoaded = false;
  bool zerotrimflagg = false;

  //key
  final _uclKey = GlobalKey<FormState>();
  final _outerKey = GlobalKey<FormState>();
  final _outerHighKey = GlobalKey<FormState>();

  final _lclKey = GlobalKey<FormState>();
  final _formKey = GlobalKey<FormState>();
  final _loopKey = GlobalKey<FormState>();
  final _lowKey = GlobalKey<FormState>();
  final _highKey = GlobalKey<FormState>();

  //list
  List<_Message> messages = List<_Message>.empty(growable: true);
  List<UnitsModel> unitsModel = Units().units;
  List<String> unitsName = Units().unitsName;
  List<int> dataa = [];
  List<int> manufacture = [];
  int countSend = 0;
  int countdata = 0;
  List<int> tag = [];
  List<int> valueEntered = [];
  List<int> valueEnteredOUTERHIGH = [];
  List<int> processint = [];
  List<int> tagFinalCmd = [];
  List<int> unitFinalCmd = [];
  List<int> loopFinalCmd = [];
  List<int> trimming = [];
  List<int> addressCMD = [];
  bool addressCMDFlag = true;
  List<int> addressCMD2 = [];
  bool addressCMDFlag2 = true;
  List<int> ucllclData = [];
  List<int> valuechanged = [];
  List<int> fetchlcluclCMDData = [];
  List<int> _highKeyValue = [];
  List<int> _lowKeyValue = [];
  List<int> uclinput = [];
  List<int> lclinput = [];
  List<int> unitinput = [];
  List<int> unitNamedValueCMD = [0xA];
  List<int> reverseValue = [];
  //variables
  var model;
  var lcl;
  var units;
  var current = 0.0;
  var range = 0.0;
  var process1 = 0.0;
  var process2 = 0.0;
  String processToDisplay = "0.0";
  String currentToDisplay = "0.0";
  String rangeToDisplay = "0.0";
  double uCLVALUE = 0.0;
  double lCLVALUE = 0.0;
  //String
  String? _chosenValue;
  String uclCode = '0';
  String _uclValue = '0';
  String lclCode = '0';
  String _lclValue = '0';
  String tagCode = '';
  String unitNamedValue = 'KPa';
  String tagnametodisplay = '';
  String lclnumtodisplay = '0';
  String uclnumtodisplay = '0';
//numbers
  String checkingLCLUCL = "NO";
  Uint8List? resultNum;

  String uCLVALUEString = '';
  String lCLVALUEString = '';

  int id = 4;
  int unitsnamee = 0;
  var upperValueUCL;
  var lowerValueUCL;
  //commands
  List<int> currentCMD = [];
  List<int> temp3 = [];
  List<int> macadd = [];
  List<int> macadd2 = [];
  List<int> tagCMDFirst = [];
  List<int> tagCMDSecond = [];
  List<int> unitCMDFirst = [];
  List<int> unitCMDSecond = [];
  List<int> loopCMDFirst = [];
  List<int> loopCMDSecond = [];
  List<int> despritionTagCMD = [];
  List<int> manufacturerCMD = [];
  List<int> processCMD = [];
  List<int> upperlimitlowerTagCMD = [];
  List<int> lowerCMD = [];
  List<int> higherCMD = [];
  List<int> outerLowCMD = [];
  List<int> outerHighCMD = [];
  List<int> zeroTrim = [];
  List<int> macaddress = [];
  List<int> cmdforlclucl = [];
  List<int> lcluclCmd1 = [];
  List<int> unitCmd = [];
  List<int> lcluclCmd2 = [];
  List<int> outerLowCMDModification = [];
  List<int> outerLowCMDModificationSecond = [];
  int manufactureNumber = 1;
  List<int> automaticControl = [];
  List<int> temptagCode = [];
  List<int> tempunitCode = [];
  List<int> preamble = [
    0xFF,
    0xFF,
    0xFF,
    0xFF,
    0xFF,
  ];
  List<int> lastValue = [0x0D, 0x0A];
  List<int> upperlimitlowerTagCMDChecksum = [];
  List<int> upperlimitlowerTagCMDTemp = [];
  List<int> processCMDChecksum = [];
  List<int> processCMDTemp = [];
  List<int> currentCMDChecksum = [];
  List<int> currentCMDTemp = [];
  List<int> outerHighCMDChecksum = [];
  List<int> outerHighCMDTemp = [];
  List<int> outerLowCMDChecksum = [];
  List<int> outerLowCMDTemp = [];
  List<int> zeroTrimChecksum = [];
  List<int> zeroTrimTemp = [];
  List<int> automaticControlChecksum = [];
  List<int> automaticControlTemp = [];
  List<int> despritionTagCMDChecksum = [];
  List<int> despritionTagCMDTemp = [];

  //others
  Service _service = Service();
  ChatContainer _container = ChatContainer();

  var check1;
  void commandInitialize() {
    manufacturerCMD = [0x82] + macaddress + Command.manufacturerCMD;
    despritionTagCMD = [0x82] + macaddress + Command.despritionTagCMD;
    despritionTagCMDChecksum = getCheckSum(despritionTagCMD);
    despritionTagCMDTemp =
        preamble + despritionTagCMD + despritionTagCMDChecksum + lastValue;
    upperlimitlowerTagCMD = [0x82] + macaddress + Command.upperlimitlowerTagCMD;
    upperlimitlowerTagCMDChecksum = getCheckSum(upperlimitlowerTagCMD);
    upperlimitlowerTagCMDTemp = preamble +
        upperlimitlowerTagCMD +
        upperlimitlowerTagCMDChecksum +
        lastValue;
    processCMD = [0x82] + macaddress + Command.processCMD;
    processCMDChecksum = getCheckSum(processCMD);
    processCMDTemp = preamble + processCMD + processCMDChecksum + lastValue;
    currentCMD = [0x82] + macaddress + Command.currentCMD;
    currentCMDChecksum = getCheckSum(currentCMD);
    currentCMDTemp = preamble + currentCMD + currentCMDChecksum + lastValue;
    tagCMDFirst = [0x82] + macaddress + Command.tagCMDFirst;
    tagCMDSecond = Command.tagCMDSecond;
    unitCMDFirst = [0x82] + macaddress + Command.unitCMDFirst;
    loopCMDFirst = [0x82] + macaddress + Command.loopFirst;
    loopCMDSecond = lastValue;
    higherCMD = [0x82] + macaddress + Command.higherCMD;
    lowerCMD = [0x82] + macaddress + Command.lowerCMD;
    outerHighCMD = [0x82] + macaddress + Command.outerHighCMD;
    outerLowCMD = [0x82] + macaddress + Command.outerLowCMD;
    outerHighCMDChecksum = getCheckSum(outerHighCMD);
    outerHighCMDTemp =
        preamble + outerHighCMD + outerHighCMDChecksum + lastValue;
    outerLowCMDChecksum = getCheckSum(outerLowCMD);
    outerLowCMDTemp = preamble + outerLowCMD + outerLowCMDChecksum + lastValue;
    automaticControl = [0x82] + macaddress + Command.automaticControl;
    automaticControlChecksum = getCheckSum(automaticControl);
    automaticControlTemp =
        preamble + automaticControl + automaticControlChecksum + lastValue;
    outerLowCMDModification =
        [0x82] + macaddress + Command.outerLowCMDModification;
    outerLowCMDModificationSecond =
        [0x82] + macaddress + Command.outerLowCMDModificationSecond;
    zeroTrim = [0x82] + macaddress + Command.zeroTrimCmd;
    zeroTrimChecksum = getCheckSum(zeroTrim);
    zeroTrimTemp = preamble + zeroTrim + zeroTrimChecksum + lastValue;
    lcluclCmd1 = [0x82] + macaddress + Command.lcluclCmd1;
    lcluclCmd2 = lastValue;
  }

  @override
  void initState() {
    //numberConvert(widget.server.address);
    setState(() {
      loadscreen = connection?.isConnected ?? false;
    });
    bluetoothCon();
    setState(() {
      loadscreen = connection?.isConnected ?? false;
    });
    Future.delayed(const Duration(seconds: 5), () {
      setState(() {
        WaitingScreenText = "Please Try to Connect to Modem Again";
      });
    });
    //  if (isConnected) {
    sendinitialCmd();
    //   bluetoothCon();
    // }
    super.initState();
  }

  void bluetoothCon() {
    BluetoothConnection.toAddress(widget.server.address).then((_connection) {
      connection = _connection;

      setState(() {
        loadscreen = connection?.isConnected ?? false;
        isConnecting = false;
        isDisconnecting = false;
      });
      connection!.input!.listen(_onDataReceived).onDone(() {
        if (isDisconnecting) {
        } else {}
        if (this.mounted) {
          setState(() {});
        }
      });
    }).catchError((error) {
      print(error);
    });
  }

  List<int> numberConvert(String string) {
    List<String> myList = [];
    int i = 0;
    while (i < string.length) {
      if (string[i] == ':') {
        myList.add(string[i - 2] + string[i - 1]);
      }
      i++;
    }
    myList.add(string[i - 2] + string[i - 1]);
    List<int> ch = [];
    int j = 0;
    for (int y = 0; y < myList.length; y++) {
      String data = (myList[y]);
      ch.add(int.parse(data, radix: 16));
    }
    return ch;
  }

  @override
  void dispose() {
    if (isConnected) {
      isDisconnecting = true;
      connection?.dispose();
      connection = null;
    }
    super.dispose();
  }

  Future<void> _sendMessagee(List<int> text) async {
    if (loadscreen) {
      setState(() {
        loadscreen = connection?.isConnected ?? false;
      });
    } else {
      bluetoothCon();
    }

    setState(() {
      dataa.clear();
      processint.clear();
    });
    if (text.length > 0) {
      try {
        connection!.output.add(Uint8List.fromList(text));
        await connection!.output.allSent;
      } catch (e) {
        setState(() {});
      }
    }
  }

  void breakingPrange(List<int> data) {
    List<int> dataRecieved = isSubArray(data, macaddress, 9);
    setState(() {});

    List<int> dataRecieved2 = dataRecieved.sublist(5, 9);
    setState(() {});

    double currentValue = _service.convertion(dataRecieved2);
    setState(() {});
    double processVariable = currentValue;
    process2 = processVariable;
    processToDisplay = '${process2.toStringAsFixed(3)}';
    setState(() {
      processToDisplay = processToDisplay;
      process1 = currentValue;
    });
  }

  void _onDataReceived(Uint8List data) async {
    if (!stopFlag) {
      if (addressCMDFlag2) {
        for (int i = 0; i < data.length; i++) {
          setState(() {
            addressCMD2.add(data[i]);
          });
        }
      } else if (manuFact) {
        for (int i = 0; i < data.length; i++) {
          if (manufacture.length > 15 && data[i] == 255) {
            manuFact = false;
            setManuName();
          }
          setState(() {
            manufacture.add(data[i]);
          });
        }
      } else if (tagDesp) {
        for (int i = 0; i < data.length; i++) {
          if (tag.length > 29 && data[i] == 255) {
            if(tag[0]==255){
          
              tagDesp = false;
               if (isSubArray(tag, macaddress, 2) != [13, 23]) {
              print("recieved tag:$tag");
              setTagName();
              }
               else {
              print("recieved wrong tag:$tag");
              fetchTag();
            }
             
            }
          }
          setState(() {
            tag.add(data[i]);
          });
        }
      } else if (ucllclFlag) {
        for (int i = 0; i < data.length; i++) {
          setState(() {
            fetchlcluclCMDData.add(data[i]);
          });
        }

        if (fetchlcluclCMDData.length >= 30) {
          breaking3(
            isSubArray(fetchlcluclCMDData, macaddress, 21),
          );
        }
      } else {
        for (int i = 0; i < data.length; i++) {
          if (current_process) {
            setState(() {
              dataa.add(data[i]);
            });
          } else {
            setState(() {
              processint.add(data[i]);
            });
          }
        }
        if (dataa.length >= 23) {
          breaking(dataa);
        } else if (processint.length >= 19) {
          breakingPrange(processint);
        }
      }
    } else {
      for (int i = 0; i < trimming.length; i++) {
        setState(() {
          trimming.add(data[i]);
        });
      }
    }

    if (data.isEmpty) {
      setState(() {
        valuechanged = dataa;
      });
    }
  }

  void setManuName() {
    manufactureNumber =
        isSubArray(isSubArray(manufacture, macaddress, 10), [254], 1).first;
    setState(() {
      manufactureNumber = manufactureNumber;
      unitNamedValue = unitNamedValue;
    });
  }

  void setTagName() {
    if (tag.length > 30) {
      tagnametodisplay =
          '${reverseConversation(isSubArray(tag, macaddress, 10).sublist(4, 10))}';
      ucllclFlag = true;
      print("tagnametodisplay $tagnametodisplay");
      setState(() {
        tagnametodisplay = tagnametodisplay;
        unitNamedValue = unitNamedValue;
      });
    }
  }

  Future<void> sendinitialCmd() async {
    await Future.delayed(const Duration(seconds: 5), () {});
    await _sendMessagee([
      0xFF,
      0xFF,
      0xFF,
      0xFF,
      0xFF,
      0x02,
      0x00,
      0x00,
      0x00,
      0x02,
      0x0D,
      0x0A
    ]);

    await Future.delayed(const Duration(seconds: 5), () {
      macadd2 = getAddressData(addressCMD2);
      addressCMDFlag2 = false;
    });

    setState(() {
      macaddress = macadd2;
    });

    commandInitialize();
    List<int> manufacturerCMDCS = getCheckSum(manufacturerCMD);
    List<int> manufacturerCMDTemp =
        preamble + manufacturerCMD + manufacturerCMDCS + lastValue;

    await _sendMessagee(manufacturerCMDTemp);

    await Future.delayed(const Duration(seconds: 4), () {
      sendinitialCmdd();
    });

    await Future.delayed(const Duration(seconds: 4), () {
      sendlcluclCmdd();
    });
    setManuName();
    setTagName();

    await Future.delayed(const Duration(seconds: 4), () {
      ucllclFlag = false;
      stopFlag = false;
      screenLoaded = true;
      loadscreen = connection?.isConnected ?? false;
      dataSend();
    });
  }

  Future<void> sendlcluclCmdd() async {
    await Future.delayed(const Duration(seconds: 2), () {});
    await _sendMessagee(upperlimitlowerTagCMDTemp);
  }

  Future<void> sendinitialCmdd() async {
    await Future.delayed(const Duration(seconds: 2), () {});

    await _sendMessagee(despritionTagCMDTemp);
  }

  void fetchTag() {
    ucllclFlag = true;
    //  setState(() {
    tag = [];
    //});
    print("===========================");
    print("Tag Send data $despritionTagCMDTemp");
    print("===========================");
    tagDesp = true;
    _sendMessagee(despritionTagCMDTemp);
  }

  void fetchlcl() async {
    setState(() {
      fetchlcluclCMDData = [];
    });
    ucllclFlag = true;
    _sendMessagee(upperlimitlowerTagCMDTemp);
    await Future.delayed(const Duration(seconds: 8), () {
      ucllclFlag = false;
    });
  }

  Future<void> dataSend() async {
    setState(() {
      loadscreen = connection?.isConnected ?? false;
      screenLoaded = true;
    });
    int i = 0;
    while (i < 1000) {
      i = i + 1;
      if (!stopFlag && !ucllclFlag) {
        if (valuechanged != dataa) {
          if (current_process) {
            await _sendMessagee(processCMDTemp);
            current_process = false;
          } else {
            await _sendMessagee(currentCMDTemp);
            current_process = true;
          }
        }
      }
      await Future.delayed(const Duration(milliseconds: 1500), () {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final serverName = widget.server.name ?? "Unknown";
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        shadowColor: Colors.blue,
        leading: Container(
            width: 200,
            margin: EdgeInsets.all(5),
            child: Image.asset(
              'assets/fluke.png',
              fit: BoxFit.fill,
            )),
        centerTitle: true,
        actions: [
          Container(
              width: 50,
              height: 50,
              margin: EdgeInsets.all(5),
              child: Image.asset('assets/HURLLOGO.jpg')),
        ],
      ),
      resizeToAvoidBottomInset: false,
      body: loadscreen
          ? SafeArea(
              //child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Container(),
                      _container.connecting(
                          serverName, isConnected, isDisconnecting)
                    ],
                  ),
                  deviceDetails(),
                  currentValueShow(),
                  SizedBox(
                    height: 45,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(children: [
                        GestureDetector(
                            onTap: () async {
                              await showDialog(
                                  context: context,
                                  builder: (BuildContext context) =>
                                      StatefulBuilder(
                                          builder: (context, setStateModal) {
                                        return AlertDialog(
                                          title: Text('Choose The Trimming'),
                                          content: Container(
                                            width: 300,
                                            height: 150,
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                zerotrim(),
                                                Center(
                                                  child: SizedBox(
                                                    width: 200,
                                                    child: ElevatedButton(
                                                        onPressed: () async {
                                                          await showDialog(
                                                            context: context,
                                                            builder: (BuildContext
                                                                    context) =>
                                                                StatefulBuilder(
                                                              builder: (context,
                                                                  setStateModal) {
                                                                return AlertDialog(
                                                                  title: Center(
                                                                    child: Text(
                                                                        'Choose The Sensor Trimming'),
                                                                  ),
                                                                  content:
                                                                      Container(
                                                                    margin: EdgeInsets
                                                                        .all(5),
                                                                    width: MediaQuery.of(context)
                                                                            .size
                                                                            .width *
                                                                        0.5,
                                                                    height: 110,
                                                                    child:
                                                                        Column(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .start,
                                                                      children: [
                                                                        lowertrim(),
                                                                        uppertrim(),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                  actions: [
                                                                    ElevatedButton(
                                                                        onPressed:
                                                                            () {
                                                                          Navigator.of(context)
                                                                              .pop();
                                                                        },
                                                                        child: Text(
                                                                            'Cancel'))
                                                                  ],
                                                                );
                                                              },
                                                            ),
                                                          );
                                                        },
                                                        child: Text(
                                                            'Sensor Trimming')),
                                                  ),
                                                ),
                                                outputtrim(),
                                              ],
                                            ),
                                          ),
                                          actions: [
                                            ElevatedButton(
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                                child: Text('Cancel'))
                                          ],
                                        );
                                      }));
                            },
                            child: Image.asset(
                              'assets/cutting.png',
                              width: 40,
                              height: 40,
                            )),
                        Text(
                          'Trimming',
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 12,
                              fontWeight: FontWeight.w800),
                        )
                      ]),
                      Column(children: [
                        GestureDetector(
                            onTap: () async {
                              await showDialog(
                                  context: context,
                                  builder:
                                      (BuildContext context) => StatefulBuilder(
                                              builder:
                                                  (context, setStateModal) {
                                            return AlertDialog(
                                              title: Column(
                                                children: [
                                                  Text("Setup Screen"),
                                                ],
                                              ),
                                              content: Container(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    1,
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.20,
                                                child: Column(
                                                  children: [
                                                    SizedBox(
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              1,
                                                      height: 50,
                                                      child: ElevatedButton(
                                                          onPressed: () async {
                                                            await showDialog(
                                                                context:
                                                                    context,
                                                                builder: (BuildContext
                                                                        context) =>
                                                                    StatefulBuilder(builder:
                                                                        (context,
                                                                            setStateModal) {
                                                                      return AlertDialog(
                                                                        title: Center(
                                                                            child:
                                                                                Text('Tag Setup')),
                                                                        content:
                                                                            SingleChildScrollView(
                                                                                child: Column(children: [
                                                                          Form(
                                                                            key:
                                                                                _formKey,
                                                                            child:
                                                                                TextFormField(
                                                                              key: ValueKey('tag'),
                                                                              validator: (value) {
                                                                                if (value!.isEmpty) {
                                                                                  return 'Please enter a valid TAG Name';
                                                                                }
                                                                                return null;
                                                                              },
                                                                              initialValue: '${reverseConversation(isSubArray(tag, macaddress, 10).sublist(4, 10))}',
                                                                              onChanged: (String tagCode) {
                                                                                check1 = tagCode;
                                                                              },
                                                                              keyboardType: TextInputType.text,
                                                                              style: TextStyle(
                                                                                fontSize: 20,
                                                                              ),
                                                                              maxLength: 8,
                                                                              decoration: InputDecoration(
                                                                                contentPadding: EdgeInsets.fromLTRB(30, 30, 30, 8),
                                                                                border: const UnderlineInputBorder(),
                                                                                filled: true,
                                                                                hintText: 'Tag Name',
                                                                                hintStyle: TextStyle(color: Colors.grey, fontSize: 20),
                                                                                fillColor: Colors.white,
                                                                              ),
                                                                              onSaved: (value) {
                                                                                check1 = value!;
                                                                              },
                                                                            ),
                                                                          ),
                                                                          SizedBox(
                                                                            height:
                                                                                10,
                                                                          ),
                                                                          setTagtestFlag
                                                                              ? Center(
                                                                                  child: Container(
                                                                                    margin: const EdgeInsets.fromLTRB(10, 10, 0, 10),
                                                                                    height: 50,
                                                                                    width: 210,
                                                                                    decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(20)), color: Colors.green),
                                                                                    child: Center(
                                                                                      child: Row(children: [
                                                                                        SizedBox(
                                                                                          width: 10,
                                                                                        ),
                                                                                        Text(
                                                                                          'Tag Set Successfully',
                                                                                          style: TextStyle(
                                                                                            fontSize: 14,
                                                                                          ),
                                                                                        ),
                                                                                        Icon(Icons.check)
                                                                                      ]),
                                                                                    ),
                                                                                  ),
                                                                                )
                                                                              : Container(),
                                                                          SizedBox(
                                                                            height:
                                                                                20,
                                                                          ),
                                                                          Row(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.spaceBetween,
                                                                            children: [
                                                                              Container(),
                                                                              ElevatedButton(
                                                                                  onPressed: () {
                                                                                    setStateModal(() {
                                                                                      setTagtestFlag = true;
                                                                                    });
                                                                                    _submitForm();
                                                                                    Future.delayed(const Duration(seconds: 4), () {
                                                                                      setStateModal(() {
                                                                                        setTagtestFlag = false;
                                                                                      });
                                                                                      if (_formKey.currentState!.validate()) {
                                                                                        fetchTag();

                                                                                        Navigator.of(context).pop();
                                                                                      }
                                                                                    });
                                                                                  },
                                                                                  child: Text('SetTag')),
                                                                            ],
                                                                          ),
                                                                        ])),
                                                                      );
                                                                    }));
                                                          },
                                                          child:
                                                              Text("Set Tag")),
                                                    ),
                                                    SizedBox(
                                                      height: 10,
                                                    ),
                                                    SizedBox(
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              3,
                                                      height: 50,
                                                      child: ElevatedButton(
                                                          onPressed: () async {
                                                            await showDialog(
                                                                context:
                                                                    context,
                                                                builder: (BuildContext
                                                                        context) =>
                                                                    StatefulBuilder(builder:
                                                                        (context,
                                                                            setStateModal) {
                                                                      return AlertDialog(
                                                                          title:
                                                                              Center(child: Text('Set Lower & Higher Range')),
                                                                          content: SingleChildScrollView(
                                                                              child: Column(children: [
                                                                            SizedBox(
                                                                              height: 10,
                                                                            ),
                                                                            Container(
                                                                              width: MediaQuery.of(context).size.width * 0.7,
                                                                              child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                                                                                Center(child: Text('Select Unit')),
                                                                                SizedBox(
                                                                                  width: 20,
                                                                                ),
                                                                                Container(
                                                                                  decoration: BoxDecoration(color: Colors.white),
                                                                                  padding: const EdgeInsets.all(0.0),
                                                                                  width: 100,
                                                                                  child: DropdownButton<String>(
                                                                                    value: _chosenValue ?? unitNamedValue,
                                                                                    style: TextStyle(color: Colors.black),
                                                                                    items: unitsName.map<DropdownMenuItem<String>>((String value) {
                                                                                      return DropdownMenuItem<String>(
                                                                                        value: value,
                                                                                        child: Text(value),
                                                                                      );
                                                                                    }).toList(),
                                                                                    hint: Text(
                                                                                      "choose unit ",
                                                                                      style: TextStyle(color: Colors.black, fontSize: 12, fontWeight: FontWeight.w400),
                                                                                    ),
                                                                                    onChanged: (String? value) {
                                                                                      for (var unit in unitsModel) {
                                                                                        if (unit.name == value) {
                                                                                          uclCode = unit.ucl;
                                                                                          lclCode = unit.lcl;
                                                                                          id = unit.id;
                                                                                        }
                                                                                      }
                                                                                      lclinput = getNumConversation(_lclValue);
                                                                                      temp3 = getNumConversation(uclCode);
                                                                                      uclController.text = uclCode;
                                                                                      lclController.text = lclCode;
                                                                                      _uclKey.currentState!.validate();
                                                                                      _lclKey.currentState!.validate();
                                                                                      setStateModal(() {
                                                                                        //   lclinput = temp2;
                                                                                        uclinput = temp3;
                                                                                        unitinput = [id];
                                                                                        ucllclFlag = true;
                                                                                        uclCode = uclCode;
                                                                                        lclCode = lclCode;
                                                                                        id = id;
                                                                                        _chosenValue = value ?? unitNamedValue;
                                                                                      });
                                                                                    },
                                                                                  ),
                                                                                ),
                                                                              ]),
                                                                            ),
                                                                            SizedBox(
                                                                              height: 10,
                                                                            ),
                                                                            Form(
                                                                              key: _uclKey,
                                                                              child: Container(
                                                                                width: MediaQuery.of(context).size.width * 0.5,
                                                                                child: TextFormField(
                                                                                  key: ValueKey('ucl'),
                                                                                  validator: (value) {
                                                                                    if (double.parse(value!) <= 2000.0 && double.parse(value) >= 0.0) {
                                                                                      return '';
                                                                                    }
                                                                                    return 'Enter UCL Value between 0 to 2000';
                                                                                  },
                                                                                  keyboardType: TextInputType.number,
                                                                                  controller: uclController,
                                                                                  //   initialValue: uCLVALUE.toString() ??'',
                                                                                  onChanged: (String? value) {
                                                                                    setState(() {
                                                                                      isValidUCLLCL = false;
                                                                                    });
                                                                                    _uclValue = value!;
                                                                                  },
                                                                                  // initialValue: '$uclnumtodisplay',
                                                                                  style: TextStyle(
                                                                                    fontSize: 20,
                                                                                  ),
                                                                                  decoration: InputDecoration(
                                                                                    fillColor: Colors.white,
                                                                                    errorText: ChatService.validateUcl(_uclValue) ? null : 'Enter the Value',
                                                                                    contentPadding: EdgeInsets.fromLTRB(30, 30, 30, 8),
                                                                                    border: const UnderlineInputBorder(),
                                                                                    filled: true,
                                                                                    hintText: 'Upper range value',
                                                                                    hintStyle: TextStyle(color: Colors.black, fontSize: 20),
                                                                                  ),
                                                                                  onSaved: (value) {
                                                                                    uclCode = value!;
                                                                                    final temp = getNumConversation(value);
                                                                                    // final temp = Uint8List.fromList(utf8.encode(uclCode));
                                                                                    uclCode = uclCode;
                                                                                    uclinput = temp;
                                                                                  },
                                                                                ),
                                                                              ),
                                                                            ),
                                                                            SizedBox(
                                                                              height: 10,
                                                                            ),
                                                                            Form(
                                                                              key: _lclKey,
                                                                              child: Container(
                                                                                width: MediaQuery.of(context).size.width * 0.5,
                                                                                child: TextFormField(
                                                                                  key: ValueKey('lcl'),
                                                                                  validator: (value) {
                                                                                    if (double.parse(value!) <= 2000.0 && double.parse(value) >= 0.0) {
                                                                                      return '';
                                                                                    }
                                                                                    return 'Enter LCL Value between 0 to 2000';
                                                                                  },
                                                                                  keyboardType: TextInputType.number,
                                                                                  controller: lclController,
                                                                                  onChanged: (String? value) {
                                                                                    setState(() {
                                                                                      isValidUCLLCL = false;
                                                                                    });

                                                                                    _lclValue = value!;
                                                                                    lclinput = getNumConversation(_lclValue);
                                                                                  },
                                                                                  // initialValue: '$lclnumtodisplay',
                                                                                  style: TextStyle(
                                                                                    fontSize: 20,
                                                                                  ),

                                                                                  decoration: InputDecoration(
                                                                                    fillColor: Colors.white,
                                                                                    errorText: ChatService.validatelcl(_lclValue) ? null : 'Enter the Value',
                                                                                    contentPadding: EdgeInsets.fromLTRB(30, 30, 30, 8),
                                                                                    border: const UnderlineInputBorder(),
                                                                                    filled: true,
                                                                                    hintText: 'Lower Range value',
                                                                                    hintStyle: TextStyle(color: Colors.black, fontSize: 20),
                                                                                  ),
                                                                                  onSaved: (value) {
                                                                                    lclCode = value!;
                                                                                    final temp = getNumConversation(lclCode);

                                                                                    lclCode = lclCode;
                                                                                    lclinput = temp;
                                                                                  },
                                                                                ),
                                                                              ),
                                                                            ),
                                                                            SizedBox(
                                                                              height: 10,
                                                                            ),
                                                                            Row(
                                                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                              children: [
                                                                                Container(),
                                                                                ElevatedButton(
                                                                                    onPressed: () {
                                                                                      setStateModal(() {
                                                                                        setUcltestFlag = true;
                                                                                      });
                                                                                      _submitForm3();
                                                                                      Future.delayed(const Duration(seconds: 4), () {
                                                                                        setStateModal(() {
                                                                                          setUcltestFlag = false;
                                                                                        });

                                                                                        fetchlcl();

                                                                                        Navigator.of(context).pop();
                                                                                      });
                                                                                    },
                                                                                    child: Text('SET Lower & Upper Range')),
                                                                              ],
                                                                            ),
                                                                            setUcltestFlag && isValidUCLLCL
                                                                                ? Center(
                                                                                    child: Container(
                                                                                      margin: const EdgeInsets.fromLTRB(10, 10, 0, 10),
                                                                                      height: 50,
                                                                                      width: 210,
                                                                                      decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(20)), color: Colors.green),
                                                                                      child: Center(
                                                                                        child: Row(children: [
                                                                                          SizedBox(
                                                                                            width: 10,
                                                                                          ),
                                                                                          Text(
                                                                                            'UCL LCL Set Successfully',
                                                                                            style: TextStyle(
                                                                                              fontSize: 12,
                                                                                            ),
                                                                                          ),
                                                                                          Icon(Icons.check)
                                                                                        ]),
                                                                                      ),
                                                                                    ),
                                                                                  )
                                                                                : Container(),
                                                                          ])));
                                                                    }));
                                                          },
                                                          child: Text(
                                                              "Set Lower & Upper Range")),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              actions: <Widget>[
                                                ElevatedButton(
                                                  onPressed: () {
                                                    ucllclFlag = false;

                                                    Navigator.of(context).pop();
                                                  },
                                                  child: Text("Cancel"),
                                                ),
                                              ],
                                            );
                                          }));
                            },
                            child: Image.asset(
                              'assets/setup.png',
                              width: 40,
                              height: 40,
                            )),
                        Text(
                          'Setup',
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 12,
                              fontWeight: FontWeight.w800),
                        )
                      ]),
                      Column(children: [
                        GestureDetector(
                            onTap: () async {
                              await showDialog(
                                  context: context,
                                  builder: (BuildContext context) =>
                                      StatefulBuilder(
                                          builder: (context, setStateModal) {
                                        return AlertDialog(
                                          title: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                'Loop Test',
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.w700),
                                              ),
                                              SizedBox(
                                                height: 5,
                                              ),
                                              Text(
                                                  'Enter the Current value in mA.'),
                                            ],
                                          ),
                                          content: Container(
                                            width: 300,
                                            height: 200,
                                            child: Column(
                                              children: [
                                                Form(
                                                  key: _loopKey,
                                                  child: Container(
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.6,
                                                    child: TextFormField(
                                                      key: ValueKey('loopKey'),
                                                      validator: (value) {
                                                        if (value!.isEmpty) {
                                                          return 'Please enter Current value';
                                                        }
                                                        return null;
                                                      },
                                                      keyboardType:
                                                          TextInputType.number,
                                                      style: TextStyle(
                                                        fontSize: 20,
                                                      ),
                                                      decoration:
                                                          InputDecoration(
                                                        contentPadding:
                                                            EdgeInsets.fromLTRB(
                                                                30, 30, 30, 8),
                                                        border:
                                                            const UnderlineInputBorder(),
                                                        filled: true,
                                                        hintText:
                                                            'Loop Test Current value',
                                                        hintStyle: TextStyle(
                                                            color: Colors.grey,
                                                            fontSize: 20),
                                                        fillColor: Colors.white,
                                                      ),
                                                      onSaved: (value) {
                                                        List<int> bytes =
                                                            getNumConversation(
                                                                value ?? '');

                                                        var loopFinalCmdTemp =
                                                            loopCMDFirst +
                                                                bytes;
                                                        var loopFinalCmdchecksum =
                                                            getCheckSum(
                                                                loopFinalCmdTemp);
                                                        var dataTempLCL = preamble +
                                                            loopFinalCmdTemp +
                                                            loopFinalCmdchecksum +
                                                            loopCMDSecond;

                                                        loopFinalCmd =
                                                            dataTempLCL;
                                                      },
                                                    ),
                                                  ),
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Container(),
                                                    ElevatedButton(
                                                        onPressed: () async {
                                                          setStateModal(() {
                                                            looptestFlag = true;
                                                          });
                                                          _submitForm2();
                                                          Future.delayed(
                                                              const Duration(
                                                                  seconds: 4),
                                                              () async {
                                                            setStateModal(() {
                                                              looptestFlag =
                                                                  false;
                                                            });

                                                            await _sendMessagee(
                                                                automaticControlTemp);
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                          });
                                                        },
                                                        child:
                                                            Text('Loop Test')),
                                                  ],
                                                ),
                                                looptestFlag && isValidLoop
                                                    ? Center(
                                                        child: Container(
                                                          margin:
                                                              const EdgeInsets
                                                                      .fromLTRB(
                                                                  10,
                                                                  10,
                                                                  0,
                                                                  10),
                                                          height: 50,
                                                          width: 210,
                                                          decoration: BoxDecoration(
                                                              borderRadius: BorderRadius
                                                                  .all(Radius
                                                                      .circular(
                                                                          20)),
                                                              color:
                                                                  Colors.green),
                                                          child: Center(
                                                            child:
                                                                Row(children: [
                                                              SizedBox(
                                                                width: 10,
                                                              ),
                                                              Text(
                                                                'Loop Test Success',
                                                                style:
                                                                    TextStyle(
                                                                  fontSize: 18,
                                                                ),
                                                              ),
                                                              Icon(Icons.check)
                                                            ]),
                                                          ),
                                                        ),
                                                      )
                                                    : Container(),
                                              ],
                                            ),
                                          ),
                                        );
                                      }));
                            },
                            child: Image.asset(
                              'assets/loopImg.png',
                              width: 40,
                              height: 40,
                            )),
                        Text(
                          'Loop Test',
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 12,
                              fontWeight: FontWeight.w800),
                        )
                      ]),
                      Column(children: [
                        GestureDetector(
                            child: Image.asset(
                              'assets/loop.png',
                              width: 40,
                              height: 40,
                            ),
                            onTap: () async {
                              fetchTag();
                              await Future.delayed(const Duration(seconds: 4),
                                  () {
                                fetchlcl();
                              });
                              //   dataSend();
                            }),
                        Text(
                          'Refresh',
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 12,
                              fontWeight: FontWeight.w800),
                        )
                      ]),
                      Column(children: [
                        GestureDetector(
                            child: Image.asset(
                              'assets/reportImg.png',
                              width: 40,
                              height: 40,
                            ),
                            onTap: _createPDF),
                        Text(
                          'Report',
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 12,
                              fontWeight: FontWeight.w800),
                        )
                      ]),
                    ],
                  ),
                  SizedBox(height: 35),
                  Container(
                      margin: EdgeInsets.fromLTRB(30, 2, 30, 2),
                      child: Divider(
                        thickness: 3,
                        color: Colors.blue[100],
                      )),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Developed by:',
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.bold),
                      ),
                      Container(
                          height: 40,
                          margin: EdgeInsets.all(5),
                          child: Image.asset('assets/asset.png')),
                    ],
                  ),
                ],
              ),
              //),
            )
          : SafeArea(
              child: Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Container(),
                      _container.connecting(
                          serverName, isConnected, isDisconnecting)
                    ],
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.4,
                  ),
                  CircularProgressIndicator(),
                  Text('$WaitingScreenText'),
                ],
              ),
            )),
    );
  }

  Widget currentCMDWidget2() {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
      Column(children: [
        GestureDetector(
            child: Image.asset(
              'assets/loop.png',
              width: 40,
              height: 40,
            ),
            onTap: () async {
              fetchTag();
              await Future.delayed(const Duration(seconds: 5), () {
                fetchlcl();
              });
            }),
        Text(
          'Refresh',
          style: TextStyle(
              color: Colors.black, fontSize: 16, fontWeight: FontWeight.w800),
        )
      ]),
      Column(children: [
        GestureDetector(
            child: Image.asset(
              'assets/reportImg.png',
              width: 40,
              height: 40,
            ),
            onTap: _createPDF),
        Text(
          'Report',
          style: TextStyle(
              color: Colors.black, fontSize: 16, fontWeight: FontWeight.w800),
        )
      ]),
    ]);
  }

  Future<void> _createPDF() async {
    PdfDocument document = PdfDocument();
    final page = document.pages.add();

    PdfGrid grid = PdfGrid();
    grid.style = PdfGridStyle(
        font: PdfStandardFont(PdfFontFamily.helvetica, 16),
        cellPadding: PdfPaddings(left: 5, right: 2, top: 2, bottom: 2));

    grid.columns.add(count: 3);
    grid.headers.add(1);

    PdfGridRow header = grid.headers[0];
    header.cells[0].value = 'Sl.no';
    header.cells[1].value = 'Parameter';
    header.cells[2].value = 'Value';

    PdfGridRow row = grid.rows.add();

    row.cells[0].value = '1';
    row.cells[1].value = 'Time';
    row.cells[2].value = '${DateTime.now()}';

    row = grid.rows.add();

    row.cells[0].value = '2';
    row.cells[1].value = 'Manufacture Name';
    row.cells[2].value = 'YOKOGAWA';

    row = grid.rows.add();
    row.cells[0].value = '3';
    row.cells[1].value = 'Tag Name';
    row.cells[2].value = '${tagnametodisplay}';

    row = grid.rows.add();
    row.cells[0].value = '4';
    row.cells[1].value = 'Lower Range';
    row.cells[2].value = '${lclnumtodisplay}';

    row = grid.rows.add();
    row.cells[0].value = '5';
    row.cells[1].value = 'Upper Range';
    row.cells[2].value = '${uclnumtodisplay}';

    row = grid.rows.add();
    row.cells[0].value = '6';
    row.cells[1].value = 'Units';
    row.cells[2].value = '${unitNamedValue}';

    row = grid.rows.add();
    row.cells[0].value = '7';
    row.cells[1].value = 'Current Value';
    row.cells[2].value = '${current.toStringAsFixed(3)}';

    row = grid.rows.add();
    row.cells[0].value = '8';
    row.cells[1].value = 'Range';
    row.cells[2].value = '${range.toStringAsFixed(3)}';

    row = grid.rows.add();
    row.cells[0].value = '9';
    row.cells[1].value = 'P Range Value';
    row.cells[2].value = '${process2.toStringAsFixed(3)}';

    grid.draw(page: page, bounds: const Rect.fromLTWH(0, 0, 0, 0));

    List<int> bytes = document.save();
    document.dispose();
    var day = DateTime.now().day;
    var month = DateTime.now().month;
    var hour = DateTime.now().hour;
    var minute = DateTime.now().minute;
    var second = DateTime.now().second;
    String fileName =
        "Report_Date${day}_${month}_${hour}_${minute}_${second}.pdf";
    saveAndLaunchFile(bytes, fileName);
  }

  Widget currentCMDWidget() {
    return Container(
      height: 50,
      width: MediaQuery.of(context).size.width * 0.6,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(10)),
        color: Colors.blue,
      ),
      child: IconButton(
          icon: Image.asset(
            'assets/refresh.png',
            width: 60,
            height: 60,
          ),
          onPressed: () async {
            fetchTag();
            await Future.delayed(const Duration(seconds: 5), () {
              fetchlcl();
            });
          }),
    );
  }

  Widget currentValueShow() {
    return Container(
        margin: EdgeInsets.fromLTRB(20, 10, 20, 10),
        width: double.infinity,
        padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
        decoration: BoxDecoration(
          color: Colors.grey[200],
          border: Border.all(color: Colors.blueAccent),
          borderRadius: BorderRadius.all(Radius.circular(30.0)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Current:',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.w800),
                ),
                Text(
                  currentToDisplay,
                  // '${current.toStringAsFixed(3)}',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.w800),
                ),
              ],
            ),
            SizedBox(
              height: 5,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Range:',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.w800),
                ),
                Text(
                  rangeToDisplay,
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.w800),
                ),
              ],
            ),
            SizedBox(
              height: 5,
            ),
            SizedBox(
              height: 5,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'PRange:',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.w800),
                ),
                Text(
                  '$processToDisplay',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.w800),
                ),
              ],
            ),
          ],
        ));
  }

//conversion Code
  void breaking(List<int> data) {
    List<int> value = data;

    List<int> dataRecieved = isSubArray(value, macaddress, 12);

    List<int> dataRecieved2 = dataRecieved.sublist(4, 12);

    List<int> reverseValue5 = dataRecieved2.toList();

    List<int> currentvalue = reverseValue5.sublist(0, 4);

    List<int> processVariablevalue = reverseValue5.sublist(4, 8);

    var currentValue = _service.convertion(currentvalue);

    var processVariable = _service.convertion(processVariablevalue);
    current = currentValue;
    range = processVariable;

    setState(() {
      current = currentValue;
      range = processVariable;
      currentToDisplay = '${current.toStringAsFixed(3)}';
      rangeToDisplay = '${range.toStringAsFixed(3)}';
    });
  }

  void breaking3(dynamic data) {
   
    List<int> reverseValue = data.sublist(6, 15);
    unitsnamee = reverseValue[0];
    List<dynamic> upperValue = reverseValue.sublist(1, 5);
    List<dynamic> lowerValue = reverseValue.sublist(5, 9);
    double upperValueUCL = _service.convertion(upperValue);
    double lowerValueUCL = _service.convertion(lowerValue);
    uCLVALUE = upperValueUCL;
    lCLVALUE = lowerValueUCL;
    lclnumtodisplay = '${lCLVALUE.toStringAsFixed(3)}';
    uclnumtodisplay = "${uCLVALUE.toStringAsFixed(3)}";
    //  lclController.text= '$lclnumtodisplay';
    // uclController.text= '$uclnumtodisplay';
    print("uclnumtodisplay:$uclnumtodisplay");
    setState(() {
      lclnumtodisplay = lclnumtodisplay;
      uclnumtodisplay = uclnumtodisplay;
      checkingLCLUCL = "checkingLCLUCL Reached";
      upperValueUCL = upperValueUCL;
      lowerValueUCL = lowerValueUCL;
      uCLVALUE = upperValueUCL;
      lCLVALUE = lowerValueUCL;
    });
    for (UnitsModel unit in unitsModel) {
      if (unit.id == unitsnamee) {
        try {
          unitNamedValueCMD[0] = int.parse(unitNamedValue);
        } catch (e) {
          unitNamedValueCMD[0] = 7;
        }

        setState(() {
          unitNamedValue = unit.name;
          unitNamedValueCMD[0] = unitNamedValueCMD[0];
        });
      }
    }
  }

//form submittion
  void _submitForm() async {
    final isValid = _formKey.currentState!.validate();
    if (isValid) {
      _formKey.currentState!.save();
      temptagCode = codeConversation(check1);
      var tagFinalCmdTEMP = tagCMDFirst + temptagCode + tagCMDSecond;
      var tagFinalCmdCheckSUM = getCheckSum(tagFinalCmdTEMP);
      tagFinalCmd =
          preamble + tagFinalCmdTEMP + tagFinalCmdCheckSUM + lastValue;

      setState(() {
        tagFinalCmd = tagFinalCmd;
      });
      _sendMessagee(tagFinalCmd);

      tagFinalCmd = [];
      temptagCode = [];
    } else {}
  
    if (isValid) {
      _formKey.currentState!.save();
      tempunitCode = codeConversation(check1);
      var unitFinalCmdTEMP = unitCMDFirst + tempunitCode + tagCMDSecond;
      var unitFinalCmdCheckSUM = getCheckSum(unitFinalCmdTEMP);
      unitFinalCmd =
          preamble + unitFinalCmdTEMP + unitFinalCmdCheckSUM + lastValue;

      setState(() {
        unitFinalCmd = unitFinalCmd;
      });
      _sendMessagee(unitFinalCmd);

      unitFinalCmd = [];
      tempunitCode = [];
    } else {}
  }

  void _submitForm2() async {
    isValidLoop = _loopKey.currentState!.validate();
    if (isValidLoop) {
      _loopKey.currentState!.save();
      _sendMessagee(loopFinalCmd);
    } else {}
  }

  void _submitForm3() async {
    isValidUCLLCL = ChatService.validatelcl(_lclValue) &&
        ChatService.validateUcl(_uclValue);
    print("#######################################");
    print(lclinput);
    print(_lclValue);
    print(uclCode);
    print(uclinput);
    print(temp3);
    print("#######################################");
    _uclKey.currentState!.validate();
    _lclKey.currentState!.validate();
    if (isValidUCLLCL) {
      _uclKey.currentState!.save();

      ucllclFlag = true;

      while (uclinput.length < 4) {
        uclinput.add(0);
      }
      while (lclinput.length < 4) {
        lclinput.add(0);
      }
      print("&&&&&&&&&&&&&&&&&&&&&");
      print(lclinput);
      print(_lclValue);
      print("&&&&&&&&&&&&&&&&&&&&&");

       var unitFinalCmdTEMP = unitCMDFirst + tempunitCode + unitCMDSecond;
      var unitFinalCmdCheckSUM = getCheckSum(unitFinalCmdTEMP);
      unitFinalCmd =
          preamble + unitFinalCmdTEMP + unitinput + unitFinalCmdCheckSUM ;

      setState(() {
        unitFinalCmd = unitFinalCmd;
      });
      _sendMessagee(unitFinalCmd);

      unitFinalCmd = [];
      tempunitCode = [];
      var cmdforlcluclTEMP =
          lcluclCmd1 + unitinput + uclinput + lclinput; //+ lcluclCmd2;
      List<int> checkSum = getCheckSum(cmdforlcluclTEMP);

      cmdforlclucl = preamble + cmdforlcluclTEMP + checkSum + lcluclCmd2;
      setState(() {
        cmdforlclucl = cmdforlclucl;
      });
      print("===========================");
      print("lower range debug $cmdforlclucl");
      print("===========================");
      _sendMessagee(cmdforlclucl);

      await Future.delayed(const Duration(seconds: 8), () {
        ucllclFlag = false;
      });
      //
    } else {}
  }

  Widget deviceDetails() {
    return Container(
        margin: EdgeInsets.fromLTRB(20, 10, 20, 10),
        padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
        decoration: BoxDecoration(
          color: Colors.grey[200],
          border: Border.all(color: Colors.blueAccent),
          borderRadius: BorderRadius.all(Radius.circular(30.0)),
        ),
        child: screenLoaded
            ? Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Manufacturer Name:',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.w800),
                      ),
                      manufacture.length >= 28
                          ? Flexible(
                              child: manufactureNumber == 55
                                  ? Text(
                                      'YOKOGAWA',
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w800),
                                    )
                                  : Text(
                                      'Others',
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w800),
                                    ))
                          : Text('')
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                          child: Text(
                        'Tag Name:',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.w800),
                      )),
                      Flexible(
                          child: tag.length >= 30
                              ? Text(
                                  tagnametodisplay,
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w800),
                                )
                              : Text(''))
                    ],
                  ),
                  // Text("current: $dataa"),
                  // Text("process: $processint"),
                  SizedBox(
                    height: 10,
                  ),
                  lcluclWidget(),
                  SizedBox(
                    height: 10,
                  ),
                ],
              )
            : Container(
                child: Column(
                  children: [
                    CircularProgressIndicator(),
                    Text('Loading Dashboard')
                  ],
                ),
              ));
  }

  Widget lcluclWidget() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Lower Range:',
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.w800),
            ),
            Text(
              lclnumtodisplay,
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.w800),
            )
          ],
        ),
        SizedBox(
          height: 10,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Upper Range:',
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.w800),
            ),
            Text(
              uclnumtodisplay,
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.w800),
            )
          ],
        ),
        SizedBox(
          height: 10,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Units Name:',
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.w800),
            ),
            Text(
              unitNamedValue,
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.w800),
            )
          ],
        ),
      ],
    );
  }
//Trimming Widgets______________________________________________________________________________________
//______________________________________________________________________________________________________
//______________________________________________________________________________________________________
//Zero Trimming, Upper Trimming , Lower Trimming , OutputTrimming Widgets are below.

//Zero Triming Widget
  Widget zerotrim() {
    return Center(
      child: SizedBox(
        width: 200,
        child: ElevatedButton(
          onPressed: () async {
            await showDialog(
                context: context,
                builder: (BuildContext context) =>
                    StatefulBuilder(builder: (ctx, setStateModal) {
                      return AlertDialog(
                        title: Text("Zero Trimming"),
                        content: Text(
                            "Please Tap on below button to complete Zero Trimming"),
                        actions: <Widget>[
                          ElevatedButton(
                            onPressed: () async {
                              stopFlag = true;
                              setStateModal(() {
                                zerotrimflagg = true;
                              });
                              await _sendMessagee(zeroTrimTemp);

                              await Future.delayed(const Duration(seconds: 3),
                                  () {
                                stopFlag = false;
                                setStateModal(() {
                                  zerotrimflagg = false;
                                });
                              });
                              outer = false;
                              Navigator.of(ctx).pop();
                            },
                            child: Text("Zero Trimming"),
                          ),
                        ],
                      );
                    }));
            await showDialog(
                context: context,
                builder: (ctx) {
                  Future.delayed(Duration(seconds: 2), () {
                    Navigator.of(context).pop(true);
                  });
                  return AlertDialog(
                    content: Text("Zero Trim Completed Successfull"),
                  );
                });
          },
          child: Text("Zero Trimming"),
        ),
      ),
    );
  }

//Upper Triming Widget
  Widget uppertrim() {
    return Center(
      child: SizedBox(
        width: 200,
        child: ElevatedButton(
          onPressed: () async {
            await showDialog(
              context: context,
              builder: (ctx) => AlertDialog(
                title: Text("Action needed"),
                content: Text("Do you want to do upper trim"),
                actions: <Widget>[
                  ElevatedButton(
                    onPressed: () {
                      higher = true;
                      Navigator.of(ctx).pop();
                    },
                    child: Text("OK"),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      higher = false;
                      Navigator.of(ctx).pop();
                    },
                    child: Text("Cancel"),
                  ),
                ],
              ),
            );

            if (higher) {
              await showDialog(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: Text("Action needed"),
                  content: Text("Apply High Pressure"),
                  actions: <Widget>[
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(ctx).pop();
                      },
                      child: Text("OK"),
                    ),
                  ],
                ),
              );
              await showDialog(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: Text("Please Wait till pressure becomes stable"),
                  actions: <Widget>[
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(ctx).pop();
                      },
                      child: Text("OK"),
                    ),
                  ],
                ),
              );
              await showDialog(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: Text(
                      "Enter the pressure value applied in $unitNamedValue"),
                  content: Form(
                    key: _highKey,
                    child: TextFormField(
                        key: ValueKey('low'),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter a valid pressure Name';
                          }
                          return 'null';
                        },
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.fromLTRB(30, 30, 30, 8),
                          border: const UnderlineInputBorder(),
                          filled: true,
                          hintText: 'Enter $unitNamedValue value',
                          hintStyle:
                              TextStyle(color: Colors.grey, fontSize: 20),
                          fillColor: Colors.white,
                        ),
                        keyboardType: TextInputType.number,
                        initialValue: '2000',
                        onSaved: (value) {
                          _highKeyValue = getNumConversation(value ?? '');
                        }),
                  ),
                  actions: <Widget>[
                    ElevatedButton(
                      onPressed: () async {
                        stopFlag = true;

                        _highKey.currentState!.save();
                        List<int> checkSumhighkey = getCheckSum(
                            higherCMD + unitNamedValueCMD + _highKeyValue);
                        List<int> cmdhighkey = preamble +
                            higherCMD +
                            unitNamedValueCMD +
                            _highKeyValue +
                            checkSumhighkey +
                            lastValue;
                        await _sendMessagee(cmdhighkey);

                        await Future.delayed(const Duration(seconds: 3), () {
                          stopFlag = false;
                        });

                        Navigator.of(ctx).pop();
                      },
                      child: Text("OK"),
                    ),
                  ],
                ),
              );
              await showDialog(
                  context: context,
                  builder: (ctx) {
                    Future.delayed(Duration(seconds: 2), () {
                      Navigator.of(context).pop(true);
                    });
                    return AlertDialog(
                      content: Text("Upper Trim Completed Successfull"),
                    );
                  });
            }
          },
          child: Text("Up Trimming"),
        ),
      ),
    );
  }

//Lower Triming Widget
  Widget lowertrim() {
    return Center(
      child: SizedBox(
        width: 200,
        child: ElevatedButton(
          onPressed: () async {
            await showDialog(
              context: context,
              builder: (ctx) => AlertDialog(
                title: Text("Action needed"),
                content: Text("Do you want to do lower trim"),
                actions: <Widget>[
                  ElevatedButton(
                    onPressed: () {
                      lower = true;
                      Navigator.of(ctx).pop();
                    },
                    child: Text("OK"),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      lower = false;
                      Navigator.of(ctx).pop();
                    },
                    child: Text("Cancel"),
                  ),
                ],
              ),
            );

            if (lower) {
              await showDialog(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: Text("Action needed"),
                  content: Text("Apply Low Pressure"),
                  actions: <Widget>[
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(ctx).pop();
                      },
                      child: Text("OK"),
                    ),
                  ],
                ),
              );
              await showDialog(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: Text("Please Wait till pressure becomes stable"),
                  actions: <Widget>[
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(ctx).pop();
                      },
                      child: Text("OK"),
                    ),
                  ],
                ),
              );
              await showDialog(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: Text(
                      "Enter the pressure value applied in $unitNamedValue"),
                  content: Form(
                    key: _lowKey,
                    child: TextFormField(
                      key: ValueKey('low'),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter a valid pressure Name';
                        }
                        return 'null';
                      },
                      keyboardType: TextInputType.number,
                      initialValue: '0',
                      style: TextStyle(
                        fontSize: 20,
                      ),
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.fromLTRB(30, 30, 30, 8),
                        border: const UnderlineInputBorder(),
                        filled: true,
                        hintText: 'Enter $unitNamedValue value',
                        hintStyle: TextStyle(color: Colors.grey, fontSize: 20),
                        fillColor: Colors.white,
                      ),
                      onSaved: (value) {
                        _lowKeyValue = getNumConversation(value ?? '');
                      },
                    ),
                  ),
                  actions: <Widget>[
                    ElevatedButton(
                      onPressed: () async {
                        stopFlag = true;

                        _lowKey.currentState!.save();
                        List<int> checkSumlowkey = getCheckSum(
                            lowerCMD + unitNamedValueCMD + _lowKeyValue);
                        List<int> cmdlowkey = preamble +
                            lowerCMD +
                            unitNamedValueCMD +
                            _lowKeyValue +
                            checkSumlowkey +
                            lastValue;
                        await _sendMessagee(cmdlowkey);

                        await Future.delayed(const Duration(seconds: 3), () {
                          stopFlag = false;
                        });

                        Navigator.of(ctx).pop();
                      },
                      child: Text("OK"),
                    ),
                  ],
                ),
              );
              await showDialog(
                  context: context,
                  builder: (ctx) {
                    Future.delayed(Duration(seconds: 2), () {
                      Navigator.of(context).pop(true);
                    });
                    return AlertDialog(
                      content: Text("Lower Trim Completed Successfull"),
                    );
                  });
            }
          },
          child: Text("Low Trimming"),
        ),
      ),
    );
  }

//Output Triming Widget
  Widget outputtrim() {
    return Center(
      child: SizedBox(
        width: 200,
        child: ElevatedButton(
          onPressed: () async {
            await showDialog(
              context: context,
              builder: (ctx) => AlertDialog(
                title: Text("Action needed"),
                content: Text("Connect Reference meter and press ok"),
                actions: <Widget>[
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(ctx).pop();
                    },
                    child: Text("OK"),
                  ),
                ],
              ),
            );
            await showDialog(
              context: context,
              builder: (ctx) => AlertDialog(
                title: Text("Action needed"),
                content: Text("press OK to trim output current for 4 mA"),
                actions: <Widget>[
                  ElevatedButton(
                    onPressed: () async {
                      await _sendMessagee(outerLowCMDTemp);

                      Navigator.of(ctx).pop();
                    },
                    child: Text("OK"),
                  ),
                ],
              ),
            );
            await showDialog(
              context: context,
              builder: (ctx) => AlertDialog(
                title: Text("Action needed"),
                content:
                    Text("Feild device output 4ma equal to reference meter?"),
                actions: <Widget>[
                  ElevatedButton(
                    onPressed: () {
                      outer = true;
                      outerlowCHECK = true;
                      Navigator.of(ctx).pop();
                    },
                    child: Text("YES"),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      outerlowCHECK = false;
                      outer = false;
                      Navigator.of(ctx).pop();
                    },
                    child: Text("NO"),
                  ),
                ],
              ),
            );
            if (outerlowCHECK == false) {
              await showDialog(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: Text("Enter the meter value"),
                  content: Form(
                    key: _outerKey,
                    child: TextFormField(
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.fromLTRB(30, 30, 30, 8),
                        border: const UnderlineInputBorder(),
                        filled: true,
                        hintText: 'Enter value',
                        hintStyle: TextStyle(color: Colors.grey, fontSize: 20),
                        fillColor: Colors.white,
                      ),
                      keyboardType: TextInputType.number,
                      initialValue: '4.0',
                      onSaved: (value) {
                        var valueEnteredTemp = value;
                        valueEntered =
                            getNumConversation(valueEnteredTemp ?? '');
                      },
                    ),
                  ),
                  actions: <Widget>[
                    ElevatedButton(
                      onPressed: () async {
                        _outerKey.currentState!.save();
                        List<int> outerLowCMDModificationTemp =
                            outerLowCMDModification + valueEntered;
                        List<int> outerLowCMDModificationCheckSum =
                            getCheckSum(outerLowCMDModificationTemp);
                        List<int> finalouterCMD = preamble +
                            outerLowCMDModificationTemp +
                            outerLowCMDModificationCheckSum +
                            lastValue;
                        await _sendMessagee(finalouterCMD);

                        Navigator.of(ctx).pop();
                      },
                      child: Text("OK"),
                    ),
                  ],
                ),
              );
            }
            await showDialog(
              context: context,
              builder: (ctx) => AlertDialog(
                title: Text("Action needed"),
                content: Text("press OK to trim output current for 20 mA"),
                actions: <Widget>[
                  ElevatedButton(
                    onPressed: () async {
                      stopFlag = true;
                      await _sendMessagee(outerHighCMDTemp);

                      await Future.delayed(const Duration(seconds: 3), () {
                        stopFlag = false;
                      });

                      Navigator.of(ctx).pop();
                    },
                    child: Text("OK"),
                  ),
                ],
              ),
            );
            await showDialog(
              context: context,
              builder: (ctx) => AlertDialog(
                title: Text("Action needed"),
                content:
                    Text("Feild device output 20ma equal to reference meter?"),
                actions: <Widget>[
                  ElevatedButton(
                    onPressed: () {
                      outer = true;
                      outerHIGHCHECK = true;
                      Navigator.of(ctx).pop();
                    },
                    child: Text("YES"),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      outerHIGHCHECK = false;
                      outer = false;
                      Navigator.of(ctx).pop();
                    },
                    child: Text("NO"),
                  ),
                ],
              ),
            );
            if (outerHIGHCHECK == false) {
              await showDialog(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: Text("Enter the meter value"),
                  content: Form(
                    key: _outerHighKey,
                    child: TextFormField(
                      keyboardType: TextInputType.number,
                      initialValue: '20.0',
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.fromLTRB(30, 30, 30, 8),
                        border: const UnderlineInputBorder(),
                        filled: true,
                        hintText: 'Enter value',
                        hintStyle: TextStyle(color: Colors.grey, fontSize: 20),
                        fillColor: Colors.white,
                      ),
                      onSaved: (value) {
                        var valueEnteredTemp = value;
                        valueEnteredOUTERHIGH =
                            getNumConversation(valueEnteredTemp ?? '');
                      },
                    ),
                  ),
                  actions: <Widget>[
                    ElevatedButton(
                      onPressed: () async {
                        _outerHighKey.currentState!.save();
                        List<int> outerLowCMDModificationTemp =
                            outerLowCMDModificationSecond +
                                valueEnteredOUTERHIGH;
                        List<int> outerLowCMDModificationCheckSum =
                            getCheckSum(outerLowCMDModificationTemp);

                        List<int> finalouterCMD = preamble +
                            outerLowCMDModificationTemp +
                            outerLowCMDModificationCheckSum +
                            lastValue;
                        await _sendMessagee(finalouterCMD);

                        outer = true;
                        Navigator.of(ctx).pop();
                      },
                      child: Text("OK"),
                    ),
                  ],
                ),
              );
            }

            await showDialog(
              context: context,
              builder: (ctx) => AlertDialog(
                title: Text("Action needed"),
                content: Text("Loop return to automatic control"),
                actions: <Widget>[
                  ElevatedButton(
                    onPressed: () async {
                      await _sendMessagee(automaticControlTemp);

                      await Future.delayed(const Duration(seconds: 3), () {
                        stopFlag = false;
                      });
                      outer = false;
                      Navigator.of(ctx).pop();
                    },
                    child: Text("OK"),
                  ),
                ],
              ),
            );
          },
          child: Text("Output Trimming"),
        ),
      ),
    );
  }
}
