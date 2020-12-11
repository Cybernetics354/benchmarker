part of benchmarker;

class BenchmarkController<T> {
  String name;
  String description;

  List<BenchmarkingData<T>> data = [];
  Timer _timer;
  final _streamController = StreamController<List<BenchmarkingData<T>>>.broadcast();
  Stream<List<BenchmarkingData<T>>> get stream => _streamController.stream;

  startWithCron(Duration duration, BenchmarkFunction<T> callback) {
    if(_timer?.isActive == true) {
      _timer?.cancel();
    }
    
    _timer = new Timer(duration, () async {
      DateTime _start = DateTime.now();
      try {
        T _data = await callback();
        addingToController(BenchmarkingData<T>(
          start: _start,
          finish: DateTime.now(),
          data: _data,
          error: null
        ));
        startWithCron(duration, callback);
      } catch (e) {
        addingToController(BenchmarkingData<T>(
          data: null,
          start: _start,
          finish: DateTime.now(),
          error: e
        ));
        startWithCron(duration, callback);
      }
    });

    
  }

  Future<bool> startWithCount(int count, BenchmarkFunction<T> callback) async {
    for(int i = 0; i < count; i++) {
      DateTime _start = DateTime.now();
      try {
        T _data = await callback();
        addingToController(BenchmarkingData<T>(
          data: _data,
          start: _start,
          finish: DateTime.now(),
          error: null
        ));
      } catch (e) {
        addingToController(BenchmarkingData<T>(
          data: null,
          start: _start,
          finish: DateTime.now(),
          error: e
        ));
      }
    }

    return true;
  }

  clearData() {
    data = [];
    _streamController.sink.add(data);
  }

  stopCron() {
    _timer?.cancel();
  }

  addingToController(BenchmarkingData<T> benchmarkingData) {
    data.add(benchmarkingData);
    _streamController.sink.add(data);
  }

  dispose() {
    _streamController?.close();
    _timer?.cancel();
  }

  BenchmarkController({
    @required this.name,
    this.description
  });
}

showSummaryBenchmark(BuildContext context, List<BenchmarkController> benchmarkList) {
  Navigator.push(context, MaterialPageRoute(
    builder: (_) => SummaryBenchmarkMainView(benchmarkControllers: benchmarkList,)
  ));
}

typedef BenchmarkFunction<T> = Future<T> Function();

class BenchmarkingUtils {
  static final BenchmarkingUtils _singleton = BenchmarkingUtils._();
  BenchmarkingUtils._();

  static BenchmarkingUtils get instance => _singleton;

  LongestAndShortestBenchmarkData<T> getLongestAndShortest<T>(List<BenchmarkingData<T>> data) {
    LongestAndShortestBenchmarkData<T> _data = LongestAndShortestBenchmarkData<T>(
      longest: BenchmarkedData<T>(
        list: [],
        time: null
      ),
      shortest: BenchmarkedData<T>(
        list: [],
        time: null
      ),
    );

    data.forEach((element) {
      double time = element.getDifferenceInSecond();
      if(_data.shortest.time == null) {
        _data.shortest.time = time;
        _data.shortest.list.add(element);
      }

      if(_data.longest.time == null) {
        _data.longest.time = time;
        _data.longest.list.add(element);

        return;
      }

      if(_data.shortest.time == time) {
        _data.shortest.list.add(element);
        return;
      }

      if(_data.longest.time == time) {
        _data.longest.list.add(element);
        return;
      }

      if(_data.shortest.time > time) {
        _data.shortest.time = time;
        _data.shortest.list = [
          element
        ];

        return;
      }

      if(_data.longest.time < time) {
        _data.longest.time = time;
        _data.longest.list = [
          element
        ];
      }
    });

    return _data;
  }
}