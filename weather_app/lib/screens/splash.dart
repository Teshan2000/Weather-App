import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
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
  bool isConnected = false;
  StreamSubscription? _internetConnectionStreamSubscription;

  @override
  void initState() {
    super.initState();    
    _checkConnection();
  }

  @override
  void dispose() {
    _internetConnectionStreamSubscription?.cancel();
    super.dispose();
  }

  void _checkConnection() async {
    _internetConnectionStreamSubscription =
        InternetConnection().onStatusChange.listen((event) {
      print(event);
      switch (event) {
        case InternetStatus.connected:
          setState(() {
            isConnected = true;
            startSplashTimer();
          });
          break;
        case InternetStatus.disconnected:
          setState(() {
            isConnected = false;
            _showNoConnectionDialog();
          });
          break;
        default:
          setState(() {
            isConnected = false;
          });
          break;
      }
    });
  }

  void _showNoConnectionDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("No Internet Connection"),
          content: const Text(
              "Please check your internet connection and try again."),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Retry"),
            ),
          ],
        );
      },
    );
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
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
            image: DecorationImage(
          image: AssetImage('assets/background.png'),
          fit: BoxFit.cover,
        )),
        child: Padding(
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
                    "Daily Weather Forecasts",
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        fontSize: 35, fontWeight: FontWeight.bold),
                  ),
                ),
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
                width: 870,
                child: Center(
                  child: Text(
                    "Loading Weather...",
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        fontSize: 35, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
