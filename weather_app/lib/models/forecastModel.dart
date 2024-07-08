class Forecast {
  final DateTime dateTime;
  final double temperature;
  final int humidity;
  final int pressure;
  final double windSpeed;
  final String mainCondition;

  Forecast({
    required this.dateTime,
    required this.temperature,
    required this.humidity,
    required this.pressure,
    required this.windSpeed,
    required this.mainCondition,
  });

  factory Forecast.fromJson(Map<String, dynamic> json) {
    return Forecast(
      dateTime: DateTime.parse(json['dt_txt']),
      temperature: json['main']['temp'].toDouble(),
      humidity: json['main']['humidity']?.toInt() ?? 0,
      pressure: json['main']['pressure'].toInt(),
      windSpeed: json['wind']['speed'].toDouble(),
      mainCondition: json['weather'][0]['main'],
    );
  }
}
