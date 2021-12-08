import 'dart:convert';
import 'dart:core';

List<int> codeConversation(String data2) {
  String data = data2.toUpperCase();
  List<int> numeric = [];
  for (int i = 0; i < data.length; i++) {
    int tempValue = utf8.encode(data[i])[0] - 64;
    if (tempValue < 0) {
      numeric.add(tempValue + 64);
    } else {
      numeric.add(tempValue);
    }
  }
  int length = (numeric.length / 4).ceil();
  int reminder = (numeric.length % 4);
  for (int i = length * 4 - (4 - reminder); i < length * 4; i++) {
    numeric.add(0);
  }
  int value1 = 0;
  int value2 = 0;
  int value3 = 0;
  int twoiterations = 0;
  int sixiterations = 0;
  int count = 0;
  List<int> finalData = [];
  int index = 0;
  while (length > index) {
    value1 =
        (256 * numeric[4 * index + 0] + numeric[4 * index + 1]) & 0xffffffff;
    value2 =
        (256 * numeric[4 * index + 2] + numeric[4 * index + 3]) & 0xffffffff;
    value3 = (256 * 256 * value1 + value2) & 0xffffffff;
    int i = 0;
    while (i < 4) {
      for (int i = 0; i < 2; i++) {
        value3 = value3 << 1;
        var num = value3 & 0xffffffff;
        twoiterations = num.toInt();
      }
      for (int i = 0; i < 6; i++) {
        if (count != 0) {
          count = count << 1;
          count = count & 0xffffffff;
        }
        if (value3 >> 31 == 1) {
          count++;
          count = count & 0xffffffff;
        }

        value3 = value3 << 1;
        value3 = value3 & 0xffffffff;
        sixiterations = value3 & 0xffffffff;
      }
      value3 = twoiterations << 6;
      value3 = value3 & 0xffffffff;
      i++;
    }

    var finalValue = count.toRadixString(16);
    var secondValue = count % 65536;
    var firstValue = (count / 65536).floor();

    finalData.add(firstValue % 256);
    finalData.add((secondValue / 256).floor());
    finalData.add(secondValue % 256);

    value1 = 0;
    value2 = 0;
    value3 = 0;
    twoiterations = 0;
    sixiterations = 0;
    count = 0;
    index++;
  }
  for (int i = finalData.length; i < 6; i++) {
    finalData.add(0);
  }
  return (finalData);
}
