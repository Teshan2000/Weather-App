import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:weather_app/main.dart';
import 'package:weather_app/models/airQualityModel.dart';
import 'package:weather_app/models/dailyAirQualityModel.dart';
import 'package:weather_app/screens/splash.dart';

class AirQualityIndex extends StatefulWidget {
  final AirQuality? aqiData;
  final List<AirQualityForecast>? forecasts;
  const AirQualityIndex({super.key, this.aqiData, required this.forecasts});

  @override
  State<AirQualityIndex> createState() => _AirQualityIndexState();
}

class _AirQualityIndexState extends State<AirQualityIndex> {
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    isLoading = (widget.forecasts == null || widget.forecasts!.isEmpty);
  }

  Map<String, String> airQualityDescription(int? aqi) {
    if (aqi == null)
      return {
        "image": "assets/rainbow.png",
        "value": "No data",
        "description": "No internet connection",
      };

    switch (aqi) {
      case 1:
        return {
          "image": "assets/rainbow.png",
          "value": "Good",
          "description": "A Perfect day for a walk",
        };
      case 2:
        return {
          "image": "assets/rainbow.png",
          "value": "Fair",
          "description": "Great for outdoor activities",
        };
      case 3:
        return {
          "image": "assets/mist.png",
          "value": "Moderate",
          "description": "Should wear a mask in outdoor",
        };
      case 4:
        return {
          "image": "assets/mist.png",
          "value": "Poor",
          "description": "Should stay at home",
        };
      case 5:
        return {
          "image": "assets/mist.png",
          "value": "Unhealthy",
          "description": "Might cause severe health issues",
        };
      default:
        return {
          "image": "assets/rainbow.png",
          "value": "No data",
          "description": "No internet connection",
        };
    }
  }

  String airQualityForecastDescription(int? aqi) {
    if (aqi == null) return "No data";

    switch (aqi) {
      case 1:
        return "Good";
      case 2:
        return "Fair";
      case 3:
        return "Moderate";
      case 4:
        return "Poor";
      case 5:
        return "Unhealthy";
      default:
        return "Unavailable";
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = ScreenSize.width(context);
    double height = ScreenSize.height(context);
    bool isLandscape = ScreenSize.orientation(context);

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/background.png'),
              fit: BoxFit.cover,
            ),
          ),
        ),
        title: const Center(
          child: Text("Air Quality"),
        ),
        actions: [IconButton(onPressed: () {}, icon: const Icon(Icons.air))],
      ),
      body: Container(
        width: width,
        height: height,
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
                  widget.aqiData != null
                    ? Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 0, vertical: 0),
                          child: Container(
                            height: 510,
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
                                  blurRadius: 7,
                                  offset: const Offset(0, 6),
                                ),
                              ],
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                              child: Column(
                                children: [
                                  Expanded(
                                    child: Row(
                                      children: [
                                        const Spacer(),
                                        const Spacer(),
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            const Spacer(),
                                            Text(
                                              "Air Quality Index",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  color: Colors.black),
                                            ),
                                            const Spacer(),
                                            Text(
                                              "${airQualityDescription(widget.aqiData?.aqi)["value"]}",
                                              textAlign: TextAlign.center,
                                              style: const TextStyle(
                                                fontSize: 25,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.blue,
                                              ),
                                            ),
                                            const Spacer(),
                                          ],
                                        ),
                                        const Spacer(),
                                        const Spacer(),
                                        const Spacer(),
                                        Column(
                                          children: [
                                            const Spacer(),
                                            const Spacer(),
                                            const Spacer(),
                                            Text(
                                              widget.aqiData != null
                                                ? widget.aqiData!.aqi.toString()
                                                : 'Loading...',
                                              textAlign: TextAlign.center,
                                              style: const TextStyle(
                                                fontSize: 50,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.blue,
                                              ),
                                            ),
                                          ],
                                        ),
                                        const Spacer(),
                                        const Spacer(),
                                        Column(
                                          children: [
                                            const Spacer(),
                                            Image.asset('assets/wind.png',
                                                width: 120),
                                            const Spacer(),
                                          ],
                                        ),
                                        const Spacer(),
                                        isLandscape
                                          ? const Spacer()
                                          : SizedBox(),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 15),
                                  Container(
                                    width: isLandscape ? width * 0.7 : 330,
                                    decoration: ShapeDecoration(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(15),
                                        side: const BorderSide(
                                          width: 2.5, color: Colors.white)),
                                      color: Colors.white.withOpacity(0.50),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 20, vertical: 10),
                                      child: Center(
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            const Spacer(),
                                            Image.asset(
                                              "${airQualityDescription(widget.aqiData?.aqi)["image"]}",
                                              fit: BoxFit.fitWidth,
                                              height: 32,
                                            ),
                                            isLandscape
                                              ? SizedBox(width: 10,)
                                              : const Spacer(),
                                            Container(
                                              child: Text(
                                                "${airQualityDescription(widget.aqiData?.aqi)["description"]}",
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
                                  const SizedBox(height: 20),
                                  isLoading
                                    ? Center(
                                      child: CircularProgressIndicator())
                                    : SfCircularChart(
                                        title: ChartTitle(
                                          text: 'Air Quality Components (µg/m³)'),
                                          legend: Legend(
                                            isVisible: true,
                                            isResponsive: true,
                                            position: LegendPosition.bottom,
                                            iconHeight: 25,
                                            textStyle: TextStyle(fontSize: 15),
                                            overflowMode: LegendItemOverflowMode.wrap),
                                          series: <CircularSeries>[
                                            widget.aqiData != null
                                              ? DoughnutSeries<ChartData,
                                                String>(
                                                  radius: '80%',
                                                  explode: true,
                                                  dataSource: [
                                                    ChartData('CO', widget.aqiData!.co),
                                                    ChartData('NO', widget.aqiData!.no),
                                                    ChartData('NO₂', widget.aqiData!.no2),
                                                    ChartData('O₃', widget.aqiData!.o3),
                                                    ChartData('SO₂', widget.aqiData!.so2),
                                                    ChartData('PM2.5', widget.aqiData!.pm2_5),
                                                    ChartData('PM10', widget.aqiData!.pm10),
                                                    ChartData('NH₃', widget.aqiData!.nh3),
                                                  ],
                                                  xValueMapper: (ChartData data, _) => data.name,
                                                  yValueMapper: (ChartData data, _) => data.value,
                                                  dataLabelSettings: DataLabelSettings(isVisible: true),
                                                ) : DoughnutSeries<ChartData,
                                                  String>(
                                                    radius: '80%',
                                                    explode: true,
                                                    dataSource: [
                                                      ChartData('CO', 2),
                                                      ChartData('NO', 2),
                                                      ChartData('NO₂', 2),
                                                      ChartData('O₃', 2),
                                                      ChartData('SO₂', 2),
                                                      ChartData('PM2.5', 2),
                                                      ChartData('PM10', 2),
                                                      ChartData('NH₃', 2),
                                                    ],
                                                    xValueMapper: (ChartData data, _) => data.name,
                                                    yValueMapper: (ChartData data, _) => data.value,
                                                    dataLabelSettings: DataLabelSettings(isVisible: true),
                                                  )
                                          ],
                                          margin: const EdgeInsets.all(10),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              )
                          : Container(
                              height: 1000, child: Center(child: LoadingScreen())),
                      SizedBox(height: isLandscape ? height * 0.05 : 16),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
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
                      isLoading
                        ? Center(child: CircularProgressIndicator())
                        : Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 0, vertical: 10),
                          height: isLandscape ? 170 : 130,
                          child: ListView.builder(
                            padding: EdgeInsets.symmetric(horizontal: 12),
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            itemCount: widget.forecasts?.length ?? 0,
                            itemBuilder: (context, index) {
                              final forecast = widget.forecasts?[index];
                              final airQualityForecast = airQualityForecastDescription(forecast?.aqi);
                              return Padding(
                                padding:  const EdgeInsets.symmetric(horizontal: 5),
                                child: Container(
                                  width: isLandscape ? 145 : 79,
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
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: <Widget>[
                                      SizedBox(
                                        height: isLandscape ? height * 0.05 : 5),
                                      Text(
                                        DateFormat('EEE').format(forecast!.date),
                                        style: const TextStyle(
                                          fontSize: 17, color: Colors.black),
                                      ),
                                      SizedBox(height: isLandscape ? height * 0.05 : 5),
                                      Text(
                                        "${forecast.aqi}",
                                        style: const TextStyle(
                                          fontSize: 16,
                                          color: Colors.blue,
                                          fontWeight: FontWeight.bold),
                                      ),
                                      SizedBox(height: isLandscape ? height * 0.05 : 5),
                                      Text(
                                        "${airQualityForecast}",
                                        style: const TextStyle(
                                            fontSize: 16,
                                            color: Colors.blue,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      SizedBox(height: isLandscape ? height * 0.05 : 5),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                  SizedBox(height: isLandscape ? height * 0.05 : 12),
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
