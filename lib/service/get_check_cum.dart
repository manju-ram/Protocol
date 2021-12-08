List<int> getCheckSum(List<int> data) {
  var fort = data[0];
  int result = 0;
  for (int i = 1; i < data.length; i++) {
    result = (fort ^ data[i]);
    fort = result;
  }
  return [result];
}