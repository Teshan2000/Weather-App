import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:intl/intl.dart';
import 'package:weather_app/models/airQualityModel.dart';
import 'package:weather_app/models/weatherModel.dart';
import 'package:weather_app/models/forecastModel.dart';
import 'package:weather_app/providers/weatherService.dart';
import 'package:weather_app/screens/airQualityIndex.dart';
import 'package:weather_app/screens/forecasts.dart';
import 'package:weather_app/screens/splash.dart';
import 'package:weather_app/screens/weatherMap.dart';

class CityWeather extends StatefulWidget {
  final String cityName;
  const CityWeather({super.key, required this.cityName});

  @override
  State<CityWeather> createState() => _CityWeatherState();
}

class _CityWeatherState extends State<CityWeather> {
  final _WeatherService = WeatherService('c3281946b6139602ecabb86fd3e733c2');
  Weather? _weather;
  List<Forecast>? _forecasts;
  AirQuality? aqiData;

  fetchWeather() async {
    String cityName = await _WeatherService.getCurrentCity();
    try {
      final weather = await _WeatherService.getWeather(cityName);
      final forecasts = await _WeatherService.getFiveDayForecast(cityName);
      
        List<Location> locations = await locationFromAddress(cityName);
        double lat = locations[0].latitude;
        double lon = locations[0].longitude;

        final results = await Future.wait([
          _WeatherService.fetchAirQuality(lat, lon),
        ]);
        setState(() {
          aqiData = results[0] as AirQuality;
        });
      
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
        return 'assets/clouds.png';
      case 'mist':
      case 'smoke':
      case 'haze':
      case 'dust':
      case 'fog':
        return 'assets/mist.png';
      case 'rain':
        return 'assets/rain.png';
      case 'drizzle':
        return 'assets/drizzle.png';
      case 'shower rain':
        return 'assets/shower.png';
      case 'thunderstorm':
        return 'assets/thunder rain.png';
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
              _forecasts != null ?
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
                    const SizedBox(height: 28),
                    Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back)),
                          Row(
                            children: [
                              const Icon(Icons.location_on),
                              const SizedBox(width: 7),
                              Text(
                                _weather?.cityName ?? "loading city...",
                                style: const TextStyle(
                                  fontSize: 22,
                                ),
                              ),
                            ],
                          ),
                          IconButton(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => WeatherMap()));
                              },
                              icon: const Icon(Icons.map_outlined))
                        ],
                      ),
                    ),
                    const SizedBox(height: 14),
                    // const SizedBox(height: 87),
                    Center(
                      child: Text(
                        "   ${actualDate} | ${actualTime}",
                        style: const TextStyle(fontSize: 18),
                      ),
                    ),
                    const SizedBox(height: 20),
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
                        getWeatherAnimation(_weather?.mainCondition,),
                        width: 200),
                    const SizedBox(height: 15),
                    Center(
                      child: Text(
                        _weather?.mainCondition ?? "",
                        style: const TextStyle(
                            fontSize: 23,
                            color: Colors.blue,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(height: 15),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      child: Container(
                        width: 360,
                        height: 125,
                        decoration: ShapeDecoration(
                          color: Colors.transparent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(top: 10.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Container(
                                width: 110,
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
                                width: 110,
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
                                    const SizedBox(height: 5),
                                    Image.asset(
                                      'assets/pressure.png',
                                      fit: BoxFit.contain,
                                      width: 45,
                                    ),
                                    const SizedBox(height: 5),
                                    Text(
                                      "${_weather?.pressure} mb",
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
                                width: 110,
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
                                      "Precipitation",
                                      style: TextStyle(fontSize: 15),
                                    ),
                                    const SizedBox(height: 5),
                                    Image.asset(
                                      'assets/shower.png',
                                      fit: BoxFit.contain,
                                      width: 35,
                                    ),
                                    const SizedBox(height: 5),
                                    Text(
                                      "5 mm",
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
                              "  5 Day Forecasts",
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
                    const SizedBox(height: 0),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 0, vertical: 10),
                      height: 145,
                      width: double.infinity,
                      child: ListView(
                        padding: EdgeInsets.symmetric(horizontal: 12),
                        scrollDirection: Axis.horizontal,
                        children: List.generate(5, (index) {
                          final forecast = _forecasts![index];
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 5),
                            child: Container(
                              width: 77,
                              height: 260,
                              decoration: ShapeDecoration(
                                color: Colors.white.withOpacity(0.5),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                    side: const BorderSide(
                                        width: 2.5, color: Colors.white)),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Text(
                                    DateFormat('EEE').format(forecast.dateTime),
                                    style: const TextStyle(
                                        fontSize: 15, color: Colors.black),
                                  ),
                                  const SizedBox(height: 5),
                                  Image.asset(getWeatherAnimation(forecast.mainCondition),
                                      width: 30),
                                  const SizedBox(height: 5),
                                  Text(
                                    "${forecast.temperature.round()}°C",
                                    style: const TextStyle(
                                        fontSize: 15,
                                        color: Colors.blue,
                                        fontWeight: FontWeight.bold),
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
                    ),
                  ],
                ),
              ) : Container(
                height: 1000, child: Center(child: LoadingScreen())),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: const Text(
                          "Today Forecast",
                          textAlign: TextAlign.start,
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ]),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Container(
                      width: 175,
                      height: 105,
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      decoration: ShapeDecoration(
                        color: Colors.white.withOpacity(0.5),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                            side: const BorderSide(
                                width: 2.5, color: Colors.white)),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              const Text(
                                "Min Temp",
                                style: TextStyle(fontSize: 15),
                              ),
                              Image.asset(
                                'assets/min.png',
                                fit: BoxFit.contain,
                                width: 15,
                              ),
                              Text(
                                "${_weather?.minTemp.round()}°C",
                                style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.blue,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              const Text(
                                "Max Temp",
                                style: TextStyle(fontSize: 15),
                              ),
                              Image.asset(
                                'assets/max.png',
                                fit: BoxFit.contain,
                                width: 15,
                              ),
                              Text(
                                "${_weather?.maxTemp.round()}°C",
                                style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.blue,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 5),
                    Container(
                      width: 175,
                      height: 105,
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      decoration: ShapeDecoration(
                        color: Colors.white.withOpacity(0.5),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                            side: const BorderSide(
                                width: 2.5, color: Colors.white)),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _weather != null
                          ? Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              const Text(
                                "Sunrise",
                                style: TextStyle(fontSize: 15),
                              ),
                              Image.asset(
                                'assets/clear.png',
                                fit: BoxFit.contain,
                                width: 35,
                              ),
                              Text(
                                "${DateFormat('HH:mm').format(DateTime.fromMillisecondsSinceEpoch(_weather!.sunrise * 1000).toLocal())}",
                                style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.blue,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          )
                          : Center(child: CircularProgressIndicator()),
                          _weather != null
                          ? Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              const Text(
                                "Sunset",
                                style: TextStyle(fontSize: 15),
                              ),
                              Image.asset(
                                'assets/clear.png',
                                fit: BoxFit.contain,
                                width: 35,
                              ),
                              Text(
                                "${DateFormat('HH:mm').format(DateTime.fromMillisecondsSinceEpoch(_weather!.sunset * 1000).toLocal())}",
                                style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.blue,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          )
                          : Center(child: CircularProgressIndicator()),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 15),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Container(
                      width: 360,
                      height: 65,
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      decoration: ShapeDecoration(
                        color: Colors.white.withOpacity(0.5),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                            side: const BorderSide(
                                width: 2.5, color: Colors.white)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          const Text(
                            "Wind",
                            style: TextStyle(fontSize: 15),
                          ),
                          Image.asset(
                            'assets/wind.png',
                            fit: BoxFit.contain,
                            width: 45,
                          ),
                          Text(
                            "West",
                            style: TextStyle(
                              fontSize: 15,
                            ),
                          ),
                          Transform.rotate(
                            // angle: windDirection * (3.1416 / 180), // Convert degrees to radians
                            angle: 150.0,
                            child: Icon(
                              Icons
                                  .arrow_right_alt, // Arrow pointing up (initial)
                              size: 30,
                              color: Colors.blue,
                            ),
                          ),
                          Text(
                            "${_weather?.windSpeed} km/h",
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
              const SizedBox(height: 15),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Container(
                      width: 175,
                      height: 65,
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      decoration: ShapeDecoration(
                        color: Colors.white.withOpacity(0.5),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                            side: const BorderSide(
                                width: 2.5, color: Colors.white)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          const Text(
                            "Feels Like",
                            style: TextStyle(fontSize: 15),
                          ),
                          Image.asset(
                            'assets/clear.png',
                            fit: BoxFit.contain,
                            width: 35,
                          ),
                          Text(
                            "${_weather?.feelsLike.round()}°C",
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
                      width: 175,
                      height: 65,
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      decoration: ShapeDecoration(
                        color: Colors.white.withOpacity(0.5),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                            side: const BorderSide(
                                width: 2.5, color: Colors.white)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          const Text(
                            "Dew Point",
                            style: TextStyle(fontSize: 15),
                          ),
                          Image.asset(
                            'assets/water.png',
                            fit: BoxFit.contain,
                            width: 24,
                          ),
                          const Text(
                            "8°C",
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
              const SizedBox(height: 15),              
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Container(
                      width: 360,
                      height: 65,
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      decoration: ShapeDecoration(
                        color: Colors.white.withOpacity(0.5),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                            side: const BorderSide(
                                width: 2.5, color: Colors.white)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          const Text(
                            "Gust",
                            style: TextStyle(fontSize: 15),
                          ),
                          Image.asset(
                            'assets/wind.png',
                            fit: BoxFit.contain,
                            width: 45,
                          ),
                          Text(
                            "West",
                            style: TextStyle(
                              fontSize: 15,
                            ),
                          ),
                          Transform.rotate(
                            angle: 150.0,
                            child: Icon(
                              Icons.arrow_right_alt,
                              size: 30,
                              color: Colors.blue,
                            ),
                          ),
                          Text(
                            "${_weather?.windSpeed}km/h",
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
              const SizedBox(height: 15),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Container(
                      width: 175,
                      height: 65,
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      decoration: ShapeDecoration(
                        color: Colors.white.withOpacity(0.5),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                            side: const BorderSide(
                                width: 2.5, color: Colors.white)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          const Text(
                            "Cloudiness",
                            style: TextStyle(fontSize: 15),
                          ),
                          Image.asset(
                            'assets/clouds.png',
                            fit: BoxFit.contain,
                            width: 35,
                          ),
                          Text(
                            "${_weather?.cloudiness}%",
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
                      width: 175,
                      height: 65,
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      decoration: ShapeDecoration(
                        color: Colors.white.withOpacity(0.5),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                            side: const BorderSide(
                                width: 2.5, color: Colors.white)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          
                          const Text(
                            "Cloudiness",
                            style: TextStyle(fontSize: 15),
                          ),
                          Image.asset(
                            'assets/clouds.png',
                            fit: BoxFit.contain,
                            width: 35,
                          ),
                          _weather != null
                          ?Text(
                            "${(_weather!.visibility / 1000).round()} km",
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.blue,
                                fontWeight: FontWeight.bold),
                          )
                          : Center(child: CircularProgressIndicator()),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 15),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Container(
                      width: 360,
                      height: 65,
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      decoration: ShapeDecoration(
                        color: Colors.white.withOpacity(0.5),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                            side: const BorderSide(
                                width: 2.5, color: Colors.white)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          const Text(
                            "Air Quality Index",
                            style: TextStyle(fontSize: 15),
                          ),
                          Image.asset(
                            'assets/wind.png',
                            fit: BoxFit.contain,
                            width: 45,
                          ),
                          const Text(
                            "2",
                            style: TextStyle(
                              fontSize: 15,
                            ),
                          ),
                          Row(
                            children: [
                              TextButton(
                                child: const Text(
                                  "More",
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.blue,
                                  ),
                                ),
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const AirQualityIndex()));
                                },
                              ),
                              const SizedBox(width: 3),
                              const Icon(
                                Icons.arrow_forward_ios,
                                size: 13,
                                color: Colors.blue,
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 25),
            ],
          ),
        ),
      ),
    );
  }
}
