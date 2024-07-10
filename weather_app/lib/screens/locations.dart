import 'package:flutter/material.dart';
import 'package:weather_app/providers/weatherService.dart'; 
import 'package:weather_app/models/weatherModel.dart'; 

class Locations extends StatefulWidget {
  const Locations({super.key});

  @override
  _LocationsState createState() => _LocationsState();
}

class _LocationsState extends State<Locations> {
  final TextEditingController _cityController = TextEditingController();
  final WeatherService _weatherService = WeatherService('your_api_key');
  List<String> _suggestions = [];
  Weather? _selectedCityWeather;

  void _onCityChanged(String query) async {
    if (query.isEmpty) {
      setState(() {
        _suggestions = [];
      });
      return;
    }

    List<String> suggestions = ['New York', 'Los Angeles', 'Chicago', 'Houston', 'Phoenix']; 

    setState(() {
      _suggestions = suggestions.where((city) => city.toLowerCase().contains(query.toLowerCase())).toList();
    });
  }

  void _onCitySelected(String cityName) async {
    try {
      final weather = await _weatherService.getWeather(cityName);
      setState(() {
        _selectedCityWeather = weather;
        _cityController.clear();
        _suggestions = [];
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(25),
          child: SafeArea(
            child: Column(
              children: [
                const Center(
                  child: Text(
                    'Add more cities',
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                  controller: _cityController,
                  decoration: InputDecoration(
                    hintText: 'Enter city name',
                    labelText: 'Enter city name',
                    alignLabelWithHint: true,
                    suffixIcon: const Icon(Icons.search),
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
                      onTap: () => _onCitySelected(_suggestions[index]),
                    );
                  },
                ),
                const SizedBox(
                  height: 30,
                ),
                if (_selectedCityWeather != null)
                  Card(
                    elevation: 2,
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                      child: Center(
                        child: Row(
                          children: [
                            Text(
                              _selectedCityWeather!.cityName,
                              textAlign: TextAlign.center,
                              style: const TextStyle(fontSize: 20, color: Colors.blue),
                            ),
                            const Spacer(),
                            const Icon(
                              Icons.sunny,
                              color: Colors.amber,
                            ),
                            const SizedBox(
                              width: 15,
                            ),
                            Text(
                              '${_selectedCityWeather!.temperature.toStringAsFixed(1)}°C',
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Colors.blue,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
