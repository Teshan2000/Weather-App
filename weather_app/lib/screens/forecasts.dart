import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:weather_app/models/forecastModel.dart';
import 'package:weather_app/providers/weatherService.dart';

class NewWeather extends StatefulWidget {
  const NewWeather({super.key});

  @override
  State<NewWeather> createState() => _NewWeatherState();
}

class _NewWeatherState extends State<NewWeather> {
  final WeatherService _weatherService = WeatherService('c3281946b6139602ecabb86fd3e733c2');
  List<Forecast>? _forecasts;
  
  fetchWeather() async {
    String cityName = await _weatherService.getCurrentCity();
    try {
      final forecasts = await _weatherService.getFiveDayForecast(cityName);
      setState(() {
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
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white.withOpacity(0.50),
        title: const Center(
          child: Text("5 Day Forecasts"),
        ),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const NewWeather()));
              },
              icon: const Icon(Icons.add_location_alt_outlined))
        ],
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(
            image: DecorationImage(
          image: AssetImage('assets/Group 1.png'),
          fit: BoxFit.cover,
        )),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(0),
            child: SafeArea(
              child: Column(
                children: [
                  _forecasts != null ?
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: 1,
                    itemBuilder: (context, index) {
                      final forecast = _forecasts![index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 0, vertical: 0),
                        child: Container(
                          height: 260,
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
                                offset:
                                    Offset(0, 3), // changes position of shadow
                              ),
                            ],
                            color: Colors.white.withOpacity(0.50),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 20),
                            child: Column(
                              children: [
                                Expanded(
                                  child: Row(
                                    children: [
                                      const Spacer(),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const Spacer(),
                                          const Spacer(),
                                          const Text(
                                            "Today",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                fontSize: 16,
                                                color: Colors.black),
                                          ),
                                          const Spacer(),
                                          Text(
                                            "${forecast.temperature.round()}°C",
                                            textAlign: TextAlign.center,
                                            style: const TextStyle(
                                              fontSize: 30,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.blue,
                                            ),
                                          ),
                                          const Spacer(),
                                          Text(
                                            "${forecast.mainCondition} Day",
                                            textAlign: TextAlign.center,
                                            style: const TextStyle(
                                                fontSize: 16,
                                                color: Colors.blue),
                                          ),
                                          const Spacer(),
                                          const Spacer(),
                                        ],
                                      ),
                                      const Spacer(),
                                      Column(
                                        children: [
                                          const Spacer(),
                                          Lottie.asset(
                                      getWeatherAnimation(
                                          forecast.mainCondition),
                                      width: 170),
                                          const Spacer(),
                                        ],
                                      ),
                                      const Spacer(),
                                    ],
                                  ),
                                ),
                                Container(
                                  width: 290,
                                  decoration: ShapeDecoration(
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(15),
                                        side: const BorderSide(
                                            width: 2.5, color: Colors.white)),
                                    color: Colors.white.withOpacity(0.50),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 30, vertical: 12),
                                    child: Center(
                                      child: Row(
                                        children: [
                                          const Spacer(),
                                          Image.asset(
                                            'assets/water.png',
                                            fit: BoxFit.cover,
                                            width: 30,
                                          ),
                                          const Spacer(),
                                          const Text(
                                            "30% chance of rain today",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                fontSize: 16,
                                                color: Colors.black),
                                          ),
                                          const Spacer(),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ) : Center(child: CircularProgressIndicator()),                  
                  const SizedBox(height: 20),
                  _forecasts != null ?
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: 5,
                    itemBuilder: (context, index) {
                      final forecast = _forecasts![index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 5),
                        child: Container(
                          decoration: ShapeDecoration(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                                side: const BorderSide(
                                    width: 2.5, color: Colors.white)),
                            color: Colors.white.withOpacity(0.50),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 20),
                            child: Center(
                              child: Row(
                                children: [
                                  Text(
                                    DateFormat('EEE').format(forecast.dateTime),
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                        fontSize: 16, color: Colors.black),
                                  ),
                                  const Spacer(),
                                  Lottie.asset(
                                      getWeatherAnimation(
                                          forecast.mainCondition),
                                      width: 30),
                                  const Spacer(),
                                  Text(
                                    "${forecast.temperature.round()}°C",
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.blue,
                                    ),
                                  ),
                                  const Spacer(),
                                  Text(
                                    forecast.mainCondition,
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                        fontSize: 16, color: Colors.blue),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ) : Center(child: CircularProgressIndicator()),             
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
