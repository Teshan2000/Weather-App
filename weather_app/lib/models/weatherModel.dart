class Weather {
  final String cityName;
  final double temperature;
  final int humidity;
  final int pressure;
  final double windSpeed;
  final String mainCondition;

  Weather(
      {required this.cityName,
      required this.temperature,
      required this.humidity,
      required this.pressure,
      required this.windSpeed,
      required this.mainCondition});

  factory Weather.fromJson(Map<String, dynamic> json) {
    return Weather(
        cityName: json['name'],
        temperature: json['main']['temp'].toDouble(),
        humidity: json['main']['humidity']?.toInt() ?? 0,
        pressure: json['main']['temp'].toInt(),
        windSpeed: json['wind']['speed'].toDouble(),
        mainCondition: json['weather'][0]['main']);
  }
}
