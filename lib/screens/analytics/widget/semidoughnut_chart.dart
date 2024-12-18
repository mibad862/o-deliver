import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class SemiDoughnutChartWidget extends StatelessWidget {
  final List<ChartData> data;
  final int startAngle;
  final int endAngle;
  final String innerRadius;
  final bool showLegend;
  final double chartWidth;

  const SemiDoughnutChartWidget({
    Key? key,
    required this.data,
    this.startAngle = 270,
    this.endAngle = 90,
    this.innerRadius = '70%',
    this.showLegend = true,
    this.chartWidth = 200, // Default chart width
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double firstValue = data[0].value;

    return Center(
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          Container(
            height: 130,
            child: SfCircularChart(
              legend: Legend(isVisible: showLegend),
              centerY: "80%",
              series: <DoughnutSeries<ChartData, String>>[
                DoughnutSeries<ChartData, String>(
                  radius: "120%",
                  cornerStyle: CornerStyle.bothCurve,
                  pointColorMapper: (datum, index) => Colors.black,
                  dataSource: data,
                  innerRadius: innerRadius,
                  startAngle: startAngle,
                  endAngle: endAngle,
                  xValueMapper: (ChartData data, _) => data.category,
                  yValueMapper: (ChartData data, _) => data.value,
                  dataLabelSettings: const DataLabelSettings(isVisible: false),
                ),
              ],
            ),
          ),
          // Value in the middle
          Positioned(
            top: 80,
            child: Text(
              firstValue
                  .toStringAsFixed(1), // Show the actual value in the middle
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ChartData {
  ChartData(this.category, this.value);
  final String category;
  final double value;
}
