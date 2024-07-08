class DailyForecast {
  final DateTime date;
  final double temperature;
  final String mainCondition;

  DailyForecast({
    required this.date,
    required this.temperature,
    required this.mainCondition,
  });

  factory DailyForecast.fromJson(Map<String, dynamic> json) {
    return DailyForecast(
      date: DateTime.fromMillisecondsSinceEpoch(json['dt'] * 1000),
      temperature: json['temp']['day'].toDouble(),
      mainCondition: json['weather'][0]['main'],
    );
  }
}
