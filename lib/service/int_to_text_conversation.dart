String reverseConversation(List<int> data2) {
  String text = '';
  List<int> dataConvert = [];
  int length = (data2.length / 3).ceil();

  List<int> numeric1 = data2.sublist(0, 3);
  List<int> numeric2 = data2.sublist(3, 6);
  List<int> numeric = data2;
  int value1 = 0;
  int value2 = 0;
  int value3 = 0;
  int index = 0;
  double twoiterations = 0;
  double count = 0;
  double sixiterations = 0;
  bool flag = false;
  while (length > index) {
    count = 0;
    value1 = (256 * numeric[3 * index + 1] + numeric[3 * index + 2]);
    value3 = (256 * 256 * numeric[3 * index + 0] + value1);
    int i = 0;
    int d = 1;
    while (i < 4) {
      for (int i = 0; i < 6; i++) {
        if (value3 % 2 == 1) {
          value3 = value3 >> 1;

          count = ((count.ceil() / 2).toInt() | 0x80000000).toDouble();

          continue;
        }

        if (value3 % 2 == 0) {
          count = count / 2;
          count = count;
        }
        value3 = value3 >> 1;
        value3 = value3;
      }
      count = count / 4;
      i++;
    }
    double genuis1 = count / 65536;
    double genuis2 = count % 65536;
    double genuis3 = genuis1 / 256;
    double genuis4 = genuis1 % 256;
    double genuis5 = genuis2 / 256;
    double genuis6 = genuis2 % 256;

    dataConvert
        .add(genuis3.round() >= 48 ? genuis3.round() - 64 : genuis3.round());
    dataConvert
        .add(genuis4.round() >= 48 ? genuis4.round() - 64 : genuis4.round());
    dataConvert
        .add(genuis5.round() >= 48 ? genuis5.round() - 64 : genuis5.round());
    dataConvert
        .add(genuis6.round() >= 48 ? genuis6.round() - 64 : genuis6.round());

    index++;
  }

  for (int i = 0; i < 8; i++) {
    if (dataConvert[i] != 0) {
      text += String.fromCharCode(dataConvert[i] + 64);
    }
  }
  return text;
}
