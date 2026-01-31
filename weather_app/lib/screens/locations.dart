import 'package:flutter/material.dart';
import 'package:weather_app/main.dart';
import 'package:weather_app/providers/weatherService.dart';
import 'package:weather_app/models/weatherModel.dart';
import 'package:weather_app/screens/cityWeather.dart';

class Locations extends StatefulWidget {
  const Locations({super.key});

  @override
  _LocationsState createState() => _LocationsState();
}

class _LocationsState extends State<Locations> {
  final TextEditingController _cityController = TextEditingController();
  final _WeatherService = WeatherService();
  List<String> _suggestions = [];
  List<Weather> _addedCitiesWeather = [];

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

  void _onCityChanged(String query) async {
    if (query.isEmpty) {
      setState(() {
        _suggestions = [];
      });
      return;
    }

    List<String> suggestions = [
      'Colombo', 'Jaffna', 'Galle', 'Kandy',
      'Gampaha', 'Kalutara', 'Matara', 'Badulla',
      'Ratnapura', 'Kegalle', 'Nuwara Eliya', 'Polonnaruwa',
      'Trincomalee', 'Batticaloa', 'Mannar', 'Puttalam',
      'Kurunegala', 'Vavuniya', 'Kilinochchi', 'Matale',
      'Hambantota', 'Ampara', 'Monaragala', 'Anuradhapura',
      'Cape Town', 'New York', 'Chicago', 'Los Angeles',
      'Dubai', 'Hong Kong', 'Shanghai', 'Melbourne',
      'Sydney', 'Moscow', 'Kuala Lumpur', 'Singapore',
      'Rio de Janeiro', 'Istanbul', 'Bangkok', 'Madrid',
      'Cairo', 'Chennai', 'Delhi', 'Mumbai',
      'London', 'Berlin', 'Paris', 'Rome',      
      'Tokyo', 'Seoul', 'Beijing', 'Jakarta',
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
    } catch (e) {
      print(e);
    }
  }

  void _removeCity(int index) {
    setState(() {
      _addedCitiesWeather.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    double width = ScreenSize.width(context);
    double height = ScreenSize.height(context);
    bool isLandscape = ScreenSize.orientation(context);
    
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/background.png'),
              fit: BoxFit.cover,
            ),
          ),
        ),
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
        width: width,
        height: height,
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
                          blurRadius: 7,
                          offset: Offset(0, 6),
                        ),
                      ],
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
                  SizedBox(height: isLandscape ? height * 0.05 : 10),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
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
                  SizedBox(height: isLandscape ? height * 0.05 : 8),
                  if (_addedCitiesWeather.isNotEmpty)
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
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
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        isLandscape ? Text(
                                          weather.cityName,
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(
                                            fontSize: 20,
                                            color: Colors.black),
                                        ) : Expanded(
                                          child: Text(
                                            weather.cityName,
                                            textAlign: TextAlign.center,
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 1,
                                            style: const TextStyle(
                                              fontSize: 20,
                                              color: Colors.black),
                                          ),
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
                                            weather.mainCondition,
                                            sunrise: weather.sunrise,
                                            sunset: weather.sunset,),
                                          width: 30),
                                        SizedBox(
                                          width: 20,
                                        ),
                                        Text(
                                          weather.mainCondition,
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(
                                            fontSize: 17, 
                                            color: Colors.blue),
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
                              context, MaterialPageRoute(
                                builder: (context) => CityWeather(
                                  weather: weather,
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
