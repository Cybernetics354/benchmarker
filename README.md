# benchmarker

A Package for benchmarking function

## Purpose

There's so many packages in dart nor flutter, and we doesn't know which one is faster, then you need benchmarking them first.

## Usage

The usage is simple, just create some `BenchmarkController`
```dart
final BenchmarkController<String> _benchmarkString = new BenchmarkController<String>(
    name: "String",
    description: "For String"
);

final BenchmarkController<int> _benchmarkInt = new BenchmarkController<int>(
    name: "Int",
    description: "For Int"
);
```

then we can go start some benchmark testing

```dart
await _benchmarkString.startWithCount(10, () async {
    return "Lorem";
});
await _benchmarkInt.startWithCount(10, () async {
    return 10;
});
```

You can stream to controller's data too

```dart
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
```

and also you can compare some controller too

```dart
showSummaryBenchmark(context, [_benchmarkString, _benchmarkInt]);
```

That's it, Happy Fluttering @Cybernetics Core

