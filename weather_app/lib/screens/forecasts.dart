import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weather_app/models/forecastModel.dart';
import 'package:weather_app/providers/weatherService.dart';
import 'package:weather_app/screens/splash.dart';

class Forecasts extends StatefulWidget {
  const Forecasts({super.key});

  @override
  State<Forecasts> createState() => _ForecastsState();
}

class _ForecastsState extends State<Forecasts> {
  PageController _controller = PageController();
  final WeatherService _weatherService =
      WeatherService('c3281946b6139602ecabb86fd3e733c2');
  List<Forecast>? _forecasts;
  final now = DateTime.now();
  
  int currentPage = 0;

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

  String rainPrecipitation(double? pop) {
    if ((pop! * 100).round() <= 40) {
      return "assets/rainbow.png";
    } else if (pop == null) {
      return "assets/rainbow.png";
    } else {
      return "assets/umbrella.png";
    }
  }

  @override
  void initState() {
    super.initState();
    fetchWeather();

    _controller.addListener(() {
    setState(() {
      currentPage = _controller.page!.round();
    });
  });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: const Center(
          child: Text("5 Day Forecasts"),
        ),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.calendar_month))
        ],
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(
            image: DecorationImage(
          image: AssetImage('assets/background.png'),
          fit: BoxFit.cover,
        )),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(0),
            child: SafeArea(
              child: Column(
                children: [
                  _forecasts != null
                      ? SizedBox(
                          height: 270,
                          child: PageView.builder(
                            controller: _controller, 
                            scrollDirection: Axis.horizontal,
                            itemCount: 5,
                            itemBuilder: (context, index) {
                              final forecast = _forecasts![index];
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 0, vertical: 10),
                                child: Container(
                                  width: double.infinity,
                                  decoration: ShapeDecoration(
                                    shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.only(
                                          bottomLeft: Radius.circular(20),
                                          bottomRight: Radius.circular(20)),
                                    ),
                                    image: DecorationImage(
                                      image:
                                          AssetImage('assets/background.png'),
                                      fit: BoxFit.cover,
                                    ),
                                    shadows: [
                                      BoxShadow(
                                        color: Colors.blue.withOpacity(0.5),
                                        blurRadius: 7,
                                        offset: Offset(0, 6),
                                      ),
                                    ],
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20, vertical: 20),
                                    child: Column(
                                      children: [
                                        Expanded(
                                          child: Row(
                                            children: [
                                              forecast.dateTime.day == now.day && 
                                              forecast.dateTime.month == now.month && 
                                              forecast.dateTime.year == now.year
                                                  ? const Spacer()
                                                  : Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      const Spacer(),
                                                      const Spacer(),
                                                      IconButton(
                                                          onPressed: () {
                                                            _controller.previousPage(
                                                              duration: Duration(milliseconds: 500),
                                                              curve: Curves.easeInOut);
                                                          },
                                                          icon: Icon(Icons.arrow_back_ios,
                                                              color: Colors.blue)),
                                                      const Spacer(),
                                                      const Spacer(),
                                                    ],
                                                  ),
                                              Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [                                                  
                                                  const Spacer(),
                                                  Text(
                                                    forecast.dateTime.day == now.day && 
                                                    forecast.dateTime.month == now.month && 
                                                    forecast.dateTime.year == now.year ? "Today"
                                                    : DateFormat.EEEE().format(forecast.dateTime),
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
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.blue,
                                                    ),
                                                  ),
                                                  const Spacer(),
                                                  Text(
                                                    "${forecast.mainCondition}",
                                                    textAlign: TextAlign.center,
                                                    style: const TextStyle(
                                                        fontSize: 20,
                                                        color: Colors.blue),
                                                  ),
                                                  const Spacer(),
                                                  const Spacer(),
                                                ],
                                              ),
                                              const Spacer(),
                                              Column(
                                                children: [
                                                  Image.asset(
                                                    getWeatherAnimation(forecast.mainCondition),
                                                    width: 170),
                                                  const Spacer(),
                                                ],
                                              ),
                                              const Spacer(),
                                              forecast.dateTime == (_forecasts!.last.dateTime).subtract(Duration(days: 1))
                                              ? const Spacer() 
                                              : Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  const Spacer(),
                                                  const Spacer(),
                                                  IconButton(
                                                      onPressed: () {
                                                        _controller.nextPage(
                                                          duration: Duration(milliseconds: 500),
                                                          curve: Curves.easeInOut);
                                                      },
                                                      icon: Icon(Icons.arrow_forward_ios,
                                                          color: Colors.blue)),
                                                  const Spacer(),
                                                  const Spacer(),
                                                ],
                                              )
                                            ],
                                          ),
                                        ),
                                        Container(
                                          width: 310,
                                          decoration: ShapeDecoration(
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(15),
                                                side: const BorderSide(
                                                    width: 2.5,
                                                    color: Colors.white)),
                                            color:
                                                Colors.white.withOpacity(0.50),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 30, vertical: 12),
                                            child: Center(
                                              child: Row(
                                                children: [
                                                  const Spacer(),
                                                  Image.asset(
                                                    rainPrecipitation(forecast.pop),
                                                    fit: BoxFit.fitWidth,
                                                    height: 35,
                                                  ),
                                                  const Spacer(),
                                                  Text(
                                                    forecast.pop != null
                                                        ? "${(forecast.pop! * 100).round()}% chance of rain today"
                                                        : "No rain expected today",
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
                          ),
                        )
                      : Container(
                      height: 1000, child: Center(child: LoadingScreen())),
                  const SizedBox(height: 15),
                  _forecasts != null
                      ? ListView.builder(
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
                                          DateFormat.EEEE()
                                              .format(forecast.dateTime),
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(
                                              fontSize: 16,
                                              color: Colors.black),
                                        ),
                                        const Spacer(),
                                        Image.asset(
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
                        )
                      : Center(child: CircularProgressIndicator()),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
