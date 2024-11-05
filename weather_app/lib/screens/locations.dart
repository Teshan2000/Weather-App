import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weather_app/providers/weatherService.dart';
import 'package:weather_app/models/weatherModel.dart';
import 'dart:convert';

import 'package:weather_app/screens/cityWeather.dart';

class Locations extends StatefulWidget {
  const Locations({super.key});

  @override
  _LocationsState createState() => _LocationsState();
}

class _LocationsState extends State<Locations> {
  final TextEditingController _cityController = TextEditingController();
  final _WeatherService = WeatherService('c3281946b6139602ecabb86fd3e733c2');
  // Weather? _weather;
  List<String> _suggestions = [];
  List<Weather> _addedCitiesWeather = [];

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
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   _loadSavedCities();
    // });
  }

  void _loadSavedCities() async {
    final prefs = await SharedPreferences.getInstance();
    final savedCities = prefs.getStringList('savedCities') ?? [];
    final List<Weather> savedWeatherData = savedCities.map((city) {
      final Map<String, dynamic> weatherMap = json.decode(city);
      return Weather.fromJson(weatherMap);
    }).toList();

    setState(() {
      _addedCitiesWeather = savedWeatherData;
    });
  }

  void _saveCities() async {
    final prefs = await SharedPreferences.getInstance();
    final savedCities = _addedCitiesWeather
        .map((weather) => json.encode(weather.toJson()))
        .toList();
    await prefs.setStringList('savedCities', savedCities);
  }

  void _onCityChanged(String query) async {
    if (query.isEmpty) {
      setState(() {
        _suggestions = [];
      });
      return;
    }

    List<String> suggestions = [
      'Colombo',
      'Kandy',
      'New York',
      'Africa',
      'Sydney',
      'Egypt',
      'London',
      'Brazil',
      'Tokyo',
      'France',
    ];

    setState(() {
      _suggestions = suggestions
          .where((city) => city.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  void _onCitySelected(String cityName) async {
    try {
      final weather = await _WeatherService.getWeather(cityName);
      setState(() {
        _addedCitiesWeather.add(weather);
        _cityController.clear();
        _suggestions = [];
      });
      _saveCities();
    } catch (e) {
      print(e);
    }
  }

  void _removeCity(int index) {
    setState(() {
      _addedCitiesWeather.removeAt(index);
    });
    _saveCities();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,        
        title: const Center(
          child: Text("Add more cities"),
        ),
        actions: [
          IconButton(
              onPressed: () {},
              icon: const Icon(Icons.add_location_alt_outlined))
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
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    width: double.infinity,
                    decoration: ShapeDecoration(
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(20),
                            bottomRight: Radius.circular(20)),
                      ),
                      image: DecorationImage(
                        image: AssetImage('assets/background.png'),
                        fit: BoxFit.cover,
                      ),
                      shadows: [
                        BoxShadow(
                          color: Colors.blue.withOpacity(0.5),
                          // spreadRadius: 3,
                          blurRadius: 7,
                          offset: Offset(0, 6),
                        ),
                      ],
                      // color: Colors.white.withOpacity(0.50),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: 20, right: 20, top: 25, bottom: 30),
                      child: TextFormField(
                        controller: _cityController,
                        decoration: InputDecoration(
                          hintText: 'Enter city name',
                          alignLabelWithHint: true,
                          fillColor: Colors.white.withOpacity(0.5),
                          filled: true,
                          suffixIcon: IconButton(
                            icon: const Icon(Icons.search),
                            onPressed: () {
                              _onCitySelected(_cityController.text);
                            },
                          ),
                          suffixIconColor: Colors.blue,
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(
                              color: Colors.white,
                              width: 2.5,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(
                              color: Colors.white,
                              width: 2.5,
                            ),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(
                              color: Colors.red,
                              width: 2.5,
                            ),
                          ),
                        ),
                        onChanged: _onCityChanged,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: _suggestions.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(_suggestions[index]),
                        onTap: () {
                          _onCitySelected(_suggestions[index]);
                        },
                      );
                    },
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  if (_addedCitiesWeather.isNotEmpty)
                    ListView.builder(
                      shrinkWrap: true,
                      itemCount: _addedCitiesWeather.length,
                      itemBuilder: (context, index) {
                        final weather = _addedCitiesWeather[index];
                        return GestureDetector(
                          child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 15, vertical: 10),
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
                                      horizontal: 15, vertical: 15),
                                  child: Center(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          weather.cityName,
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(
                                              fontSize: 20,
                                              color: Colors.black),
                                        ),
                                        SizedBox(
                                          width: 20,
                                        ),
                                        Text(
                                          "${weather.temperature.round()}°C",
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(
                                            fontSize: 22,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.blue,
                                          ),
                                        ),
                                        SizedBox(
                                          width: 20,
                                        ),
                                        Image.asset(
                                            getWeatherAnimation(
                                                weather.mainCondition),
                                            width: 30),
                                        SizedBox(
                                          width: 20,
                                        ),
                                        Text(
                                          weather.mainCondition,
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(
                                              fontSize: 17, color: Colors.blue),
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        IconButton(
                                          icon: const Icon(Icons.cancel),
                                          color: Colors.red,
                                          onPressed: () {
                                            _removeCity(index);
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              )),
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => CityWeather(
                                          cityName: weather.cityName,
                                        )));
                          },
                        );
                      },
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
