import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weather_app/providers/weatherService.dart';
import 'package:weather_app/models/weatherModel.dart';
import 'dart:convert';

class Locations extends StatefulWidget {
  const Locations({super.key});

  @override
  _LocationsState createState() => _LocationsState();
}

class _LocationsState extends State<Locations> {
  final TextEditingController _cityController = TextEditingController();
  final _WeatherService = WeatherService('c3281946b6139602ecabb86fd3e733c2');
  Weather? _weather;
  List<String> _suggestions = [];
  List<Weather> _addedCitiesWeather = [];

  String getWeatherAnimation(String? mainCondition) {
    if (mainCondition == null) return 'assets/clear.png';

    switch (mainCondition.toLowerCase()) {
      case 'clouds':
        return 'assets/clear.png';
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
      'Jaffna',
      'Sydney',
      'England',
      'Tokoyo'
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
            padding: const EdgeInsets.all(15),
            child: SafeArea(
              child: Column(
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    controller: _cityController,
                    decoration: InputDecoration(
                      hintText: 'Enter city name',
                      labelText: 'Enter city name',
                      alignLabelWithHint: true,
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.search),
                        onPressed: () {
                          _onCitySelected(_cityController.text);
                        },
                      ),
                      suffixIconColor: Colors.deepPurple,
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(
                          color: Colors.deepPurple,
                        ),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(
                          color: Colors.red,
                        ),
                      ),
                    ),
                    onChanged: _onCityChanged,
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
                        return Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 10),
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
                                    children: [
                                      Text(
                                        weather.cityName,
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                            fontSize: 20, color: Colors.blue),
                                      ),
                                      const Spacer(),
                                      Image.asset(
                                        getWeatherAnimation(
                                          weather.mainCondition),
                                          width: 30),
                                      const Spacer(),
                                      Text(
                                        '${weather.temperature.toStringAsFixed(1)}°C',
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                          fontSize: 22,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.blue,
                                        ),
                                      ),
                                      const Spacer(),
                                      IconButton(
                                        icon: const Icon(Icons.cancel),
                                        onPressed: () {
                                          _removeCity(index);
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ));
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
