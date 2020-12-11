part of benchmarker;

class BenchmarkingData<T> {
  DateTime start;
  DateTime finish;
  T data;
  dynamic error;

  BenchmarkingData({
    this.start,
    this.finish,
    this.data,
    this.error,
  });

  double getDifferenceInSecond() {
    int _interval = this.finish.difference(this.start).inMilliseconds;
    return _interval / 1000;
  }

  int getDifferenceInMillisecond() {
    int _interval = this.finish.difference(this.start).inMilliseconds;
    return _interval;
  }
}

class BenchmarkedData<T> {
  double time;
  List<BenchmarkingData<T>> list;

  BenchmarkedData({
    this.list,
    this.time
  });
}

class LongestAndShortestBenchmarkData<T> {
  BenchmarkedData<T> shortest;
  BenchmarkedData<T> longest;

  LongestAndShortestBenchmarkData({
    this.shortest,
    this.longest
  });
}