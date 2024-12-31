import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:o_deliver/screens/analytics/widget/pie_chart.dart';
import 'package:o_deliver/screens/analytics/widget/spline_chart.dart'
    as spchart;
import 'widget/semidoughnut_chart.dart';
import 'widget/spline_chart.dart';

class AnalyticsScreen extends StatefulWidget {
  const AnalyticsScreen({super.key});

  @override
  State<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen> {
  List<String> timeOptions = ["Past Week", "Past Month", "Past Year"];
  String selectedOption = "Past Week";

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                color: Colors.grey.shade200,
                height: 300,
                child: Column(
                  children: [
                    SemiDoughnutChartWidget(
                      data: <ChartData>[
                        ChartData('David', 45),
                      ],
                      startAngle: 260,
                      endAngle: 100,
                      innerRadius: '94%',
                      showLegend: false,
                    ),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Hours On Duty",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(width: 20),
                        DropdownButton2<String>(
                          value: selectedOption,
                          
                          onChanged: (String? newValue) {
                            if (newValue != null) {
                              setState(() {
                                selectedOption = newValue;
                              });
                            }
                          },
                          items: timeOptions.map((String option) {
                            return DropdownMenuItem<String>(
                              value: option,
                              child: Text(
                                option,
                                style: TextStyle(
                                  fontSize: 16,
                                  color: option == selectedOption
                                      ? Colors.white
                                      : Colors.black,
                                ),
                              ),
                            );
                          }).toList(),
                          buttonStyleData: ButtonStyleData(
                            height: 40,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.black),
                          ),
                          iconStyleData: const IconStyleData(
                            icon: Icon(
                              Icons.keyboard_arrow_down_rounded,
                              color: Colors.white,
                            ),
                          ),
                          dropdownStyleData: DropdownStyleData(
                            maxHeight: 300,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: Colors.white,
                            ),
                            scrollbarTheme: ScrollbarThemeData(
                              thickness: MaterialStateProperty.all(6),
                              thumbColor:
                                  MaterialStateProperty.all(Colors.grey),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    const Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 20,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextWidget(
                            text: "0.1 mi",
                            dec: "Time",
                            dec1: "per Task",
                          ),
                          TextWidget(
                            text: "0.4 min",
                            dec: "Distance",
                            dec1: "per Task",
                          ),
                          TextWidget(
                            text: "0.0 min",
                            dec: "Service",
                            dec1: "per Task",
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(height: 20),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  "Tasks Completed",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  "Past Week",
                  style: TextStyle(
                    fontSize: 12,
                  ),
                ),
              ),
              spchart.SplineChartWidget(
                data: [
                  spchart.ChartSampleData(x: 'Mon', y: 30),
                  spchart.ChartSampleData(x: 'Tue', y: 50),
                  spchart.ChartSampleData(x: 'Wed', y: 20),
                  spchart.ChartSampleData(x: 'Thu', y: 15),
                  spchart.ChartSampleData(x: 'Fri', y: 65),
                  spchart.ChartSampleData(x: 'Sat', y: 70),
                  spchart.ChartSampleData(x: 'Sun', y: 90),
                ],
                showLegend: false,
              ),
              PieChartWidget(
                data: [
                  ChartSampleData(x: 'On Time', y: 56.2),
                  ChartSampleData(x: 'Late', y: 12.7),
                  ChartSampleData(x: 'Off', y: 1.3),
                ],
                initialPosition: 'right',
                initialMode: 'scroll',
                showScrollbar: true,
              )
            ],
          ),
        ),
      ),
    );
  }
}

class TextWidget extends StatelessWidget {
  final String text;
  final String dec;
  final String dec1;

  const TextWidget({
    Key? key,
    required this.text,
    required this.dec,
    required this.dec1,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          text,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        Text(
          dec,
          style: const TextStyle(color: Colors.grey),
        ),
        Text(
          dec1,
          style: const TextStyle(color: Colors.grey),
        ),
      ],
    );
  }
}
