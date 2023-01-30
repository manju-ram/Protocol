import 'dart:typed_data';
import 'dart:core';

List<int> getNumConversation(String data) {
   var loopCode;
 try{
  loopCode = double.parse(data);
 }
 catch(e){
     loopCode =0.0;
 }
  List<int> myList = Float32List.fromList([loopCode]).buffer.asUint8List();
  List<int> bytes = new List.from(myList.reversed);
  return bytes;
}