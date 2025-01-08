import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:syncfusion_flutter_charts/charts.dart';

class ChartPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('图表')),
      body: Center(
        child: Container(
          height: MediaQuery.of(context).size.height / 3,
          padding: EdgeInsets.all(16),
          child: StockChart(),
        ),
      ),
    );
  }
}

class StockChart extends StatefulWidget {
  @override
  _StockChartState createState() => _StockChartState();
}

class _StockChartState extends State<StockChart> {
  List<Map<String, dynamic>> stockData = [];
  bool isLoading = true;
  ChartInfo? chartInfo; // 声明为可空类型

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchStockData() async {
    try {
      final response = await http
          .get(Uri.parse('http://localhost:8080/stockdata'))
          .timeout(Duration(seconds: 10));

      if (response.statusCode == 200) {
        setState(() {
          stockData =
              List<Map<String, dynamic>>.from(json.decode(response.body));
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load stock data');
      }
    } catch (e) {
      setState(() => isLoading = false);
      print('Error: $e');
    }
  }

  Future<void> fetchChartInfo() async {
    try {
      final response = await http
          .get(Uri.parse('http://localhost:8080/chartinfo'))
          .timeout(Duration(seconds: 10));

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = json.decode(response.body);
        setState(() {
          chartInfo = ChartInfo.fromJson(jsonData);
        });
      } else {
        throw Exception('Failed to load chart info: ${response.statusCode}');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print('Error fetching chart info: $e');
    }
  }

  Future<void> fetchData() async {
    try {
      await Future.wait([fetchStockData(), fetchChartInfo()]);
    } catch (e) {
      setState(() => isLoading = false);
      print('Error: $e');
    }
  }

  Widget _buildChart() {
    return SfCartesianChart(
      primaryXAxis: CategoryAxis(
        title: AxisTitle(text: '日期'),
        labelRotation: -45,
        majorGridLines: MajorGridLines(width: 0),
      ),
      primaryYAxis: NumericAxis(
        title: AxisTitle(text: chartInfo!.title),
        majorGridLines: MajorGridLines(width: 1, color: Colors.grey[300]),
      ),
      plotAreaBorderWidth: 0,
      annotations: <CartesianChartAnnotation>[
        CartesianChartAnnotation(
          widget: Container(
            child: Text(
              chartInfo!.bullMarketLine,
              style: TextStyle(color: Colors.green, fontSize: 12),
            ),
          ),
          coordinateUnit: CoordinateUnit.point,
          x: '2023-01-01',
          y: 80,
        ),
        CartesianChartAnnotation(
          widget: Container(
            child: Text(
              chartInfo!.shockMarketLine,
              style: TextStyle(color: Colors.orange, fontSize: 12),
            ),
          ),
          coordinateUnit: CoordinateUnit.point,
          x: '2023-01-01',
          y: 60,
        ),
        CartesianChartAnnotation(
          widget: Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.blue[50],
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              chartInfo!.description,
              style: TextStyle(color: Colors.blue, fontSize: 12),
            ),
          ),
          coordinateUnit: CoordinateUnit.point,
          x: '2023-01-01',
          y: 130,
        ),
      ],
      series: [
        LineSeries<Map<String, dynamic>, String>(
          dataSource: stockData,
          xValueMapper: (data, _) => data['date'].toString(),
          yValueMapper: (data, _) => data['count'] as int,
          dataLabelSettings: DataLabelSettings(
            isVisible: true,
            labelPosition: ChartDataLabelPosition.outside, // 显示在数据点上方
            textStyle: TextStyle(
              color: Colors.black, // 字体颜色
              fontSize: 12, // 字体大小
              fontWeight: FontWeight.bold, // 字体粗细
            ),
            builder: (dynamic data, dynamic point, dynamic series,
                int pointIndex, int seriesIndex) {
              return Text(
                '${data['count']}', // 自定义标签内容
                style: TextStyle(color: Colors.red, fontSize: 12),
              );
            },
          ),
          color: Colors.blue,
          width: 2,
          markerSettings: MarkerSettings(
            isVisible: true,
            shape: DataMarkerType.circle,
            borderWidth: 2,
            borderColor: Colors.blue,
            color: Colors.white,
          ),
        ),
      ],
      tooltipBehavior: TooltipBehavior(
        enable: true,
        color: Colors.blue[800],
        borderColor: Colors.blue[900],
        textStyle: TextStyle(color: Colors.white, fontSize: 14),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (chartInfo == null) {
      return Center(child: Text('数据加载失败'));
    }
    return isLoading
        ? Center(child: CircularProgressIndicator())
        : stockData.isEmpty
            ? Center(child: Text('暂无数据'))
            : _buildChart();
  }
}

class ChartInfo {
  final String title;
  final String bullMarketLine;
  final String shockMarketLine;
  final String description;

  ChartInfo({
    required this.title,
    required this.bullMarketLine,
    required this.shockMarketLine,
    required this.description,
  });

  factory ChartInfo.fromJson(Map<String, dynamic> json) {
    return ChartInfo(
      title: json['title'],
      bullMarketLine: json['bullMarketLine'],
      shockMarketLine: json['shockMarketLine'],
      description: json['description'],
    );
  }
}
