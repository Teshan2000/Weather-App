import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class WeatherMap extends StatefulWidget {
  @override
  _WeatherMapState createState() => _WeatherMapState();
}

class _WeatherMapState extends State<WeatherMap> {
  // OpenWeather API key
  final String apiKey = 'c3281946b6139602ecabb86fd3e733c2';
  // List<Marker> weatherMarkers = [];
  bool _showClouds = false;
  bool _showTemp = false;
  bool _showAirQuality = false;
  bool _showWinds = false;
  bool _showPrecipitation = false;
  bool _showPressure = false;

  // Future<void> updateWeatherMarkers() async {
  //   // Clear existing markers
  //   weatherMarkers.clear();

  //   // Add markers based on each weather condition enabled
  //   if (_showClouds) {
  //     weatherMarkers.add(
  //       Marker(
  //         point: LatLng(6.9319, 79.8478),
  //         child: Image.asset(
  //           "assets/clouds.png",
  //           fit: BoxFit.contain,
  //           width: 35,
  //         ),
  //       ),
  //     );
  //   }
  //   if (_showTemp) {
  //     weatherMarkers.add(
  //       Marker(
  //         point: LatLng(6.9319, 79.8478),
  //         child: Image.asset(
  //           "assets/max.png",
  //           fit: BoxFit.contain,
  //           width: 35,
  //         ),
  //       ),
  //     );
  //   }
  //   if (_showAirQuality) {
  //     weatherMarkers.add(
  //       Marker(
  //         point: LatLng(6.9319, 79.8478),
  //         child: Image.asset(
  //           "assets/wind.png",
  //           fit: BoxFit.contain,
  //           width: 35,
  //         ),
  //       ),
  //     );
  //   }
  //   if (_showWinds) {
  //     weatherMarkers.add(
  //       Marker(
  //         point: LatLng(6.9319, 79.8478),
  //         child: Image.asset(
  //           "assets/wind.png",
  //           fit: BoxFit.contain,
  //           width: 35,
  //         ),
  //       ),
  //     );
  //   }
  //   if (_showPrecipitation) {
  //     weatherMarkers.add(
  //       Marker(
  //         point: LatLng(6.9319, 79.8478),
  //         child: Image.asset(
  //           "assets/water.png",
  //           fit: BoxFit.contain,
  //           width: 35,
  //         ),
  //       ),
  //     );
  //   }
  //   if (_showPressure) {
  //     weatherMarkers.add(
  //       Marker(
  //         point: LatLng(6.9319, 79.8478),
  //         child: Image.asset(
  //           "assets/pressure.png",
  //           fit: BoxFit.contain,
  //           width: 35,
  //         ),
  //       ),
  //     );
  //   }
  //   // Refresh markers on the map
  //   setState(() {});
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Color.fromARGB(255, 184, 226, 245),
        title: const Center(
          child: Text("Weather Map"),
        ),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.map_outlined))
        ],
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(
            image: DecorationImage(
          image: AssetImage('assets/background.png'),
          fit: BoxFit.cover,
        )),
        child: Stack(
          children: [
            FlutterMap(
              options: MapOptions(
                initialCenter: LatLng(6.913889, 79.860556),
                initialZoom: 16.0,
                // maxZoom: 5
              ),
              children: [
                TileLayer(
                  urlTemplate:
                      'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                  subdomains: ['a', 'b', 'c'],
                ),
                if (_showClouds)
                  TileLayer(
                    urlTemplate:
                        'https://tile.openweathermap.org/map/clouds_new/{z}/{x}/{y}.png?appid=$apiKey',
                    // opacity: 0.5, // Set transparency
                  ),
                if (_showWinds)
                  TileLayer(
                    urlTemplate:
                        'https://tile.openweathermap.org/map/wind_new/{z}/{x}/{y}.png?appid=$apiKey',
                    // opacity: 0.3, // Adjust opacity
                  ),
                if (_showTemp)
                  TileLayer(
                    urlTemplate:
                        'https://tile.openweathermap.org/map/temp_new/{z}/{x}/{y}.png?appid=$apiKey',
                    // opacity: 0.3, // Adjust opacity
                  ),
                if (_showPrecipitation)
                  TileLayer(
                    urlTemplate:
                        'https://tile.openweathermap.org/map/precipitation_new/{z}/{x}/{y}.png?appid=$apiKey',
                    // opacity: 0.3, // Adjust opacity
                  ),
                if (_showPressure)
                  TileLayer(
                    urlTemplate:
                        'https://tile.openweathermap.org/map/pressure_new/{z}/{x}/{y}.png?appid=$apiKey',
                    // opacity: 0.3, // Adjust opacity
                  ),
                MarkerLayer(
                  markers: [
                    Marker(
                      point: LatLng(6.913889, 79.860556),
                      child: Icon(
                        Icons.location_on,
                        color: Colors.red,
                      )
                    ),
                  ]
                ),
              ],
            ),            
            // if (_showClouds)
            // Container(
            //   color: Colors.transparent,
            //   width: MediaQuery.of(context).size.width,
            //   height: MediaQuery.of(context).size.height,
            //   child: Center(
            //     child: Text(
            //       "Cloudiness: 13%",
            //       style: TextStyle(color: Colors.white, fontSize: 20),
            //     ),
            //   ),
            // ),
            // if (_showTemp)
            // Container(
            //   width: MediaQuery.of(context).size.width,
            //   height: MediaQuery.of(context).size.height,
            //   child: Center(
            //     child: Text(
            //       "Temperature: 30°C",
            //       style: TextStyle(color: Colors.white, fontSize: 20),
            //     ),
            //   ),
            // ),
            if (_showAirQuality)
            Container(
              color: Colors.green.withOpacity(0.5),
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              // child: Center(
              //   child: Text(
              //     "Air Quality: Good",
              //     style: TextStyle(color: Colors.white, fontSize: 20),
              //   ),
              // ),
            ),
            // if (_showWinds)
            // Container(
            //   width: MediaQuery.of(context).size.width,
            //   height: MediaQuery.of(context).size.height,
            //   child: Center(
            //     child: Text(
            //       "Winds: Southwest 13 km/h",
            //       style: TextStyle(color: Colors.white, fontSize: 20),
            //     ),
            //   ),
            // ),
            // if (_showPrecipitation)
            // Container(
            //   width: MediaQuery.of(context).size.width,
            //   height: MediaQuery.of(context).size.height,
            //   child: Center(
            //     child: Text(
            //       "Precipitation: 5mm",
            //       style: TextStyle(color: Colors.white, fontSize: 20),
            //     ),
            //   ),
            // ),
            // if (_showPressure)
            // Container(
            //   width: MediaQuery.of(context).size.width,
            //   height: MediaQuery.of(context).size.height,
            //   child: Center(
            //     child: Text(
            //       "Pressure: 1013 mb",
            //       style: TextStyle(color: Colors.white, fontSize: 20),
            //     ),
            //   ),
            // ),
            Positioned(
              bottom: 0,
              // right: 10,
              // left: 10,
              child: Container(
                padding:
                    const EdgeInsets.only(top: 10, bottom: 30, left: 10, right: 10),
                width: MediaQuery.of(context).size.width,
                // height: MediaQuery.of(context).size.height,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15)),
                    image: DecorationImage(
                  image: AssetImage('assets/background.png'),
                  fit: BoxFit.cover,
                )),
                child: Column(
                  children: [
                    Row(
                      children: [
                        FloatingActionButton.extended(
                          extendedIconLabelSpacing: 5.0,
                          extendedPadding: EdgeInsets.symmetric(horizontal: 10),
                          elevation: 0,
                          label: _showClouds 
                          ?  Text("78%", style: TextStyle(color: Colors.white),) 
                          : Text("Clouds", style: TextStyle(color: Colors.black),),
                          heroTag: "cloudsTag",
                          icon: Image.asset(
                            "assets/clouds.png",
                            fit: BoxFit.contain,
                            width: 35,
                          ),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                              side: const BorderSide(
                                  width: 2.5, color: Colors.white)),
                          backgroundColor: _showClouds
                              ? Colors.blue.withOpacity(0.5)
                              : Colors.white.withOpacity(0.5),
                          onPressed: () {
                            setState(() {
                              _showClouds = !_showClouds;
                            });
                            // updateWeatherMarkers();
                          },
                        ),
                        SizedBox(width: 10),
                        FloatingActionButton.extended(
                          extendedIconLabelSpacing: 5.0,
                          extendedPadding: EdgeInsets.symmetric(horizontal: 10),
                          elevation: 0,
                          label: _showTemp 
                          ?  Text("30°C", style: TextStyle(color: Colors.white),) 
                          : Text("Temperature", style: TextStyle(color: Colors.black),),
                          heroTag: "tempTag",
                          icon: Image.asset(
                            "assets/min.png",
                            fit: BoxFit.contain,
                            width: 15,
                          ),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                              side: const BorderSide(
                                  width: 2.5, color: Colors.white)),
                          backgroundColor: _showTemp
                              ? Colors.blue.withOpacity(0.5)
                              : Colors.white.withOpacity(0.5),
                          onPressed: () {
                            setState(() {
                              _showTemp = !_showTemp;
                              // updateWeatherMarkers();
                            });
                          },
                        ),
                        SizedBox(width: 10),
                        FloatingActionButton.extended(
                          extendedIconLabelSpacing: 5.0,
                          extendedPadding: EdgeInsets.symmetric(horizontal: 10),
                          elevation: 0,
                          label: _showAirQuality 
                          ?  Text("Good", style: TextStyle(color: Colors.white),) 
                          : Text("Air Quality", style: TextStyle(color: Colors.black),),
                          heroTag: "airTag",
                          icon: Image.asset(
                            "assets/wind.png",
                            fit: BoxFit.contain,
                            width: 35,
                          ),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                              side: const BorderSide(
                                  width: 2.5, color: Colors.white)),
                          backgroundColor: _showAirQuality
                              ? Colors.blue.withOpacity(0.5)
                              : Colors.white.withOpacity(0.5),
                          onPressed: () {
                            setState(() {
                              _showAirQuality = !_showAirQuality;
                            });
                            // updateWeatherMarkers();
                          },
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    Row(
                      children: [
                        FloatingActionButton.extended(
                          extendedIconLabelSpacing: 3.0,
                          extendedPadding: EdgeInsets.symmetric(horizontal: 10),
                          elevation: 0,
                          label: _showWinds 
                          ?  Text("6 km/h", style: TextStyle(color: Colors.white),) 
                          : Text("Winds", style: TextStyle(color: Colors.black),),
                          heroTag: "windsTag",
                          icon: Image.asset(
                            "assets/wind.png",
                            fit: BoxFit.contain,
                            width: 35,
                          ),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                              side: const BorderSide(
                                  width: 2.5, color: Colors.white)),
                          backgroundColor: _showWinds
                              ? Colors.blue.withOpacity(0.5)
                              : Colors.white.withOpacity(0.5),
                          onPressed: () {
                            setState(() {
                              _showWinds = !_showWinds;
                            });
                            // updateWeatherMarkers();
                          },
                        ),
                        SizedBox(width: 10),
                        FloatingActionButton.extended(
                          extendedIconLabelSpacing: 0.0,
                          extendedPadding: EdgeInsets.symmetric(horizontal: 10),
                          elevation: 0,
                          label: _showPrecipitation 
                          ?  Text("2 mm", style: TextStyle(color: Colors.white),) 
                          : Text("Precipitation", style: TextStyle(color: Colors.black),),
                          heroTag: "rainTag",
                          icon: Image.asset(
                            "assets/water.png",
                            fit: BoxFit.contain,
                            width: 35,
                          ),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                              side: const BorderSide(
                                  width: 2.5, color: Colors.white)),
                          backgroundColor: _showPrecipitation
                              ? Colors.blue.withOpacity(0.5)
                              : Colors.white.withOpacity(0.5),
                          onPressed: () {
                            setState(() {
                              _showPrecipitation = !_showPrecipitation;
                            });
                            // updateWeatherMarkers();
                          },
                        ),
                        SizedBox(width: 10),
                        FloatingActionButton.extended(
                          extendedIconLabelSpacing: 3.0,
                          extendedPadding: EdgeInsets.symmetric(horizontal: 10),
                          elevation: 0,
                          label: _showPressure 
                          ?  Text("1013 mb", style: TextStyle(color: Colors.white),) 
                          : Text("Pressure", style: TextStyle(color: Colors.black),),
                          heroTag: "pressureTag",
                          icon: Image.asset(
                            "assets/pressure.png",
                            fit: BoxFit.contain,
                            width: 35,
                          ),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                              side: const BorderSide(
                                  width: 2.5, color: Colors.white)),
                          backgroundColor: _showPressure
                              ? Colors.blue.withOpacity(0.5)
                              : Colors.white.withOpacity(0.5),
                          onPressed: () {
                            setState(() {
                              _showPressure = !_showPressure;
                            });
                            // updateWeatherMarkers();
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
