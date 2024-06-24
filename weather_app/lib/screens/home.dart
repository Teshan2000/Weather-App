import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:weather_app/models/weatherModel.dart';
import 'package:weather_app/providers/weatherService.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final _WeatherService = WeatherService('c3281946b6139602ecabb86fd3e733c2');
  Weather? _weather;

  fetchWeather() async {
    String cityName = await _WeatherService.getCurrentCity();

    try {
      final weather = await _WeatherService.getWeather(cityName);
      setState(() {
        _weather = weather;
      });
    } catch (e) {
      print(e);
    }
  }

  String getWeatherAnimation(String? mainCondition) {
    if (mainCondition == null) return 'assets/sunny.json';

    switch (mainCondition.toLowerCase()) {
      case 'clouds':
      case 'mist':
      case 'smoke':
      case 'haze':
      case 'dust':
      case 'fog':
        return 'assets/cloudy.json';
      case 'rain':
      case 'drizzle':
        return 'assets/rainy.json';
      case 'shower rain':
        return 'assets/shower.json';
      case 'thunderstorm':
        return 'assets/thunder.json';
      case 'clear':
        return 'assets/sunny.json';
      default:
        return 'assets/sunny.json';
    }
  }

  @override
  void initState() {
    super.initState();
    fetchWeather();
  }

  @override
  Widget build(BuildContext context) {
    var now = DateTime.now();
    var formatterDate = DateFormat('EEE d MMM');
    var formatterTime = DateFormat('kk:mm');
    String actualDate = formatterDate.format(now);
    String actualTime = formatterTime.format(now);
    
    if (_weather == null) {
      return const Center(child: CircularProgressIndicator());
    }
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {}, icon: const Icon(Icons.more_vert_outlined)),
        title: Center(
            child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.location_on),
            const SizedBox(
              width: 7,
            ),
            Text(_weather?.cityName ?? "loading city..."),
          ],
        )),
        actions: [
          IconButton(
              onPressed: () {},
              icon: const Icon(Icons.add_location_alt_outlined))
        ],
      ),
      body: Stack(
        children: <Widget>[
          ConstrainedBox(
            constraints: const BoxConstraints.expand(),
            child: const FlutterLogo()
          ),
          Center(
            child: ClipRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                child: Container(
                  width: 2000.0,
                  height: 2000.0,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200.withOpacity(0.5)
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Center(
                          child: Text(
                            "$actualDate | $actualTime",
                            style: const TextStyle(fontSize: 20),
                          ),
                        ),
                        const SizedBox(
                          height: 17,
                        ),
                        Center(
                          child: Text(
                            "${_weather?.temperature.round()}°C",
                            style: const TextStyle(fontSize: 75, color: Colors.blue, fontWeight: FontWeight.bold),
                          ),
                        ),
                        Lottie.asset(getWeatherAnimation(_weather?.mainCondition)),
                        Center(
                          child: Text(
                            _weather?.mainCondition ?? "",
                            style: const TextStyle(fontSize: 25, color: Colors.blue, fontWeight: FontWeight.bold),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      )
    );
  }
}
