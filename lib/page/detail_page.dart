import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:sprintf/sprintf.dart';
import 'package:weather/tool/helper.dart';

import '../model/daily.dart';
import '../model/hourly.dart';
import '../model/one_call.dart';
import '../repository/weatherRepository.dart';
import 'home_page.dart';

class DetailPage extends StatelessWidget {
  const DetailPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: const _Body(),
    );
  }
}

class _Body extends ConsumerWidget {
  const _Body({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FutureBuilder<OneCall>(
        future: ref.read(weatherRepository).oneCall(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text(snapshot.error.toString());
          } else if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          } else {
            return _InfoBody(snapshot.data!);
          }
        });
  }
}

class _InfoBody extends StatelessWidget {
  _InfoBody(this.data, {Key? key}) : super(key: key);

  OneCall data;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      // padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
      padding: const EdgeInsets.symmetric(vertical: 16),
      clipBehavior: Clip.antiAlias,
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text('Next 24 Hours',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 16.0,
                )),
          ),
          // _LineChart(data.hourly.take(24).toList()),
          _ScrollAbleLineChart(data.hourly.take(24).toList()),
          const SizedBox(height: 40),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text('Next 7 Days',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 16.0,
                )),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: _WeeksWeather(data.daily.take(7).toList()),
          ),
        ],
      ),
    );
  }
}

class _LineChart extends StatelessWidget {
  _LineChart(this.hourly, {Key? key}) : super(key: key);

  List<Hourly> hourly;

  final List<int> showIndexes = const [0, 4, 8, 12, 16, 20, 23];

  LineChartData get chartData => LineChartData(
        showingTooltipIndicators: showIndexes.mapIndexed((index, value) {
          return ShowingTooltipIndicators([
            LineBarSpot(lineChartBarData, value, lineChartBarData.spots[value]),
          ]);
        }).toList(),
        lineTouchData: lineTouchData,
        gridData: FlGridData(show: false),
        titlesData: titlesData,
        borderData: borderData,
        lineBarsData: [lineChartBarData],
        minX: 0,
        maxX: 23,
        maxY: hourly.map((e) => e.temp).reduce(max).toInt() + 5,
        minY: hourly.map((e) => e.temp).reduce(min).toInt() - 10,
      );

  FlTitlesData get titlesData => FlTitlesData(
        leftTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        rightTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 32,
            interval: 1,
            getTitlesWidget: bottomTitleWidgets,
          ),
        ),
      );

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    Widget text;
    if (value % 4 == 0 || value == 23) {
      var date =
          DateTime.fromMillisecondsSinceEpoch(hourly[value.toInt()].dt * 1000);

      text = Text(sprintf("%02d:00", [date.hour]));
    } else {
      text = const Text('');
    }

    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 10,
      child: text,
    );
  }

  FlBorderData get borderData => FlBorderData(
        show: true,
        border: const Border(
            // bottom: BorderSide(width: 2),
            ),
      );

  LineChartBarData get lineChartBarData => LineChartBarData(
      showingIndicators: showIndexes,
      isCurved: true,
      color: Colors.pinkAccent.shade100,
      barWidth: 4,
      isStrokeCapRound: true,
      dotData: FlDotData(show: false),
      belowBarData: BarAreaData(
        show: true,
        gradient: LinearGradient(
          colors: [
            Colors.pinkAccent.shade200,
            Colors.pinkAccent.shade100,
            Colors.white
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      // gradient: const LinearGradient(
      //   colors: [
      //     Color(0xff12c2e9),
      //     Color(0xffc471ed),
      //     Color(0xfff64f59),
      //   ],
      //   stops: [0.1, 0.4, 0.9],
      //   begin: Alignment.centerLeft,
      //   end: Alignment.centerRight,
      // ),
      spots: hourly
          .mapIndexed((index, value) =>
              FlSpot(index.toDouble(), value.temp.toInt().toDouble()))
          .toList());

  LineTouchData get lineTouchData => LineTouchData(
        enabled: false,
        getTouchedSpotIndicator:
            (LineChartBarData barData, List<int> spotIndexes) {
          return spotIndexes.map((index) {
            return TouchedSpotIndicatorData(
              FlLine(color: Colors.white, dashArray: [3, 5]),
              FlDotData(
                getDotPainter: (spot, percent, barData, index) =>
                    FlDotCirclePainter(
                  radius: 4,
                  color: Colors.white,
                  strokeWidth: 4,
                  strokeColor: Colors.pinkAccent.shade200,
                ),
              ),
            );
          }).toList();
        },
        touchTooltipData: LineTouchTooltipData(
          tooltipBgColor: Colors.transparent,
          getTooltipItems: (List<LineBarSpot> lineBarsSpot) {
            return lineBarsSpot.map((lineBarSpot) {
              return LineTooltipItem(
                "${lineBarSpot.y}°",
                const TextStyle(
                    color: Colors.black, fontWeight: FontWeight.bold),
              );
            }).toList();
          },
        ),
      );

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.23,
      child: LineChart(
        chartData,
        swapAnimationDuration: const Duration(milliseconds: 500),
      ),
    );
  }
}

