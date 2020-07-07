class Ticker {
  Stream<int> tick({int start = 0}) {
    return Stream.periodic(Duration(seconds: 1), (x) => start + x + 1);
  }
}