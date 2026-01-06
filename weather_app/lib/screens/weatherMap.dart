import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:weather_app/main.dart';
import 'package:weather_app/models/airQualityModel.dart';
import 'package:weather_app/models/weatherModel.dart';
import 'package:weather_app/providers/weatherService.dart';
import 'package:weather_app/screens/splash.dart';

class WeatherMap extends StatefulWidget {
  @override
  _WeatherMapState createState() => _WeatherMapState();
}

class _WeatherMapState extends State<WeatherMap> {
  final String apiKey = '252bb571d411f6016045c128fcd11393';
  final _WeatherService = WeatherService('252bb571d411f6016045c128fcd11393');
  Weather? _weather;
  AirQuality? aqiData;
  final MapController _mapController = MapController();
  LatLng? _mapCenter;

  bool _showClouds = false;
  bool _showTemp = false;
  bool _showAirQuality = false;
  bool _showWinds = false;
  bool _showPrecipitation = false;
  bool _showPressure = false;

  Future<Position> _getCurrentPosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception('Location permissions are permanently denied');
    }

    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
  }

  fetchWeather() async {
    String cityName = await _WeatherService.getCurrentCity();
    try {
      final weather = await _WeatherService.getWeather(cityName);
      final position = await _getCurrentPosition();
      double lat = position.latitude;
      double lon = position.longitude;

      final results = await Future.wait([
        _WeatherService.fetchAirQuality(lat, lon),
      ]);

      setState(() {
        aqiData = results[0];
        _weather = weather;
        _mapCenter = LatLng(lat, lon);
      });

      WidgetsBinding.instance.addPostFrameCallback((_) {
        try {
          _mapController.move(_mapCenter!, 16.0);
        } catch (_) {}
      });
    } catch (e) {
      print(e);
    }
  }

  String airQualityForecastDescription(int? aqi) {
    if (aqi == null) return "No internet connection";

    switch (aqi) {
      case 1:
        return "Good";
      case 2:
        return "Fair";
      case 3:
        return "Moderate";
      case 4:
        return "Poor";
      case 5:
        return "Unhealthy";
      default:
        return "Unavailable";
    }
  }

  @override
  void initState() {
    super.initState();
    fetchWeather();
  }

  @override
  Widget build(BuildContext context) {
    double width = ScreenSize.width(context);
    double height = ScreenSize.height(context);
    bool isLandscape = ScreenSize.orientation(context);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Color.fromARGB(255, 184, 226, 245),
        title: const Center(
          child: Text("Weather Map"),
        ),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.map_outlined))
        ],
      ),
      body: Container(
        width: width,
        height: height,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/background.png'),
            fit: BoxFit.cover,
        )),
        child: Stack(
          children: [
            _mapCenter == null ? Container(
              height: 1000, child: Center(child: LoadingScreen())) :
            FlutterMap(
              mapController: _mapController,
              options: MapOptions(
                initialCenter: _mapCenter!,
                initialZoom: 16.0,
              ),
              children: [
                TileLayer(
                  urlTemplate:
                      'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                  subdomains: ['a', 'b', 'c'],
                ),
                if (_showClouds)
                  TileLayer(
                    urlTemplate:
                        'https://tile.openweathermap.org/map/clouds_new/{z}/{x}/{y}.png?appid=$apiKey',
                  ),
                if (_showWinds)
                  TileLayer(
                    urlTemplate:
                        'https://tile.openweathermap.org/map/wind_new/{z}/{x}/{y}.png?appid=$apiKey',
                  ),
                if (_showTemp)
                  TileLayer(
                    urlTemplate:
                        'https://tile.openweathermap.org/map/temp_new/{z}/{x}/{y}.png?appid=$apiKey',
                  ),
                if (_showPrecipitation)
                  TileLayer(
                    urlTemplate:
                        'https://tile.openweathermap.org/map/precipitation_new/{z}/{x}/{y}.png?appid=$apiKey',
                  ),
                if (_showPressure)
                  TileLayer(
                    urlTemplate:
                        'https://tile.openweathermap.org/map/pressure_new/{z}/{x}/{y}.png?appid=$apiKey',
                  ),
                MarkerLayer(markers: [
                  Marker(
                      point: _mapCenter!,
                      child: Icon(
                        Icons.location_on,
                        color: Colors.red,
                      )),
                ]),
              ],
            ),
            if (_showAirQuality)
              Container(
                color: Colors.green.withOpacity(0.5),
                width: width,
                height: height,
              ),
            Positioned(
              bottom: 0,
              child: Container(
                padding: const EdgeInsets.only(
                  top: 10, bottom: 20, left: 10, right: 10),
                width: width,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(15),
                        topRight: Radius.circular(15)),
                    image: DecorationImage(
                      image: AssetImage('assets/background.png'),
                      fit: BoxFit.cover,
                    )),
                child: isLandscape
                    ? SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            WeatherButton(
                              label: "Clouds",
                              value: '${_weather?.cloudiness ?? 0}%',
                              icon: "assets/clouds.png",
                              iconWidth: 35,
                              heroTag: 'cloudsTag',
                              condtion: _showClouds,
                              onPressed: () {
                                setState(() {
                                  _showClouds = !_showClouds;
                                });
                              },
                            ),
                            SizedBox(width: width * 0.01),
                            WeatherButton(
                              label: "Temperature",
                              value: '${_weather?.temperature.round() ?? 0}°C',
                              icon: "assets/min.png",
                              iconWidth: 15,
                              heroTag: 'tempTag',
                              condtion: _showTemp,
                              onPressed: () {
                                setState(() {
                                  _showTemp = !_showTemp;
                                });
                              },
                            ),
                            SizedBox(width: width * 0.01),
                            WeatherButton(
                              label: "Air Quality",
                              value: '${airQualityForecastDescription(aqiData?.aqi)}',
                              icon: "assets/wind.png",
                              iconWidth: 35,
                              heroTag: 'airTag',
                              condtion: _showAirQuality,
                              onPressed: () {
                                setState(() {
                                  _showAirQuality = !_showAirQuality;
                                });
                              },
                            ),
                            SizedBox(width: width * 0.01),
                            WeatherButton(
                              label: "Winds",
                              value: _weather != null ? '${(_weather!.windSpeed * 3.6).round()} km/h' : '--',
                              icon: "assets/wind.png",
                              iconWidth: 35,
                              heroTag: 'windsTag',
                              condtion: _showWinds,
                              onPressed: () {
                                setState(() {
                                  _showWinds = !_showWinds;
                                });
                              },
                            ),
                            SizedBox(width: width * 0.01),
                            WeatherButton(
                              label: "Precipitation",
                              value: _weather?.precipitation == 0.0 ||
                                _weather?.precipitation == null
                                  ? "No rain"
                                  : "${(_weather?.precipitation)?.round()} mm",
                              icon: "assets/water.png",
                              iconWidth: 35,
                              heroTag: 'rainTag',
                              condtion: _showPrecipitation,
                              onPressed: () {
                                setState(() {
                                  _showPrecipitation = !_showPrecipitation;
                                });
                              },
                            ),
                            SizedBox(width: width * 0.01),
                            WeatherButton(
                              label: "Pressure",
                              value: '${_weather?.pressure ?? 0} mb',
                              icon: "assets/pressure.png",
                              iconWidth: 35,
                              heroTag: 'pressureTag',
                              condtion: _showPressure,
                              onPressed: () {
                                setState(() {
                                  _showPressure = !_showPressure;
                                });
                              },
                            ),
                          ],
                        ),
                      )
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              WeatherButton(
                                label: "Clouds",
                                value: '${_weather?.cloudiness ?? 0}%',
                                icon: "assets/clouds.png",
                                iconWidth: 35,
                                heroTag: 'cloudsTag',
                                condtion: _showClouds,
                                onPressed: () {
                                  setState(() {
                                    _showClouds = !_showClouds;
                                  });
                                },
                              ),
                              SizedBox(width: 8),
                              WeatherButton(
                                label: "Temperature",
                                value: '${_weather?.temperature.round() ?? 0}°C',
                                icon: "assets/min.png",
                                iconWidth: 15,
                                heroTag: 'tempTag',
                                condtion: _showTemp,
                                onPressed: () {
                                  setState(() {
                                    _showTemp = !_showTemp;
                                  });
                                },
                              ),
                              SizedBox(width: 8),
                              WeatherButton(
                                label: "Air Quality",
                                value: '${airQualityForecastDescription(aqiData?.aqi)}',
                                icon: "assets/wind.png",
                                iconWidth: 35,
                                heroTag: 'airTag',
                                condtion: _showAirQuality,
                                onPressed: () {
                                  setState(() {
                                    _showAirQuality = !_showAirQuality;
                                  });
                                },
                              ),
                            ],
                          ),
                          SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              WeatherButton(
                                label: "Winds",
                                value: _weather != null ? '${(_weather!.windSpeed * 3.6).round()} km/h' : '--',
                                icon: "assets/wind.png",
                                iconWidth: 35,
                                heroTag: 'windsTag',
                                condtion: _showWinds,
                                onPressed: () {
                                  setState(() {
                                    _showWinds = !_showWinds;
                                  });
                                },
                              ),
                              SizedBox(width: 8),
                              WeatherButton(
                                label: "Precipitation",
                                value: _weather?.precipitation == 0.0 ||
                                  _weather?.precipitation == null
                                    ? "No rain"
                                    : "${(_weather?.precipitation)?.round()} mm",
                                icon: "assets/water.png",
                                iconWidth: 35,
                                heroTag: 'rainTag',
                                condtion: _showPrecipitation,
                                onPressed: () {
                                  setState(() {
                                    _showPrecipitation = !_showPrecipitation;
                                  });
                                },
                              ),
                              SizedBox(width: 8),
                              WeatherButton(
                                label: "Pressure",
                                value: '${_weather?.pressure ?? 0} mb',
                                icon: "assets/pressure.png",
                                iconWidth: 35,
                                heroTag: 'pressureTag',
                                condtion: _showPressure,
                                onPressed: () {
                                  setState(() {
                                    _showPressure = !_showPressure;
                                  });
                                },
                              )
                            ],
                          ),
                        ],
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class WeatherButton extends StatefulWidget {
  final String label;
  final String value;
  final String icon;
  final double iconWidth;
  final String heroTag;
  final bool condtion;
  final VoidCallback onPressed;

  WeatherButton({
    required this.label,
    required this.value,
    required this.icon,
    required this.iconWidth,
    required this.heroTag,
    required this.condtion,
    required this.onPressed,
  });

  @override
  State<WeatherButton> createState() => _WeatherButtonState();
}

class _WeatherButtonState extends State<WeatherButton> {
  @override
  Widget build(BuildContext context) {
    bool isLandscape = ScreenSize.orientation(context);

    return FloatingActionButton.extended(
      elevation: 0,
      extendedIconLabelSpacing: isLandscape ? 10.0
        : widget.heroTag == 'rainTag' ? 0.0 : 5.0,
      extendedPadding: EdgeInsets.symmetric(horizontal: 10),
      heroTag: "${widget.heroTag}",
      label: widget.condtion
        ? Text(
          widget.value,
          style: TextStyle(color: Colors.white),
        )
        : Text(
          widget.label,
          style: TextStyle(color: Colors.black),
        ),
      icon: Image.asset(
        widget.icon,
        fit: BoxFit.contain,
        width: widget.iconWidth,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
        side: const BorderSide(width: 2.5, color: Colors.white)),
      backgroundColor: widget.condtion
        ? Colors.blue.withOpacity(0.5)
        : Colors.white.withOpacity(0.5),
      onPressed: () {
        widget.onPressed();
      },
    );
  }
}
