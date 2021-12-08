class Command {
  //used to fetch the address of the DUT
  static List<int> initailAddress = [
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
  ];

  //used to fetch manufacturer name
  static List<int> manufacturerCMD = [0x00, 0x00];

  //used to fetch Tag name
  static List<int> despritionTagCMD = [0x0D, 0x00];

  //used to fetch upperandlowerLimit name
  static List<int> upperlimitlowerTagCMD = [0x0F, 0x00];

  //used to fetch current name
  static List<int> currentCMD = [0x02, 0x00];

  //used to fetch prange name
  static List<int> processCMD = [0x1, 0x0];

  //used to set tag name initial prefix
  static List<int> tagCMDFirst = [0x12, 0x15];

//used to set tag name initial suffix
  static List<int> tagCMDSecond = [
    0x14,
    0xA0,
    0x71,
    0xC7,
    0x0,
    0x0,
    0x0,
    0x0,
    0x0,
    0x0,
    0x0,
    0x0,
    0x0,
    0x0,
    0x0
  ];

//used for loop testing prefix command
  static List<int> loopFirst = [0x28, 0x4];

//used for loop testing suffix command
  static List<int> loopSecond = [0x33];

//used for get the automatic loop control
  static List<int> automaticControl = [0x28, 0x4, 0x00, 0x00, 0x0, 0x0];

  static List<int> outerLowCMD = [0x28, 0x4, 0x40, 0x80, 0x0, 0x0];

  static List<int> outerLowCMDModification = [0x2D, 0x4];

  static List<int> outerLowCMDModificationSecond = [0x2E, 0x4];

  static List<int> outerHighCMD = [0x28, 0x4, 0x41, 0xA0, 0x0, 0x0];

  static List<int> lowerCMD = [0x83, 0x5];

  static List<int> higherCMD = [0x82, 0x5];

  static List<int> zeroTrimCmd = [0x2B, 0x0];

  static List<int> lcluclCmd = [
    0x23,
    0x9,
    0x4,
    0x44,
    0xF9,
    0xE0,
    0x0,
    0x3F,
    0x80,
    0x00,
    0x00,
    0xB2
  ];
  static List<int> lcluclCmd1 = [0x23, 0x9];
  static List<int> lcluclCmd2 = [0xB2];

  static List<int> FetchlcluclCMD = [0xF, 0x0, 0x71];
}
