import 'package:flutter/material.dart';
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
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchAirQualityData();
  }

  void fetchAirQualityData() async {
    try {
      AirQuality airQuality =
          await _WeatherService.fetchAirQualityByCityName('Kandy');
      List<AirQualityForecast> airQualityForecasts = await _WeatherService.fetchAirQualityForecastByCityName('Kandy');
      print('AQI: ${airQuality.aqi}');
      setState(() {
        aqiData = airQuality;
        forecasts = airQualityForecasts;
        isLoading = false;
      });
    } catch (e) {
      print("Error fetching air quality data: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white.withOpacity(0.50),
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
                          height: 460,
                          width: double.infinity,
                          decoration: ShapeDecoration(
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(20),
                                  bottomRight: Radius.circular(20)),
                            ),
                            shadows: [
                              BoxShadow(
                                color: Colors.blue.withOpacity(0.5),
                                spreadRadius: 3,
                                blurRadius: 7,
                                offset: const Offset(0, 3),
                              ),
                            ],
                            color: Colors.white.withOpacity(0.50),
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
                                        horizontal: 30, vertical: 12),
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
                                            width: 30,
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
                                const SizedBox(height: 27),
                                isLoading
                                    ? Center(child: CircularProgressIndicator())
                                    : SfCircularChart(
                                        title: ChartTitle(
                                            text: 'Air Quality Components'),
                                        legend: Legend(
                                            isVisible: true,
                                            isResponsive: true,
                                            position: LegendPosition.bottom,
                                            iconHeight: 25,
                                            textStyle: TextStyle(fontSize: 15),
                                            overflowMode:
                                                LegendItemOverflowMode.wrap),
                                        series: <CircularSeries>[
                                          aqiData != null ?
                                          DoughnutSeries<ChartData, String>(
                                            radius: '80%',
                                            explode: true,
                                            dataSource: [
                                              ChartData('CO', aqiData!.co),
                                              ChartData('NO', aqiData!.no),
                                              ChartData('NO2', aqiData!.no2),
                                              ChartData('O3', aqiData!.o3),
                                              ChartData('SO2', aqiData!.so2),
                                              ChartData(
                                                  'PM2.5', aqiData!.pm2_5),
                                              ChartData('PM10', aqiData!.pm10),
                                              ChartData('NH3', aqiData!.nh3),
                                            ],
                                            xValueMapper: (ChartData data, _) =>
                                                data.name,
                                            yValueMapper: (ChartData data, _) =>
                                                data.value,
                                            dataLabelSettings:
                                                DataLabelSettings(
                                                    isVisible: true),
                                          ) 
                                          : DoughnutSeries<ChartData, String>(
                                            radius: '80%',
                                            explode: true,
                                            dataSource: [
                                              ChartData('CO', 2),
                                              ChartData('NO', 2),
                                              ChartData('NO2', 2),
                                              ChartData('O3', 2),
                                              ChartData('SO2', 2),
                                              ChartData(
                                                  'PM2.5', 2),
                                              ChartData('PM10', 2),
                                              ChartData('NH3', 2),
                                            ],
                                            xValueMapper: (ChartData data, _) =>
                                                data.name,
                                            yValueMapper: (ChartData data, _) =>
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
                  const SizedBox(height: 20),
                  isLoading
                      ? Center(child: CircularProgressIndicator())
                      : ListView.builder(
                          shrinkWrap: true,
                          itemCount: forecasts?.length ?? 0,
                          itemBuilder: (context, index) {
                            final forecast = forecasts![index];
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 0, vertical: 0),
                              child: Container(
                                height: 260,
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
                                      offset: Offset(0, 6),
                                    ),
                                  ],
                                  // color: Colors.white.withOpacity(0.50),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 20),
                                  child: Column(
                                    children: [
                                      Expanded(
                                        child: Row(
                                          children: [
                                            const Spacer(),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                const Spacer(),
                                                Text(
                                                  "${forecast.date}",
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      fontSize: 16,
                                                      color: Colors.black),
                                                ),
                                                const Spacer(),
                                                Text(
                                                  "${forecast.aqi}",
                                                  textAlign: TextAlign.center,
                                                  style: const TextStyle(
                                                    fontSize: 30,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.blue,
                                                  ),
                                                ),
                                                const Spacer(),
                                                Text(
                                                  "${forecast.date}",
                                                  textAlign: TextAlign.center,
                                                  style: const TextStyle(
                                                      fontSize: 16,
                                                      color: Colors.blue),
                                                ),
                                                const Spacer(),
                                                const Spacer(),
                                              ],
                                            ),
                                            const Spacer(),
                                          ],
                                        ),
                                      ),                                      
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        )                      
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
