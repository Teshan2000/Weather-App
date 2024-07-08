import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:weather_app/models/weatherModel.dart';
import 'package:weather_app/models/forecastModel.dart';
import 'package:weather_app/providers/weatherService.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final _WeatherService = WeatherService('c3281946b6139602ecabb86fd3e733c2');
  Weather? _weather;
  List<Forecast>? _forecasts;

  fetchWeather() async {
    String cityName = await _WeatherService.getCurrentCity();
    try {
      final weather = await _WeatherService.getWeather(cityName);
      final forecasts = await _WeatherService.getFiveDayForecast(cityName);
      setState(() {
        _weather = weather;
        _forecasts = forecasts;
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

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {}, icon: const Icon(Icons.more_vert_outlined)),
        title: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.location_on),
              const SizedBox(width: 7),
              Text(_weather?.cityName ?? "loading city..."),
            ],
          ),
        ),
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
            child: const FlutterLogo(),
          ),
          Center(
            child: ClipRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                child: Container(
                  width: 2000.0,
                  height: 2000.0,
                  decoration: BoxDecoration(
                      color: Colors.grey.shade200.withOpacity(0.5)),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Center(
                          child: Text(
                            "$actualDate | $actualTime",
                            style: const TextStyle(fontSize: 20),
                          ),
                        ),
                        const SizedBox(height: 17),
                        Center(
                          child: Text(
                            "${_weather?.temperature.round()}°C",
                            style: const TextStyle(
                                fontSize: 75,
                                color: Colors.blue,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        Lottie.asset(
                            getWeatherAnimation(_weather?.mainCondition)),
                        Center(
                          child: Text(
                            _weather?.mainCondition ?? "",
                            style: const TextStyle(
                                fontSize: 25,
                                color: Colors.blue,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        const SizedBox(height: 30),
                        Container(
                          width: 300,
                          height: 160,
                          decoration: ShapeDecoration(
                            color: Colors.grey.shade200.withOpacity(0.5),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Humidity",
                                      style: const TextStyle(fontSize: 20),
                                    ),
                                    Text(
                                      "${_weather?.humidity}%",
                                      style: TextStyle(
                                        fontSize: 20,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 15),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Pressure",
                                      style: const TextStyle(fontSize: 20),
                                    ),
                                    Text(
                                      "${_weather?.pressure}%",
                                      style: TextStyle(
                                        fontSize: 20,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 15),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Wind Speed",
                                      style: const TextStyle(fontSize: 20),
                                    ),
                                    Text(
                                      "${_weather?.windSpeed} m/s",
                                      style: TextStyle(
                                        fontSize: 20,
                                      ),
                                    ),
                                  ],
                                ),
                                // Center(
                                //   child: Text(
                                //     "Humidity: ${_weather?.humidity}%",
                                //     style: const TextStyle(fontSize: 20),
                                //   ),
                                // ),
                                // Center(
                                //   child: Text(
                                //     "Pressure: ${_weather?.pressure}%",
                                //     style: const TextStyle(fontSize: 20),
                                //   ),
                                // ),
                                // Center(
                                //   child: Text(
                                //     "Wind Speed: ${_weather?.windSpeed} m/s",
                                //     style: const TextStyle(fontSize: 20),
                                //   ),
                                // ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        _forecasts != null
                            ? Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 10),
                                height: 170,
                                width: double.infinity,
                                child: ListView(
                                  scrollDirection: Axis.horizontal,
                                  children: List.generate(5, (index) {
                                    final forecast = _forecasts![index];
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 5),
                                      child: Container(
                                        width: 100,
                                        height: 260,
                                        decoration: ShapeDecoration(
                                          color: Colors.grey.shade200
                                              .withOpacity(0.5),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(15),
                                          ),
                                        ),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: <Widget>[
                                            Text(
                                              DateFormat('EEE')
                                                  .format(forecast.dateTime),
                                              style: const TextStyle(
                                                  fontSize: 18,
                                                  color: Colors.blue),
                                            ),
                                            const SizedBox(height: 5),
                                            Lottie.asset(
                                                getWeatherAnimation(
                                                    forecast.mainCondition),
                                                width: 45),
                                            const SizedBox(height: 5),
                                            Text(
                                              "${forecast.temperature.round()}°C",
                                              style: const TextStyle(
                                                  fontSize: 26,
                                                  color: Colors.blue),
                                            ),
                                            const SizedBox(height: 5),
                                            Text(
                                              forecast.mainCondition,
                                              style: const TextStyle(
                                                  fontSize: 16,
                                                  color: Colors.blue),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  }),
                                ),
                              )
                            : Center(child: CircularProgressIndicator()),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
