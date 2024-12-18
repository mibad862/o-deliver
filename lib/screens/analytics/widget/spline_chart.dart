import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class SplineChartWidget extends StatelessWidget {
  final List<ChartSampleData> data; // Data for the chart
  final double yAxisMin; // Minimum value for Y-axis
  final double yAxisMax; // Maximum value for Y-axis
  final String yAxisLabelFormat; // Format for Y-axis labels
  final bool showLegend; // Whether to show the legend or not

  const SplineChartWidget({
    Key? key,
    required this.data,
    this.yAxisMin = 0,
    this.yAxisMax = 100,
    this.yAxisLabelFormat = '{value}',
    this.showLegend = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 260,
      child: SfCartesianChart(
        plotAreaBorderWidth: 0,
        legend: Legend(isVisible: showLegend),
        primaryXAxis: const CategoryAxis(
          majorGridLines: MajorGridLines(width: 0),
        ),
        primaryYAxis: const NumericAxis(
          isVisible: false,
        ),
        series: _getSplineSeries(data),
        tooltipBehavior: TooltipBehavior(enable: true),
      ),
    );
  }

  /// Returns the list of spline series based on the provided data
  List<SplineSeries<ChartSampleData, String>> _getSplineSeries(
      List<ChartSampleData> data) {
    return <SplineSeries<ChartSampleData, String>>[
      SplineSeries<ChartSampleData, String>(
        dataSource: data,
        xValueMapper: (ChartSampleData sales, _) => sales.x as String,
        yValueMapper: (ChartSampleData sales, _) => sales.y,
        markerSettings: const MarkerSettings(isVisible: true),
      ),
    ];
  }
}

class ChartSampleData {
  ChartSampleData({required this.x, required this.y, this.secondSeriesYValue});
  final String x;
  final double y;
  final double? secondSeriesYValue;
}