class _ScrollAbleLineChart extends StatelessWidget {
  _ScrollAbleLineChart(this.hourly, {Key? key}) : super(key: key);

  List<Hourly> hourly;

  LineChartData get chartData => LineChartData(
        showingTooltipIndicators: hourly.mapIndexed((index, value) {
          return ShowingTooltipIndicators([
            LineBarSpot(lineChartBarData, index, lineChartBarData.spots[index]),
          ]);
        }).toList(),
        lineTouchData: lineTouchData,
        gridData: FlGridData(show: false),
        titlesData: titlesData,
        borderData: borderData,
        lineBarsData: [lineChartBarData],
        minX: 0,
        maxX: 23,
        maxY: hourly.map((e) => e.temp).reduce(max).toInt() + 5,
        minY: hourly.map((e) => e.temp).reduce(min).toInt() - 10,
      );

  FlTitlesData get titlesData => FlTitlesData(
        leftTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        rightTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 32,
            interval: 1,
            getTitlesWidget: bottomTitleWidgets,
          ),
        ),
      );

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    Widget text;

    var date =
        DateTime.fromMillisecondsSinceEpoch(hourly[value.toInt()].dt * 1000);
    text = Text(sprintf("%02d:00", [date.hour]));

    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 10,
      child: text,
    );
  }

  FlBorderData get borderData => FlBorderData(
        show: true,
        border: const Border(
            // bottom: BorderSide(width: 2),
            ),
      );

  LineChartBarData get lineChartBarData => LineChartBarData(
      showingIndicators: hourly.mapIndexed((i, e) => i).toList(),
      isCurved: true,
      color: Colors.pinkAccent.shade100,
      barWidth: 4,
      isStrokeCapRound: true,
      dotData: FlDotData(show: false),
      belowBarData: BarAreaData(
        show: true,
        gradient: LinearGradient(
          colors: [
            Colors.pinkAccent.shade200,
            Colors.pinkAccent.shade100,
            Colors.white
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      // gradient: const LinearGradient(
      //   colors: [
      //     Color(0xff12c2e9),
      //     Color(0xffc471ed),
      //     Color(0xfff64f59),
      //   ],
      //   stops: [0.1, 0.4, 0.9],
      //   begin: Alignment.centerLeft,
      //   end: Alignment.centerRight,
      // ),
      spots: hourly
          .mapIndexed((index, value) =>
              FlSpot(index.toDouble(), value.temp.toInt().toDouble()))
          .toList());

  LineTouchData get lineTouchData => LineTouchData(
        enabled: false,
        getTouchedSpotIndicator:
            (LineChartBarData barData, List<int> spotIndexes) {
          return spotIndexes.map((index) {
            return TouchedSpotIndicatorData(
              FlLine(color: Colors.white, dashArray: [3, 5]),
              FlDotData(
                getDotPainter: (spot, percent, barData, index) =>
                    FlDotCirclePainter(
                  radius: 4,
                  color: Colors.white,
                  strokeWidth: 4,
                  strokeColor: Colors.pinkAccent.shade200,
                ),
              ),
            );
          }).toList();
        },
        touchTooltipData: LineTouchTooltipData(
          tooltipBgColor: Colors.transparent,
          getTooltipItems: (List<LineBarSpot> lineBarsSpot) {
            return lineBarsSpot.map((lineBarSpot) {
              return LineTooltipItem(
                "${lineBarSpot.y.toStringAsFixed(0)}°",
                const TextStyle(
                    color: Colors.black, fontWeight: FontWeight.bold),
              );
            }).toList();
          },
        ),
      );

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: Row(
        children: [
          const SizedBox(
            width: 24,
          ),
          SizedBox(
            width: 1200,
            height: 300,
            child: LineChart(
              chartData,
              swapAnimationDuration: const Duration(milliseconds: 500),
            ),
          ),
          const SizedBox(
            width: 24,
          ),
        ],
      ),
    );
  }
}

class _WeeksWeather extends StatelessWidget {
  _WeeksWeather(this.daily, {Key? key}) : super(key: key);

  List<Daily> daily;
  late int len;
  late int minValue;

  @override
  Widget build(BuildContext context) {
    var maxValue = daily.map((e) => e.temp.day).reduce(max).toInt();
    minValue = daily.map((e) => e.temp.day).reduce(min).toInt();
    len = maxValue - minValue;

    return Column(
      children: daily
          .map((value) => _buildWeather(
              DateTime.fromMillisecondsSinceEpoch(value.dt * 1000),
              value.weathers[0].main,
              value.weathers[0].icon,
              value.temp.day.toInt()))
          .toList(),
    );
  }

  Widget _buildWeather(DateTime date, String main, String icon, int temp) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          SizedBox(width: 40, child: Text(DateFormat('EEE').format(date))),
          SizedBox(width: 30, child: getWeatherIcon(main)),
          const SizedBox(width: 16),
          Container(
            height: 4,
            width: 100 + 120 * (temp - minValue) / len,
            decoration: const BoxDecoration(
                gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.orange,
                Colors.white,
              ],
            )),
          ),
          const SizedBox(width: 16),
          Text('${temp.toStringAsFixed(0)}°'),
        ],
      ),
    );
  }
}
