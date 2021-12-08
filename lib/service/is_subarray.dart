List<int> isSubArray(List<int> A, List<int> B, int len) {
  int n = A.length;
  int m = B.length;
  int i = 0, j = 0;
  while (i < n && j < m) {
    if (A[i] == B[j]) {
      i++;
      j++;
      if (j == m) {
        var data = A.sublist(i, i + len);
        return data;
      }
    } else {
      i = i - j + 1;
      j = 0;
    }
  }
  return [-1];
}