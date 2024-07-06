import 'dart:convert';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:weather_app/models/dailyWeatherModel.dart';
import 'package:weather_app/models/weatherModel.dart';
import 'package:http/http.dart' as http;

class WeatherService {
  static const Base_URL = "http://api.openweathermap.org/data/2.5/weather";
  final String apiKey;

  WeatherService(this.apiKey);

  Future<Weather> getWeather(String cityName) async {
    final response = await http
        .get(Uri.parse('$Base_URL?q=$cityName&appid=$apiKey&units=metric'));

    if (response.statusCode == 200) {
      return Weather.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to weather data');
    }
  }

  Future<String> getCurrentCity() async {
    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    List<Placemark> placemarks =
        await placemarkFromCoordinates(position.latitude, position.longitude);

    String? city = placemarks[0].locality;

    return city ?? '';
  }

  Future<List<DailyForecast>> getSevenDayForecast(String cityName) async {
  final response = await http.get(
    Uri.parse('$Base_URL/forecast/daily?q=$cityName&cnt=7&appid=$apiKey&units=metric'),
  );

  if (response.statusCode == 200) {
    List<dynamic> dailyForecasts = jsonDecode(response.body)['list'];
    return dailyForecasts.map((json) => DailyForecast.fromJson(json)).toList();
  } else {
    throw Exception('Failed to fetch 7-day forecast');
  }
}
}
