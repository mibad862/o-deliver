import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'spline_chart.dart';

class PieChartWidget extends StatefulWidget {
  final List<ChartSampleData> data;
  final String initialPosition;
  final String initialMode;
  final bool showScrollbar;

  const PieChartWidget({
    Key? key,
    required this.data,
    this.initialPosition = 'auto',
    this.initialMode = 'wrap',
    this.showScrollbar = false,
  }) : super(key: key);

  @override
  _PieChartWidgetState createState() => _PieChartWidgetState();
}

class _PieChartWidgetState extends State<PieChartWidget> {
  late String _selectedMode;
  List<String>? _modeList;
  late LegendItemOverflowMode _overflowMode;
  late String _selectedPosition;
  List<String>? _positionList;
  late LegendPosition _position;
  late bool _shouldAlwaysShowScrollbar;

  @override
  void initState() {
    super.initState();
    _selectedMode = widget.initialMode;
    _modeList = <String>['wrap', 'none', 'scroll'];
    _position = _getLegendPosition(widget.initialPosition);
    _selectedPosition = widget.initialPosition;
    _positionList = <String>['auto', 'bottom', 'left', 'right', 'top'];
    _overflowMode = _getLegendMode(widget.initialMode);
    _shouldAlwaysShowScrollbar = widget.showScrollbar;
  }

  @override
  Widget build(BuildContext context) {
    return SfCircularChart(
      legend: Legend(
        position: _position,
        isVisible: true,
        overflowMode: _overflowMode,
        shouldAlwaysShowScrollbar: _shouldAlwaysShowScrollbar,
      ),
      series: _getDoughnutSeries(),
      tooltipBehavior: TooltipBehavior(enable: true),
    );
  }

  List<DoughnutSeries<ChartSampleData, String>> _getDoughnutSeries() {
    return <DoughnutSeries<ChartSampleData, String>>[
      DoughnutSeries<ChartSampleData, String>(
        dataSource: widget.data,
        xValueMapper: (ChartSampleData data, _) => data.x,
        yValueMapper: (ChartSampleData data, _) => data.y,
        startAngle: 90,
        endAngle: 90,
        radius: "40%",
        innerRadius: "60%",
        dataLabelSettings: const DataLabelSettings(
          isVisible: true,
          labelPosition: ChartDataLabelPosition.outside,
          
        ),
      ),
    ];
  }

  LegendPosition _getLegendPosition(String position) {
    switch (position) {
      case 'bottom':
        return LegendPosition.bottom;
      case 'left':
        return LegendPosition.left;
      case 'right':
        return LegendPosition.right;
      case 'top':
        return LegendPosition.top;
      default:
        return LegendPosition.auto;
    }
  }

  LegendItemOverflowMode _getLegendMode(String mode) {
    switch (mode) {
      case 'scroll':
        return LegendItemOverflowMode.scroll;
      case 'none':
        return LegendItemOverflowMode.none;
      default:
        return LegendItemOverflowMode.wrap;
    }
  }
}





