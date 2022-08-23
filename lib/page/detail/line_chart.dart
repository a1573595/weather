part of 'detail_page.dart';

class _LineChart extends StatelessWidget {
  const _LineChart(this.hourly, {Key? key}) : super(key: key);

  final List<Hourly> hourly;

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
      text = Text(DateFormat("HH:00").format(date));
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
