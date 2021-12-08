import 'package:testingone/service/is_subarray.dart';

List<int> getAddressData(List<int> data) {
  List<int> dataRecieved2 = isSubArray(data, [6, 0, 0, 14], 14);
  List<int> dataRecieved = dataRecieved2.sublist(2, 14);
  List<int> finalAddress = [];
  int data1 = dataRecieved[1] + 128;
  int data2 = dataRecieved[2];
  int data3 = dataRecieved[9];
  int data4 = dataRecieved[10];
  int data5 = dataRecieved[11];
  finalAddress.add(data1);
  finalAddress.add(data2);
  finalAddress.add(data3);
  finalAddress.add(data4);
  finalAddress.add(data5);
  return finalAddress;
}
