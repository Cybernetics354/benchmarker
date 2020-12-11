part of benchmarker;

class SummaryBenchmarkMainView extends StatelessWidget {
  final List<BenchmarkController> benchmarkControllers;
  SummaryBenchmarkMainView({
    this.benchmarkControllers
  });
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Summary"),
      ),
      body: Center(
        child: benchmarkControllers.length == 0 || benchmarkControllers == null ? Center(
          child: Text("Tidak ada yang ditampilkan"),
        ) : Container(
          child: Align(
            alignment: Alignment.topCenter,
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              padding: EdgeInsets.only(bottom: 100.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _CardContainerViewWidget(
                    title: "Graphics",
                    description: "In Milliseconds",
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: 300.0,
                      child: chart.TimeSeriesChart(
                        List.generate(benchmarkControllers.length, (index) {
                          final _cindex = benchmarkControllers[index];
                          return chart.Series<BenchmarkingData, DateTime>(
                            data: _cindex.data,
                            id: _cindex.name,
                            domainFn: (BenchmarkingData data, _) => data.finish,
                            measureFn: (BenchmarkingData data, _) => data.getDifferenceInMillisecond(),
                          );
                        }),
                        defaultRenderer: chart.LineRendererConfig(
                          includeArea: true
                        ),
                        animate: true,
                        defaultInteractions: true,
                      ),
                    ),
                  ),
                  Column(
                    children: List.generate(benchmarkControllers.length, (index) {
                      final _cindex = benchmarkControllers[index];
                      final _benchmark = BenchmarkingUtils.instance.getLongestAndShortest(_cindex.data);
                      return _CardContainerViewWidget(
                        title: _cindex.name,
                        description: _cindex.description,
                        child: Column(
                          children: [
                            _RowViewWidget(
                              title: "Start Time",
                              value: _cindex.data[0].start.toString(),
                            ),
                            _RowViewWidget(
                              title: "Finish Time",
                              value: _cindex.data[_cindex.data.length-1].finish.toString(),
                            ),
                            _RowViewWidget(
                              title: "Total Count",
                              value: _cindex.data.length.toString(),
                            ),
                            _RowViewWidget(
                              title: "Total Time (sec)",
                              value: "${_cindex.data[_cindex.data.length-1].finish.difference(_cindex.data[0].start).inMilliseconds / 1000} s",
                            ),
                            _RowViewWidget(
                              title: "Average Time Elapsed (sec)",
                              value: "${(_cindex.data[_cindex.data.length-1].finish.difference(_cindex.data[0].start).inMilliseconds / 1000) / _cindex.data.length} s",
                            ),
                            _RowViewWidget(
                              title: "Fastest (${_benchmark.shortest.list.length})",
                              value: "${_benchmark.shortest.time} s",
                            ),
                            _RowViewWidget(
                              title: "Longest (${_benchmark.longest.list.length})",
                              value: "${_benchmark.longest.time} s",
                            ),
                          ],
                        ),
                      );
                    }),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _RowViewWidget extends StatelessWidget {
  final String title;
  final String value;
  _RowViewWidget({
    this.title,
    this.value
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title),
        Text(value, style: TextStyle(fontWeight: FontWeight.bold),)
      ],
    );
  }
}

class _CardContainerViewWidget extends StatelessWidget {
  final String title;
  final String description;
  final Widget child;

  _CardContainerViewWidget({
    @required this.title,
    @required this.child,
    this.description
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Divider(),
          Text(title, style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),),
          description != null ? Text(description, style: TextStyle(fontSize: 13.0)) : SizedBox(),
          SizedBox(height: 10.0),
          child
        ],
      ),
    );
  }
}