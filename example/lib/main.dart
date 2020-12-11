import 'package:benchmarker/benchmarker.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Benchmark testing",
      home: HomeMainView(),
    );
  }
}

class HomeMainView extends StatefulWidget {
  @override
  _HomeMainViewState createState() => _HomeMainViewState();
}

class _HomeMainViewState extends State<HomeMainView> {
  final BenchmarkController<String> _benchmarkString = new BenchmarkController<String>(
    name: "String",
    description: "For String"
  );

  final BenchmarkController<int> _benchmarkInt = new BenchmarkController<int>(
    name: "Int",
    description: "For Int"
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: "start",
            child: Icon(Icons.access_time),
            onPressed: () async {
              await _benchmarkString.startWithCount(10, () async {
                return "Lorem";
              });
              await _benchmarkInt.startWithCount(10, () async {
                return 10;
              });
            },
          ),
          FloatingActionButton(
            heroTag: "clear",
            child: Icon(Icons.remove),
            onPressed: () {
              _benchmarkString.clearData();
              _benchmarkInt.clearData();
            },
          )
        ],
      ),
      appBar: AppBar(
        actions: [
          IconButton(
            icon: Icon(Icons.list),
            onPressed: () {
              showSummaryBenchmark(context, [_benchmarkString, _benchmarkInt]);
            },
          )
        ],
        title: Text("Benchmarking"),
      ),
      body: Center(
        child: Container(
          child: StreamBuilder<List<BenchmarkingData<String>>>(
            stream: _benchmarkString.stream,
            builder: (context, snapshot) {
              if(snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: Text("Tap FAB Untuk memulai"),
                );
              }

              final _data = snapshot.data;
              return ListView.builder(
                itemCount: _data.length,
                itemBuilder: (context, index) {
                  final _cindex = _data[index];
                  return ListTile(
                    title: Text(_cindex.data??"Error Occured : ${_cindex.error.toString()}"),
                    subtitle: Text(_cindex.getDifferenceInSecond().toString() + " s"),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}