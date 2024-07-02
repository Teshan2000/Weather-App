import 'dart:async';
import 'package:lottie/lottie.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
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
    return Scaffold(
      backgroundColor: const Color.fromRGBO(209, 228, 230, 1),
      body: Padding(
        padding: const EdgeInsets.all(38.0),
        child: Column(
          children: [
            const SizedBox(height: 80),
            Center(
              child: Lottie.asset(
                'assets/splash.json',
                fit: BoxFit.contain,
                width: MediaQuery.of(context).size.width,
                // height: MediaQuery.of(context).size.height,
              ),
            ),
            const SizedBox(height: 40),
            Container(
              width: 170,
              child: Center(
                child: Text(
                  "Weather Forecasts",
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 35),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
