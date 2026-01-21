import 'dart:async';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:weather_app/main.dart';
import 'package:weather_app/screens/home.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.light,
    ),
  );
    startSplashTimer();
  }

  void startSplashTimer() {
    const splashDuration = Duration(seconds: 3);

    Timer(splashDuration, () {
      SchedulerBinding.instance.addPostFrameCallback((_) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (BuildContext context) {
              return const Home();
            },
          ),
        );
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    double width = ScreenSize.width(context);
    double height = ScreenSize.height(context);
    bool isLandscape = ScreenSize.orientation(context);

    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
            image: DecorationImage(
          image: AssetImage('assets/background.png'),
          fit: BoxFit.cover,
        )),
        child: Padding(
          padding: isLandscape ? EdgeInsets.all(0) : EdgeInsets.all(38),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: Lottie.asset(
                  'assets/splash.json',
                  fit: BoxFit.contain,
                  width: isLandscape ? width * 0.3 : width,
                ),
              ),
              SizedBox(
                height: isLandscape ? height * 0 : height * 0.01,
              ),
              Container(
                width: isLandscape ? 300 : 230,
                child: Center(
                  child: Text(
                    "Daily Weather Forecasts",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: isLandscape ? 35 : 40,
                      fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              SizedBox(
                height: isLandscape ? height * 0.05 : height * 0.05,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class LoadingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double width = ScreenSize.width(context);
    double height = ScreenSize.height(context);
    bool isLandscape = ScreenSize.orientation(context);

    return Scaffold(
      body: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
            image: DecorationImage(
          image: AssetImage('assets/background.png'),
          fit: BoxFit.cover,
        )),
        child: Padding(
          padding: isLandscape ? EdgeInsets.all(0) : EdgeInsets.all(38),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: Lottie.asset(
                  'assets/splash.json',
                  fit: BoxFit.contain,
                  width: isLandscape ? width * 0.3 : width,
                ),
              ),
              SizedBox(
                height: isLandscape ? height * 0 : height * 0.01,
              ),
              Container(
                width: isLandscape ? 300 : 230,
                child: Center(
                  child: Text(
                    "Loading Weather...",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: isLandscape ? 35 : 40,
                      fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              SizedBox(
                height: isLandscape ? height * 0.05 : height * 0.05,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
