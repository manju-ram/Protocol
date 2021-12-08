import 'dart:typed_data';
import 'dart:core';

List<int> getNumConversation(String data) {
  var loopCode = double.parse(data);
  List<int> myList = Float32List.fromList([loopCode]).buffer.asUint8List();
  List<int> bytes = new List.from(myList.reversed);
  return bytes;
}