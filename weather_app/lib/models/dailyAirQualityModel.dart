class AirQualityForecast {
  final DateTime date;
  final int aqi;
  final double co;
  final double no;
  final double no2;
  final double o3;
  final double so2;
  final double pm2_5;
  final double pm10;
  final double nh3;

  AirQualityForecast({
    required this.date,
    required this.aqi,
    required this.co,
    required this.no,
    required this.no2,
    required this.o3,
    required this.so2,
    required this.pm2_5,
    required this.pm10,
    required this.nh3,
  });

  factory AirQualityForecast.fromJson(Map<String, dynamic> json) {
    return AirQualityForecast(
      date: DateTime.fromMillisecondsSinceEpoch(json['dt'] * 1000),
      aqi: json['main']['aqi'].toInt(), 
      co: json['components']['co'].toDouble(), 
      no: json['components']['no'].toDouble(), 
      no2: json['components']['no2'].toDouble(), 
      o3: json['components']['o3'].toDouble(), 
      so2: json['components']['so2'].toDouble(), 
      pm2_5: json['components']['pm2_5'].toDouble(), 
      pm10: json['components']['pm10'].toDouble(), 
      nh3: json['components']['nh3'].toDouble(),
    );
  }
}
