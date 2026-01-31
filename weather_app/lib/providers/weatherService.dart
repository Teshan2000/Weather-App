import 'dart:convert';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:weather_app/models/airQualityModel.dart';
import 'package:weather_app/models/dailyAirQualityModel.dart';
import 'package:weather_app/models/forecastModel.dart';
import 'package:http/http.dart' as http;
import 'package:weather_app/models/weatherModel.dart';

class WeatherService {
  static const Base_URL = "http://api.openweathermap.org/data/2.5";
  final String apiKey = "252bb571d411f6016045c128fcd11393";

  // WeatherService(this.apiKey);

  Future<Weather> getWeather(String cityName) async {
    final response = await http.get(
        Uri.parse('$Base_URL/weather?q=$cityName&appid=$apiKey&units=metric'));

    if (response.statusCode == 200) {
      return Weather.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to fetch weather data');
    }
  }

  Future<Weather> getWeatherByCoords(double lat, double lon) async {
    final response = await http.get(
        Uri.parse('$Base_URL/weather?lat=$lat&lon=$lon&appid=$apiKey&units=metric'));

    if (response.statusCode == 200) {
      return Weather.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to fetch weather data by coordinates');
    }
  }

  Future<Position> getPreciseLocation() async {
    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.medium,
    ).timeout(const Duration(seconds: 10), onTimeout: () {
      return Geolocator.getLastKnownPosition().then((pos) => pos!);
    });
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

  Future<Map<String, dynamic>> getCurrentCityWithPosition() async {
    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    List<Placemark> placemarks =
        await placemarkFromCoordinates(position.latitude, position.longitude);

    String? city = placemarks[0].locality;
    return {
      'city': city ?? '',
      'latitude': position.latitude,
      'longitude': position.longitude,
    };
  }

  Future<List<Forecast>> getFiveDayForecast(String cityName) async {
    final response = await http.get(
        Uri.parse('$Base_URL/forecast?q=$cityName&appid=$apiKey&units=metric'));

    if (response.statusCode == 200) {
      List<dynamic> forecasts = jsonDecode(response.body)['list'];
      List<Forecast> dailyForecasts = [];
      DateTime? lastDate;

      for (var forecast in forecasts) {
        DateTime dateTime = DateTime.parse(forecast['dt_txt']);
        if (lastDate == null || dateTime.day != lastDate.day) {
          dailyForecasts.add(Forecast.fromJson(forecast));
          lastDate = dateTime;
        }
      }

      return dailyForecasts;
    } else {
      throw Exception('Failed to fetch 5-day forecast');
    }
  }

  Future<List<Forecast>> getFiveDayForecastByCoords(double lat, double lon) async {
    final response = await http.get(
        Uri.parse('$Base_URL/forecast?lat=$lat&lon=$lon&appid=$apiKey&units=metric'));

    if (response.statusCode == 200) {
      List<dynamic> forecasts = jsonDecode(response.body)['list'];
      List<Forecast> dailyForecasts = [];
      DateTime? lastDate;

      for (var forecast in forecasts) {
        DateTime dateTime = DateTime.parse(forecast['dt_txt']);
        if (lastDate == null || dateTime.day != lastDate.day) {
          dailyForecasts.add(Forecast.fromJson(forecast));
          lastDate = dateTime;
        }
      }
      return dailyForecasts;
    } else {
      throw Exception('Failed to fetch forecast by coordinates');
    }
  }

  Future<AirQuality> fetchAirQuality(double lat, double lon) async {
    final response = await http.get(
        Uri.parse('$Base_URL/air_pollution?lat=$lat&lon=$lon&appid=$apiKey'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      print('Air quality response: $data');
      final airQualityData = data['list'][0];
      return AirQuality.fromJson(airQualityData);
    } else {
      throw Exception('Failed to fetch Air Quality Data');
    }
  }

  Future<List<AirQualityForecast>> fetchAirQualityForecast(
      double lat, double lon) async {
    final response = await http.get(Uri.parse(
        '$Base_URL/air_pollution/forecast?lat=$lat&lon=$lon&appid=$apiKey'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final List forecasts = data['list'];
      Map<String, AirQualityForecast> groupedForecasts = {};

      for (var forecast in forecasts) {
        String date = DateFormat('yyyy-MM-dd')
            .format(DateTime.fromMillisecondsSinceEpoch(forecast['dt'] * 1000));

        if (!groupedForecasts.containsKey(date)) {
          groupedForecasts[date] = AirQualityForecast.fromJson(forecast);
        }
      }
      return groupedForecasts.values.toList();
    } else {
      throw Exception('Failed to fetch Air Quality Forecast');
    }
  }

  Future<AirQuality> fetchAirQualityByCityName(String cityName) async {
    List<Location> locations = await locationFromAddress(cityName);
    double lat = locations[0].latitude;
    double lon = locations[0].longitude;
    return await fetchAirQuality(lat, lon);
  }

  Future<List<AirQualityForecast>> fetchAirQualityForecastByCityName(
      String cityName) async {
    List<Location> locations = await locationFromAddress(cityName);
    double lat = locations[0].latitude;
    double lon = locations[0].longitude;
    return await fetchAirQualityForecast(lat, lon);
  }
}
