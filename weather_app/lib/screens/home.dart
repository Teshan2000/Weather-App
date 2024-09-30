import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:weather_app/models/weatherModel.dart';
import 'package:weather_app/models/forecastModel.dart';
import 'package:weather_app/providers/weatherService.dart';
import 'package:weather_app/screens/locations.dart';

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
    if (mainCondition == null) return 'assets/clear.png';

    switch (mainCondition.toLowerCase()) {
      case 'clouds':
      case 'mist':
      case 'smoke':
      case 'haze':
      case 'dust':
      case 'fog':
        return 'assets/clear.png';
      case 'rain':
        return 'assets/rain.png';
      case 'drizzle':
        return 'assets/drizzle.png';
      case 'shower rain':
        return 'assets/shower.png';
      case 'thunderstorm':
        return 'assets/thunder run.png';
      case 'clear':
        return 'assets/clear.png';
      default:
        return 'assets/clear.png';
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
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
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
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => Locations()));
              },
              icon: const Icon(Icons.add_location_alt_outlined))
        ],
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
            image: DecorationImage(
          image: AssetImage('assets/background.png'),
          fit: BoxFit.cover,
        )),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 87),
              Center(
                child: Text(
                  "   $actualDate | $actualTime",
                  style: const TextStyle(fontSize: 18),
                ),
              ),
              const SizedBox(height: 17),
              Center(
                child: Text(
                  "${_weather?.temperature.round()}°C",
                  style: const TextStyle(
                      fontSize: 55,
                      color: Colors.blue,
                      fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 5),
              Image.asset(
                  getWeatherAnimation(
                    _weather?.mainCondition,
                  ),
                  width: 190),
              Center(
                child: Text(
                  _weather?.mainCondition ?? "",
                  style: const TextStyle(
                      fontSize: 20,
                      color: Colors.blue,
                      fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 20),
              Container(
                width: 280,
                height: 125,
                decoration: ShapeDecoration(
                  color: Colors.grey.shade200.withOpacity(0.5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Humidity",
                              style: const TextStyle(fontSize: 15),
                            ),
                            const SizedBox(width: 0),
                            Image.asset(
                              'assets/water.png',
                              fit: BoxFit.contain,
                              width: 30,
                            ),
                            const SizedBox(width: 18),
                            Text(
                              "${_weather?.humidity}%",
                              style: TextStyle(
                                fontSize: 15,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 5),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Pressure",
                              style: const TextStyle(fontSize: 15),
                            ),
                            Image.asset(
                              'assets/pressure.png',
                              fit: BoxFit.contain,
                              width: 30,
                            ),
                            Text(
                              "${_weather?.pressure} bar",
                              style: TextStyle(
                                fontSize: 15,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 5),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Wind Speed",
                              style: const TextStyle(fontSize: 15),
                            ),
                            Image.asset(
                              'assets/wind.png',
                              fit: BoxFit.contain,
                              width: 30,
                            ),
                            Text(
                              "${_weather?.windSpeed} m/s",
                              style: TextStyle(
                                fontSize: 15,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SizedBox(width: 20),
                  Text(
                    "5 Day Forecasts",
                    textAlign: TextAlign.start,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: 5),
              _forecasts != null
                  ? Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 10),
                      height: 150,
                      width: double.infinity,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: List.generate(5, (index) {
                          final forecast = _forecasts![index];
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 5),
                            child: Container(
                              width: 77,
                              height: 260,
                              decoration: ShapeDecoration(
                                color: Colors.grey.shade200.withOpacity(0.5),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(25),
                                ),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Text(
                                    DateFormat('EEE').format(forecast.dateTime),
                                    style: const TextStyle(
                                        fontSize: 15, color: Colors.blue),
                                  ),
                                  const SizedBox(height: 5),
                                  Image.asset(
                                      getWeatherAnimation(
                                          forecast.mainCondition),
                                      width: 30),
                                  const SizedBox(height: 5),
                                  Text(
                                    "${forecast.temperature.round()}°C",
                                    style: const TextStyle(
                                        fontSize: 15, color: Colors.blue),
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    forecast.mainCondition,
                                    style: const TextStyle(
                                        fontSize: 15, color: Colors.blue),
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
    );
  }
}
