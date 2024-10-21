import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:weather_app/models/airQualityModel.dart';
import 'package:weather_app/models/dailyAirQualityModel.dart';
import 'package:weather_app/providers/weatherService.dart';

class AirQualityIndex extends StatefulWidget {
  const AirQualityIndex({super.key});

  @override
  State<AirQualityIndex> createState() => _AirQualityIndexState();
}

class _AirQualityIndexState extends State<AirQualityIndex> {
  final _WeatherService = WeatherService('c3281946b6139602ecabb86fd3e733c2');
  AirQuality? aqiData;
  List<AirQualityForecast>? forecasts;
  late Future<List<AirQualityForecast>> airQualityData;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchAirQualityData('Kandy');
  }

  Future<void> fetchAirQualityData(String cityName) async {
    setState(() {
      isLoading = true;
    });
    try {
      List<Location> locations = await locationFromAddress(cityName);
      double lat = locations[0].latitude;
      double lon = locations[0].longitude;

      final results = await Future.wait([
        _WeatherService.fetchAirQuality(lat, lon),
        _WeatherService.fetchAirQualityForecast(lat, lon),
      ]);
      setState(() {
        aqiData = results[0] as AirQuality;
        forecasts = results[1] as List<AirQualityForecast>;
        isLoading = false;
      });
    } catch (e, stackTrace) {
      print("Error fetching air quality data: $e");
      print("Stacktrace: $stackTrace");

      setState(() {
        isLoading = false;
      });
    }
  }

  String airQualityDescription(int? aqi) {
    if (aqi == null)
      return "Air Quality cannot be measureed. No internet connection";

    switch (aqi) {
      case 1:
        return "Air Quality is Good. " "A Perfect day for a walk";
      case 2:
        return "Air Quality is Fair. Should wear a mask in outdoor";
      case 3:
        return "Air Quality is Moderate. Should stay at home";
      case 4:
        return "Air Quality is Poor. Not good for your health";
      case 5:
        return "Air Quality is Very Poor. Might cause severe health issues";
      default:
        return "Air Quality data is unavailable.";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: const Center(
          child: Text("Air Quality"),
        ),
        actions: [IconButton(onPressed: () {}, icon: const Icon(Icons.air))],
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
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
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: 1,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 0, vertical: 0),
                        child: Container(
                          height: 500,
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
                                // spreadRadius: 3,
                                blurRadius: 7,
                                offset: const Offset(0, 6),
                              ),
                            ],
                            // color: Colors.white.withOpacity(0.50),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 20),
                            child: Column(
                              children: [
                                Container(
                                  width: 290,
                                  decoration: ShapeDecoration(
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(15),
                                        side: const BorderSide(
                                            width: 2.5, color: Colors.white)),
                                    color: Colors.white.withOpacity(0.50),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 30, vertical: 5),
                                    child: Center(
                                      child: Row(
                                        children: [
                                          const Spacer(),
                                          const Text(
                                            "Air Quality Index",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                fontSize: 16,
                                                color: Colors.black),
                                          ),
                                          const Spacer(),
                                          Image.asset(
                                            'assets/wind.png',
                                            fit: BoxFit.cover,
                                            width: 60,
                                          ),
                                          const Spacer(),
                                          Text(
                                            aqiData != null
                                                ? aqiData!.aqi.toString()
                                                : 'Loading...',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                fontSize: 16,
                                                color: Colors.black),
                                          ),
                                          const Spacer(),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 15),
                                Container(
                                  width: 360,
                                  decoration: ShapeDecoration(
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(15),
                                        side: const BorderSide(
                                            width: 2.5, color: Colors.white)),
                                    color: Colors.white.withOpacity(0.50),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 0, vertical: 12),
                                    child: Center(
                                      child: Row(
                                        children: [
                                          const Spacer(),
                                          Container(
                                            // width: 280,
                                            child: Text(
                                              airQualityDescription(
                                                  aqiData?.aqi),
                                              // textAlign: TextAlign.justify,
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  color: Colors.black),
                                            ),
                                          ),
                                          const Spacer(),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 25),
                                isLoading
                                    ? Center(child: CircularProgressIndicator())
                                    : SfCircularChart(
                                        title: ChartTitle(
                                            text: 'Air Quality Components (µg/m³)'),
                                        legend: Legend(
                                            isVisible: true,
                                            isResponsive: true,
                                            position: LegendPosition.bottom,
                                            iconHeight: 25,
                                            textStyle: TextStyle(fontSize: 15),
                                            overflowMode:
                                                LegendItemOverflowMode.wrap),
                                        series: <CircularSeries>[
                                          aqiData != null
                                              ? DoughnutSeries<ChartData,
                                                  String>(
                                                  radius: '80%',
                                                  explode: true,
                                                  dataSource: [
                                                    ChartData(
                                                        'CO', aqiData!.co),
                                                    ChartData(
                                                        'NO', aqiData!.no),
                                                    ChartData(
                                                        'NO2', aqiData!.no2),
                                                    ChartData(
                                                        'O3', aqiData!.o3),
                                                    ChartData(
                                                        'SO2', aqiData!.so2),
                                                    ChartData('PM2.5',
                                                        aqiData!.pm2_5),
                                                    ChartData(
                                                        'PM10', aqiData!.pm10),
                                                    ChartData(
                                                        'NH3', aqiData!.nh3),
                                                  ],
                                                  xValueMapper:
                                                      (ChartData data, _) =>
                                                          data.name,
                                                  yValueMapper:
                                                      (ChartData data, _) =>
                                                          data.value,
                                                  dataLabelSettings:
                                                      DataLabelSettings(
                                                          isVisible: true),
                                                )
                                              : DoughnutSeries<ChartData,
                                                  String>(
                                                  radius: '80%',
                                                  explode: true,
                                                  dataSource: [
                                                    ChartData('CO', 2),
                                                    ChartData('NO', 2),
                                                    ChartData('NO2', 2),
                                                    ChartData('O3', 2),
                                                    ChartData('SO2', 2),
                                                    ChartData('PM2.5', 2),
                                                    ChartData('PM10', 2),
                                                    ChartData('NH3', 2),
                                                  ],
                                                  xValueMapper:
                                                      (ChartData data, _) =>
                                                          data.name,
                                                  yValueMapper:
                                                      (ChartData data, _) =>
                                                          data.value,
                                                  dataLabelSettings:
                                                      DataLabelSettings(
                                                          isVisible: true),
                                                )
                                        ],
                                        margin: const EdgeInsets.all(10),
                                      )
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 30),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          const Text(
                            "5 Day Air Quality Forecast",
                            textAlign: TextAlign.start,
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ]),
                  ),
                  const SizedBox(height: 15),
                  isLoading
                      ? Center(child: CircularProgressIndicator())
                      : Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 0, vertical: 10),
                          height: 130,
                          child: ListView.builder(
                            padding: EdgeInsets.symmetric(horizontal: 12),
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            itemCount: forecasts?.length ?? 0,
                            itemBuilder: (context, index) {
                              final forecast = forecasts![index];
                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 5),
                                child: Container(
                                  width: 77,
                                  height: 260,
                                  decoration: ShapeDecoration(
                                    color: Colors.white.withOpacity(0.5),
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20),
                                        side: const BorderSide(
                                            width: 2.5, color: Colors.white)),
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: <Widget>[
                                      const SizedBox(height: 5),
                                      Text(
                                        DateFormat('EEE').format(forecast.date),
                                        style: const TextStyle(
                                            fontSize: 17, color: Colors.black),
                                      ),
                                      const SizedBox(height: 5),
                                      Image.asset(
                                        'assets/wind.png',
                                        fit: BoxFit.cover,
                                        width: 37,
                                      ),
                                      const SizedBox(height: 5),
                                      Text(
                                        'AQI: ${forecast.aqi}',
                                        style: const TextStyle(
                                            fontSize: 16, color: Colors.blue, fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
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

class ChartData {
  ChartData(this.name, this.value);
  final String name;
  final double value;
}
