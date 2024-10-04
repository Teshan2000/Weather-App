import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weather_app/models/weatherModel.dart';
import 'package:weather_app/models/forecastModel.dart';
import 'package:weather_app/providers/weatherService.dart';
import 'package:weather_app/screens/forecasts.dart';
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
              Container(
                height: 810,
                width: double.infinity,
                decoration: ShapeDecoration(
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(20),
                        bottomRight: Radius.circular(20)),
                  ),
                  shadows: [
                    BoxShadow(
                      color: Colors.blue.withOpacity(0.5),
                      spreadRadius: 3,
                      blurRadius: 7,
                      offset: const Offset(0, 3),
                    ),
                  ],
                  color: Colors.white.withOpacity(0.50),
                ),
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
                        width: 220),
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
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Container(
                        width: 350,
                        height: 125,
                        decoration: ShapeDecoration(
                          color: Colors.transparent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Container(
                                width: 105,
                                height: 125,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 10),
                                decoration: ShapeDecoration(
                                  color: Colors.white.withOpacity(0.5),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15),
                                      side: const BorderSide(
                                          width: 2.5, color: Colors.white)),
                                ),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    const Text(
                                      "Humidity",
                                      style: TextStyle(fontSize: 15),
                                    ),
                                    Image.asset(
                                      'assets/water.png',
                                      fit: BoxFit.contain,
                                      width: 35,
                                    ),
                                    Text(
                                      "${_weather?.humidity}%",
                                      style: TextStyle(
                                          fontSize: 15,
                                          color: Colors.blue,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 5),
                              Container(
                                width: 105,
                                height: 125,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 10),
                                decoration: ShapeDecoration(
                                  color: Colors.white.withOpacity(0.5),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15),
                                      side: const BorderSide(
                                          width: 2.5, color: Colors.white)),
                                ),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    const Text(
                                      "Pressure",
                                      style: TextStyle(fontSize: 15),
                                    ),
                                    Image.asset(
                                      'assets/pressure.png',
                                      fit: BoxFit.contain,
                                      width: 35,
                                    ),
                                    Text(
                                      "${_weather?.pressure} bar",
                                      style: TextStyle(
                                          fontSize: 15,
                                          color: Colors.blue,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 5),
                              Container(
                                width: 105,
                                height: 125,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 10),
                                decoration: ShapeDecoration(
                                  color: Colors.white.withOpacity(0.5),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15),
                                      side: const BorderSide(
                                          width: 2.5, color: Colors.white)),
                                ),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    const Text(
                                      "Wind Speed",
                                      style: TextStyle(fontSize: 15),
                                    ),
                                    Image.asset(
                                      'assets/wind.png',
                                      fit: BoxFit.contain,
                                      width: 35,
                                    ),
                                    Text(
                                      "${_weather?.windSpeed} m/s",
                                      style: TextStyle(
                                          fontSize: 15,
                                          color: Colors.blue,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            const Text(
                              "5 Day Forecasts",
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const Forecasts(),
                                  ),
                                );
                              },
                              child: const Text(
                                "More Details",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.blue,
                                ),
                              ),
                            ),
                          ]),
                    ),
                    const SizedBox(height: 5),
                    _forecasts != null
                        ? Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 10),
                            height: 145,
                            width: double.infinity,
                            child: ListView(
                              scrollDirection: Axis.horizontal,
                              children: List.generate(5, (index) {
                                final forecast = _forecasts![index];
                                return Padding(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 5),
                                  child: Container(
                                    width: 77,
                                    height: 260,
                                    decoration: ShapeDecoration(
                                      color:
                                          Colors.white.withOpacity(0.5),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20),
                                        side: const BorderSide(
                                          width: 2.5, color: Colors.white)
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
                                              fontSize: 15, color: Colors.black),
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
                                              fontSize: 15, color: Colors.blue, fontWeight: FontWeight.bold),
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
              )
            ],
          ),
        ),
      ),
    );
  }
}
