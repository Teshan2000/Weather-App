import 'dart:async';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weather_app/main.dart';
import 'package:weather_app/models/airQualityModel.dart';
import 'package:weather_app/models/dailyAirQualityModel.dart';
import 'package:weather_app/models/weatherModel.dart';
import 'package:weather_app/models/forecastModel.dart';
import 'package:weather_app/providers/weatherService.dart';
import 'package:weather_app/screens/airQualityIndex.dart';
import 'package:weather_app/screens/forecasts.dart';
import 'package:weather_app/screens/locations.dart';
import 'package:weather_app/screens/splash.dart';
import 'package:weather_app/screens/weatherMap.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool isConnected = false;
  StreamSubscription? _internetConnectionStreamSubscription;
  final _WeatherService = WeatherService('252bb571d411f6016045c128fcd11393');
  Weather? _weather;
  List<Forecast>? _forecasts;
  AirQuality? aqiData;
  List<AirQualityForecast>? airforecasts;
  late Future<List<AirQualityForecast>> airQualityData;
  String? cityName;
  double? userLatitude;
  double? userLongitude;

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
      ),
    );
    _checkConnection();
  }

  @override
  void dispose() {
    _internetConnectionStreamSubscription?.cancel();
    super.dispose();
  }

  void _checkConnection() async {
    final hasConnection = await InternetConnection().hasInternetAccess;

    if (hasConnection) {
      setState(() => isConnected = true);
      _requestLocationPermission();
    } else {
      setState(() => isConnected = false);
      _showNoConnectionDialog();
    }

    _internetConnectionStreamSubscription =
        InternetConnection().onStatusChange.listen((event) {
      if (event == InternetStatus.connected && !isConnected) {
        setState(() => isConnected = true);
        _requestLocationPermission();
      } else if (event == InternetStatus.disconnected) {
        setState(() => isConnected = false);
        _showNoConnectionDialog();
      }
    });
  }

  Future<void> _requestLocationPermission() async {
    try {
      LocationPermission permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      if (permission == LocationPermission.deniedForever) {
        if (mounted) {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text("Location Permission"),
                content: const Text(
                    "Weather app needs location permission to show your local weather."),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text("Continue"),
                  ),
                ],
              );
            },
          );
        }
      } else if (permission == LocationPermission.whileInUse ||
          permission == LocationPermission.always) {
        fetchWeather();
      } else {
        fetchWeather();
      }
    } catch (e) {
      print('Error requesting location permission: $e');
      fetchWeather();
    }
  }

  void _showNoConnectionDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("No Internet Connection"),
          content: const Text(
              "Please check your internet connection and try again."),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Retry"),
            ),
          ],
        );
      },
    );
  }

  fetchWeather() async {
    try {
      final locationData = await _WeatherService.getCurrentCityWithPosition();
      cityName = locationData['city'];
      userLatitude = locationData['latitude'];
      userLongitude = locationData['longitude'];

      final weather = await _WeatherService.getWeather(cityName!);
      var weatherForecasts =
          await _WeatherService.getFiveDayForecast(cityName!);

      final results = await Future.wait([
        _WeatherService.fetchAirQuality(userLatitude!, userLongitude!),
        _WeatherService.fetchAirQualityForecast(userLatitude!, userLongitude!),
      ]);

      if (!mounted) return;
      setState(() {
        aqiData = results[0] as AirQuality;
        airforecasts = results[1] as List<AirQualityForecast>;
      });

      setState(() {
        _weather = weather;
        _forecasts = weatherForecasts;
        airQualityData = Future.value(airforecasts);
      });
    } catch (e) {
      print(e);
    }
  }

  String getWeatherAnimation(String? mainCondition, {int? sunrise, int? sunset}) {
    if (mainCondition == null) return 'assets/clear.png';

    if (mainCondition.toLowerCase() == 'clear') {
      if (sunrise != null && sunset != null) {
        final now = DateTime.now().toUtc().millisecondsSinceEpoch ~/ 1000;
        if (now >= sunrise && now < sunset) {
          return 'assets/clear.png';
        } else {
          return 'assets/night clear.png';
        }
      }
      return 'assets/clear.png';
    }

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
      case 'snow':
        return 'assets/snow.png';
      default:
        return 'assets/clear.png';
    }
  }

  String getWindDirection(int windDirection) {
    if (windDirection >= 337.5 || windDirection < 22.5) {
      return 'North';
    } else if (windDirection >= 22.5 && windDirection < 67.5) {
      return 'North-East';
    } else if (windDirection >= 67.5 && windDirection < 112.5) {
      return 'East';
    } else if (windDirection >= 112.5 && windDirection < 157.5) {
      return 'South-East';
    } else if (windDirection >= 157.5 && windDirection < 202.5) {
      return 'South';
    } else if (windDirection >= 202.5 && windDirection < 247.5) {
      return 'South-West';
    } else if (windDirection >= 247.5 && windDirection < 292.5) {
      return 'West';
    } else if (windDirection >= 292.5 && windDirection < 337.5) {
      return 'North-West';
    } else {
      return 'Unknown';
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = ScreenSize.width(context);
    double height = ScreenSize.height(context);
    bool isLandscape = ScreenSize.orientation(context);

    var nowUtc = DateTime.now().toUtc();
    var cityNow = _weather != null
      ? nowUtc.add(Duration(seconds: _weather!.timezone)) : nowUtc;
    var formatterDate = DateFormat('EEE d MMM');
    var formatterTime = DateFormat('kk:mm');
    String actualDate = formatterDate.format(cityNow);
    String actualTime = formatterTime.format(cityNow);
    var dayOrNight = (_weather != null && (nowUtc.millisecondsSinceEpoch ~/ 1000 >= _weather!.sunrise 
      && nowUtc.millisecondsSinceEpoch ~/ 1000 < _weather!.sunset)) ? 'day' : 'night';

    return Scaffold(
      body: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/background.png'),
            fit: BoxFit.cover,
        )),
        child: SingleChildScrollView(
          child: Column(
            children: [
              _forecasts != null
                  ? Column(
                      children: [
                        Container(
                          height: isLandscape ? 
                            (_weather?.mainCondition.toLowerCase() == 'rain' 
                            || _weather?.mainCondition.toLowerCase() == 'thunderstorm'
                            ? 920 : _weather?.mainCondition.toLowerCase() == 'drizzle' 
                            ? 980 : _weather?.mainCondition.toLowerCase() == 'clouds' 
                            ? 880 : _weather?.mainCondition.toLowerCase() == 'clear' 
                            && dayOrNight == 'night' ? 950 : 910) 
                              
                            : _weather?.mainCondition.toLowerCase() == 'rain' 
                            || _weather?.mainCondition.toLowerCase() == 'thunderstorm'
                            ? 790 : _weather?.mainCondition.toLowerCase() == 'drizzle' 
                            ? 850 : _weather?.mainCondition.toLowerCase() == 'clouds' 
                            ? 750 : _weather?.mainCondition.toLowerCase() == 'clear' 
                            && dayOrNight == 'night' ? 820 : 780,
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
                              SizedBox(height: isLandscape ? height * 0.1 : 28),
                              Center(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(left: 5.0),
                                      child: IconButton(
                                          onPressed: () {
                                            Navigator.push(
                                              context, MaterialPageRoute(
                                                builder: (context) => Locations()));
                                          },
                                          icon: const Icon(
                                            Icons.add_location_alt_outlined)),
                                    ),
                                    Row(
                                      children: [
                                        const Icon(Icons.location_on),
                                        const SizedBox(width: 7),
                                        Text(
                                          _weather?.cityName ??
                                            "loading city...",
                                          style: const TextStyle(
                                            fontSize: 22,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(right: 5.0),
                                      child: IconButton(
                                        onPressed: () {
                                          Navigator.push(
                                            context, MaterialPageRoute(
                                              builder: (context) => WeatherMap(
                                                city: cityName ?? 'Unknown',
                                                latitude: userLatitude,
                                                longitude: userLongitude,
                                              )));
                                        },
                                        icon: const Icon(Icons.map_outlined)),
                                    )
                                  ],
                                ),
                              ),
                              SizedBox(height: isLandscape ? height * 0.05 : 10),
                              Center(
                                child: Text(
                                  "   $actualDate | $actualTime",
                                  style: const TextStyle(fontSize: 18),
                                ),
                              ),
                              SizedBox(height: isLandscape ? height * 0.05 : 16),
                              Center(
                                child: Text(
                                  "${_weather?.temperature.round()}°C",
                                  style: const TextStyle(
                                    fontSize: 55,
                                    color: Colors.blue,
                                    fontWeight: FontWeight.bold),
                                ),
                              ),
                              SizedBox(height: isLandscape ? height * 0.05 : 5),
                              Image.asset(
                                getWeatherAnimation(
                                  _weather?.mainCondition,
                                  sunrise: _weather?.sunrise,
                                  sunset: _weather?.sunset,
                                ),
                                width: isLandscape ? width * 0.3 : 200),
                              SizedBox(height: isLandscape ? height * 0.05 : 12),
                              Center(
                                child: Text(
                                  _weather?.mainCondition ?? "",
                                  style: const TextStyle(
                                    fontSize: 23,
                                    color: Colors.blue,
                                    fontWeight: FontWeight.bold),
                                ),
                              ),
                              SizedBox(height: isLandscape ? height * 0.02 : 12),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 5),
                                child: Container(
                                  width: isLandscape ? width * 0.95 : 360,
                                  height: isLandscape ? height * 0.5 : 125,
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
                                          width: isLandscape ? width * 0.30 : 110,
                                          height: 125,
                                          padding: const EdgeInsets.symmetric(vertical: 10),
                                          decoration: ShapeDecoration(
                                            color: Colors.white.withOpacity(0.5),
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(15),
                                              side: const BorderSide(
                                                width: 2.5,
                                                color: Colors.white)),
                                          ),
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.spaceAround,
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
                                        SizedBox(width: 5),
                                        Container(
                                          width: isLandscape ? width * 0.30 : 110,
                                          height: 125,
                                          padding: const EdgeInsets.symmetric(vertical: 10),
                                          decoration: ShapeDecoration(
                                            color: Colors.white.withOpacity(0.5),
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(15),
                                              side: const BorderSide(
                                                width: 2.5,
                                                color: Colors.white)),
                                          ),
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.spaceAround,
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
                                                "${_weather?.pressure} mb",
                                                style: TextStyle(
                                                  fontSize: 15,
                                                  color: Colors.blue,
                                                  fontWeight: FontWeight.bold),
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(width: 5),
                                        Container(
                                          width: isLandscape ? width * 0.30 : 110,
                                          height: 125,
                                          padding: const EdgeInsets.symmetric(vertical: 10),
                                          decoration: ShapeDecoration(
                                            color: Colors.white.withOpacity(0.5),
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(15),
                                              side: const BorderSide(
                                                width: 2.5,
                                                color: Colors.white)),
                                          ),
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                                            children: [
                                              const Text(
                                                "Precipitation",
                                                style: TextStyle(fontSize: 15),
                                              ),
                                              Image.asset(
                                                'assets/shower.png',
                                                fit: BoxFit.contain,
                                                width: 35,
                                              ),
                                              Text(
                                                _weather?.precipitation == 0.0 ||
                                                _weather?.precipitation == null
                                                  ? "No rain"
                                                  : "${(_weather?.precipitation)?.round()} mm",
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
                              SizedBox(height: isLandscape ? height * 0.02 : 12),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 15),
                                child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      const Text(
                                        "  5 Day Forecasts",
                                        textAlign: TextAlign.start,
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          Navigator.push(
                                            context, MaterialPageRoute(
                                              builder: (context) => Forecasts(
                                                forecasts: _forecasts,
                                                time: dayOrNight,
                                              ),
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
                                        width: isLandscape ? height * 0.36 : 77,
                                        height: 260,
                                        decoration: ShapeDecoration(
                                          color: Colors.white.withOpacity(0.5),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(20),
                                            side: const BorderSide(
                                              width: 2.5,
                                              color: Colors.white)),
                                        ),
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: <Widget>[
                                            Text(
                                              DateFormat('EEE').format(forecast.dateTime),
                                              style: const TextStyle(
                                                fontSize: 15,
                                                color: Colors.black),
                                            ),
                                            const SizedBox(height: 5),
                                            Image.asset(
                                              getWeatherAnimation(forecast.mainCondition),
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
                                                fontSize: 15,
                                                color: Colors.blue),
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
                        ),
                        SizedBox(height: isLandscape ? height * 0.1 : 20),
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
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ]),
                        ),
                        SizedBox(height: isLandscape ? height * 0.05 : 20),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              Container(
                                width: isLandscape ? width * 0.46 : 175,
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
                                width: isLandscape ? width * 0.46 : 175,
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
                                                "${DateFormat('HH:mm').format(DateTime.fromMillisecondsSinceEpoch((_weather!.sunrise * 1000) + (_weather!.timezone * 1000), isUtc: true))}",
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
                                                'assets/night clear.png',
                                                fit: BoxFit.contain,
                                                width: 35,
                                              ),
                                              Text(
                                                "${DateFormat('HH:mm').format(DateTime.fromMillisecondsSinceEpoch((_weather!.sunset * 1000) + (_weather!.timezone * 1000), isUtc: true))}",
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
                        SizedBox(height: isLandscape ? height * 0.04 : 15),
                        _weather?.windDirection != null
                            ? Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 10),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: <Widget>[
                                    Container(
                                      width: isLandscape ? width * 0.95 : 360,
                                      height: 65,
                                      padding: const EdgeInsets.symmetric(vertical: 10),
                                      decoration: ShapeDecoration(
                                        color: Colors.white.withOpacity(0.5),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(15),
                                          side: const BorderSide(
                                            width: 2.5,
                                            color: Colors.white)),
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
                                            getWindDirection(_weather!.windDirection),
                                            style: TextStyle(
                                              fontSize: 15,
                                              color: Colors.blue,
                                              fontWeight: FontWeight.bold),
                                          ),
                                          Transform.rotate(
                                            angle: _weather!.windDirection.toDouble(),
                                            child: Icon(
                                              Icons.arrow_right_alt,
                                              size: 30,
                                              color: Colors.blue,
                                            ),
                                          ),
                                          Text(
                                            "${(_weather!.windSpeed * 3.6).round()} km/h",
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
                              )
                            : CircularProgressIndicator(),
                        SizedBox(height: isLandscape ? height * 0.04 : 15),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              Container(
                                width: isLandscape ? width * 0.46 : 175,
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
                              _weather?.temperature != null &&
                              _weather?.humidity != null
                                  ? Container(
                                      width: isLandscape ? width * 0.46 : 175,
                                      height: 65,
                                      padding: const EdgeInsets.symmetric(vertical: 10),
                                      decoration: ShapeDecoration(
                                        color: Colors.white.withOpacity(0.5),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(15),
                                          side: const BorderSide(
                                            width: 2.5,
                                            color: Colors.white)),
                                      ),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                                        children: [
                                          const Text(
                                            "Dew Point",
                                            style: TextStyle(fontSize: 15),
                                          ),
                                          Image.asset(
                                            'assets/dew.png',
                                            fit: BoxFit.contain,
                                            width: 28,
                                          ),
                                          Text(
                                            "${((_weather?.temperature)! - ((100 - _weather!.humidity) / 5)).round()}°C",
                                            style: TextStyle(
                                              fontSize: 15,
                                              color: Colors.blue,
                                              fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                    )
                                : CircularProgressIndicator(),
                            ],
                          ),
                        ),
                        SizedBox(height: isLandscape ? height * 0.04 : 15),
                        _weather?.windDirection != null
                            ? Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 10),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: <Widget>[
                                    Container(
                                      width: isLandscape ? width * 0.95 : 360,
                                      height: 65,
                                      padding: const EdgeInsets.symmetric(vertical: 10),
                                      decoration: ShapeDecoration(
                                        color: Colors.white.withOpacity(0.5),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(15),
                                          side: const BorderSide(
                                            width: 2.5,
                                            color: Colors.white)),
                                      ),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                                        children: [
                                          Text(
                                            "Gust",
                                            style: TextStyle(fontSize: 15),
                                          ),
                                          Image.asset(
                                            'assets/wind.png',
                                            fit: BoxFit.contain,
                                            width: 45,
                                          ),
                                          Text(
                                            getWindDirection(_weather!.windDirection),
                                            style: TextStyle(
                                              fontSize: 15,
                                              color: Colors.blue,
                                              fontWeight: FontWeight.bold),
                                          ),
                                          Transform.rotate(
                                            angle: (_weather!.windDirection.toDouble()),
                                            child: Icon(
                                              Icons.arrow_right_alt,
                                              size: 30,
                                              color: Colors.blue,
                                            ),
                                          ),
                                          Text(
                                            "${(_weather!.gustSpeed * 3.6).round()} km/h",
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
                              )
                            : CircularProgressIndicator(),
                        SizedBox(height: isLandscape ? height * 0.04 : 15),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              Container(
                                width: isLandscape ? width * 0.46 : 175,
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
                                width: isLandscape ? width * 0.46 : 175,
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
                                      "Visibility",
                                      style: TextStyle(fontSize: 15),
                                    ),
                                    Image.asset(
                                      'assets/mist.png',
                                      fit: BoxFit.contain,
                                      width: 35,
                                    ),
                                    _weather != null
                                      ? Text(
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
                        SizedBox(height: isLandscape ? height * 0.04 : 15),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              Container(
                                width: isLandscape ? width * 0.95 : 360,
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
                                    Text(
                                      "${aqiData?.aqi}",
                                      style: TextStyle(
                                        fontSize: 15,
                                        color: Colors.blue,
                                        fontWeight: FontWeight.bold),
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
                                              context, MaterialPageRoute(
                                                builder: (context) => AirQualityIndex(
                                                  aqiData: aqiData,
                                                  forecasts: airforecasts,
                                                )));
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
                        SizedBox(height: isLandscape ? height * 0.05 : 25),
                      ],
                    )
                  : Container(height: height, child: Center(child: LoadingScreen())),
            ],
          ),
        ),
      ),
    );
  }
}
