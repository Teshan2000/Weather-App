class AirQuality {
  final int aqi;
  final double co;
  final double no;
  final double no2;
  final double o3;
  final double so2;
  final double pm2_5;
  final double pm10;
  final double nh3;

  AirQuality({
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

  factory AirQuality.fromJson(Map<String, dynamic> json) {
    final components = json['components'];
    return AirQuality(
      aqi: json['main']['aqi'], 
      co: components['co'], 
      no: components['no'], 
      no2: components['no2'], 
      o3: components['o3'], 
      so2: components['so2'], 
      pm2_5: components['pm2_5'], 
      pm10: components['pm10'], 
      nh3: components['nh3'],
    );
  }
}
