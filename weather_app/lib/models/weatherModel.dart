class Weather {
  final String cityName;
  final double temperature;
  final int humidity;
  final int pressure;
  final double windSpeed;
  final double gustSpeed;
  final int windDirection;
  final double feelsLike;
  final double minTemp;
  final double maxTemp;
  final int visibility;
  final int cloudiness;
  final int sunrise;
  final int sunset;
  final String mainCondition;

  Weather({
    required this.cityName,
    required this.temperature,
    required this.humidity,
    required this.pressure,
    required this.windSpeed,
    required this.gustSpeed,
    required this.windDirection,
    required this.mainCondition,
    required this.feelsLike,
    required this.minTemp,
    required this.maxTemp,
    required this.visibility,
    required this.cloudiness,
    required this.sunrise,
    required this.sunset,
  });

  factory Weather.fromJson(Map<String, dynamic> json) {
    return Weather(
      cityName: json['name'] ?? "Colombo",
      temperature: (json['main']['temp'] ?? 0.0).toDouble(),
      humidity: json['main']['humidity']?.toInt() ?? 0,
      pressure: json['main']['pressure'].toInt(),
      windSpeed: (json['wind']['speed'] ?? 0.0).toDouble(),
      gustSpeed: (json['wind']['gust'] ?? 0.0).toDouble(),
      windDirection: json['wind']['deg']?.toInt(),
      mainCondition: json['weather'][0]['main'],
      feelsLike: (json['main']['feels_like'] ?? 0.0).toDouble(),
      minTemp: (json['main']['temp_min'] ?? 0.0).toDouble(),
      maxTemp: (json['main']['temp_max'] ?? 0.0).toDouble(),
      visibility: json['visibility'],
      cloudiness: json['clouds']['all'],
      sunrise: json['sys']['sunrise']?.toInt(),
      sunset: json['sys']['sunset']?.toInt(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'cityName': cityName,
      'temperature': temperature,
      'mainCondition': mainCondition,
    };
  }
}
