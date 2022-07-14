import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:weather/tool/helper.dart';

import '../model/current_weather.dart';
import '../repository/weatherRepository.dart';
import '../tool/images.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  static const String _url = 'https://github.com/a1573595';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Weather'),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.info_outline,
            ),
            onPressed: _launchURL,
          )
        ],
      ),
      body: const SafeArea(
        child: _Body(),
      ),
    );
  }

  _launchURL() {
    launchUrl(_url);
  }
}

class _Body extends ConsumerWidget {
  const _Body({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FutureBuilder<CurrentWeather>(
        future: ref.read(weatherRepository).currentWeather(),
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

  CurrentWeather data;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(vertical: 16),
      physics: const BouncingScrollPhysics(),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text(
                DateFormat("EEEE, d MMMM").format(DateTime.now()),
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 20.0,
                  fontWeight: FontWeight.w600,
                ),
              ),
              ElevatedButton(
                onPressed: null,
                style: ButtonStyle(
                    shape: MaterialStateProperty.all(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16))),
                    backgroundColor: MaterialStateProperty.all(Colors.orange)),
                child: Container(
                  alignment: Alignment.center,
                  width: 80.0,
                  child: const Text(
                    "Today",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 16.0,
                    ),
                  ),
                ),
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage(Images.header), fit: BoxFit.cover),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data.name,
                  style: const TextStyle(
                    fontSize: 42,
                    fontWeight: FontWeight.w700,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Text(
                  'Day ${(data.main.tempMax).toInt()}° ↑ • Night ${(data.main.tempMin).toInt()}° ↓',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    Text(
                      '${(data.main.temp).toInt()}°',
                      style: const TextStyle(
                        fontSize: 100,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      'Feels like ${(data.main.feelsLike).toInt()}°',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    getWeatherIcon(data.weathers[0].main),
                    const SizedBox(
                      width: 8,
                    ),
                    data.weathers[0].description.contains(' ')
                        ? Text(
                            '${data.weathers[0].description.split(' ')[0][0].toUpperCase()}${data.weathers[0].description.split(' ')[0].substring(1)} ${data.weathers[0].description.split(' ')[1][0].toUpperCase()}${data.weathers[0].description.split(' ')[1].substring(1)}',
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w500),
                            textAlign: TextAlign.center,
                          )
                        : Text(
                            data.weathers[0].description[0].toUpperCase() +
                                data.weathers[0].description.substring(1),
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w500),
                            textAlign: TextAlign.center,
                          ),
                    const SizedBox(height: 8)
                  ],
                )
              ],
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            alignment: Alignment.centerLeft,
            child: const Text(
              'Details',
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.w700),
            ),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Expanded(
                      child: Card(
                        elevation: 4,
                        child: Container(
                          alignment: Alignment.center,
                          width: 140.0,
                          height: 120.0,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8.0),
                                child: Container(
                                  height: 5.0,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5.0),
                                      color: Colors.lightBlueAccent),
                                ),
                              ),
                              const SizedBox(height: 16),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const <Widget>[
                                  FaIcon(FontAwesomeIcons.droplet,
                                      color: Colors.lightBlueAccent),
                                  Text(
                                    "  Humidity",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 16),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Text(
                                "${data.main.humidity}%",
                                style: const TextStyle(
                                    fontWeight: FontWeight.w700, fontSize: 24),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Card(
                        elevation: 4,
                        child: Container(
                          alignment: Alignment.center,
                          width: 140.0,
                          height: 120.0,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8.0),
                                child: Container(
                                  height: 5.0,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5.0),
                                      color: Colors.orangeAccent),
                                ),
                              ),
                              const SizedBox(height: 16),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const <Widget>[
                                  FaIcon(FontAwesomeIcons.solidSun,
                                      color: Colors.orangeAccent),
                                  Text(
                                    "  Visibility",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 16),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Text(
                                data.visibility.toString() == 'null'
                                    ? 'N/A'
                                    : '${data.visibility} m',
                                style: const TextStyle(
                                    fontWeight: FontWeight.w700, fontSize: 24),
                              )
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Expanded(
                      child: Card(
                        elevation: 4,
                        child: Container(
                          alignment: Alignment.center,
                          width: 140.0,
                          height: 120.0,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8.0),
                                child: Container(
                                  height: 5.0,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5.0),
                                      color: Colors.greenAccent),
                                ),
                              ),
                              const SizedBox(height: 16),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const <Widget>[
                                  FaIcon(FontAwesomeIcons.wind,
                                      color: Colors.greenAccent),
                                  Text(
                                    "  Wind",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 16),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Text(
                                "${data.wind.speed.toStringAsFixed(1)} km/h",
                                style: const TextStyle(
                                    fontWeight: FontWeight.w700, fontSize: 24),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Card(
                        elevation: 4,
                        child: Container(
                          alignment: Alignment.center,
                          width: 140.0,
                          height: 120.0,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8.0),
                                child: Container(
                                  height: 5.0,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5.0),
                                      color: Colors.purpleAccent),
                                ),
                              ),
                              const SizedBox(height: 16),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const <Widget>[
                                  FaIcon(FontAwesomeIcons.weightScale,
                                      color: Colors.purpleAccent),
                                  Text(
                                    "  Pressure",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 16),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Text(
                                "${data.main.pressure} hPa",
                                style: const TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 24.0),
                              )
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
          const SizedBox(height: 16),
          Center(
            child: ElevatedButton(
              onPressed: () => context.go('/home/detail'),
              style: ButtonStyle(
                  elevation: MaterialStateProperty.all(4),
                  backgroundColor: MaterialStateProperty.all(Colors.orange)),
              child: const Text(
                "More Detail",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 16.0,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

FaIcon getWeatherIcon(String main) {
  switch (main) {
    case 'Clouds':
      return const FaIcon(FontAwesomeIcons.cloud, color: Colors.grey);
    case 'Clear':
      return const FaIcon(FontAwesomeIcons.solidSun,
          color: Colors.orangeAccent);
    case 'Atmosphere':
      return const FaIcon(FontAwesomeIcons.smog, color: Colors.black);
    case 'Snow':
      return const FaIcon(FontAwesomeIcons.snowflake, color: Colors.cyanAccent);
    case 'Rain':
      return const FaIcon(FontAwesomeIcons.cloudRain, color: Colors.blue);
    case 'Drizzle':
      return const FaIcon(FontAwesomeIcons.droplet, color: Colors.blue);
    case 'Thunderstorm':
      return const FaIcon(FontAwesomeIcons.cloudBolt, color: Colors.blue);
    default:
      return const FaIcon(FontAwesomeIcons.sun, color: Colors.orangeAccent);
  }
}
