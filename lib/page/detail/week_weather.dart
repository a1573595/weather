part of 'detail_page.dart';

class _WeekWeather extends StatelessWidget {
  const _WeekWeather(this.daily, {Key? key}) : super(key: key);

  final List<Daily> daily;

  @override
  Widget build(BuildContext context) {
    /// 計算氣溫最大與最小值
    /// 用於計算氣溫條比例
    var maxValue = daily.map((e) => e.temp.day).reduce(max).toInt();
    var minValue = daily.map((e) => e.temp.day).reduce(min).toInt();
    var len = maxValue - minValue;

    return Column(
      children: daily
          .map((value) => _buildWeather(
          minValue,
          len,
          DateTime.fromMillisecondsSinceEpoch(value.dt * 1000),
          value.weathers[0].main,
          value.weathers[0].icon,
          value.temp.day.toInt()))
          .toList(),
    );
  }

  Widget _buildWeather(int minValue, int len, DateTime date, String main,
      String icon, int temp) {
    var width = ScreenUtil().screenWidth / 4;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          SizedBox(width: 40, child: Text(DateFormat('EEE').format(date))),
          CachedNetworkImage(
            height: 40,
            width: 40,
            imageUrl: '${ImageUtil.openWeatherImageUrlPrefix}$icon.png',
            placeholder: (context, url) => const SizedBox(),
            errorWidget: (context, url, error) =>
            const Icon(Icons.error_outline),
          ),
          const SizedBox(width: 16),
          Container(
            height: 4,
            width: width + width * (temp - minValue) / len,
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
