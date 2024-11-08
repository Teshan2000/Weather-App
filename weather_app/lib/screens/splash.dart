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
  // late StreamSubscription<ConnectivityResult> _connectivitySubscription;
  bool isConnected = false;

  @override
  void initState() {
    super.initState();
    startSplashTimer();
    // _checkConnection();
    // _navigateToHome();
  }

  // void _checkConnection() async {
  //   var connectivityResult = await (Connectivity().checkConnectivity());
  //   _updateConnectionStatus(connectivityResult);

  //   // Listen for connection changes
  //   _connectivitySubscription = Connectivity().onConnectivityChanged.listen(_updateConnectionStatus);
  // }

  // void _updateConnectionStatus(ConnectivityResult result) {
  //   setState(() {
  //     if (result == ConnectivityResult.mobile || result == ConnectivityResult.wifi) {
  //       isConnected = true;
  //     } else {
  //       isConnected = false;
  //     }
  //   });
  // }

  // void _navigateToHome() async {
  //   // Simulate loading for 3 seconds
  //   await Future.delayed(const Duration(seconds: 3));

  //   // Check if connected before navigating
  //   if (isConnected) {
  //     Navigator.pushReplacementNamed(context, '/home');
  //   } else {
  //     _showNoConnectionDialog();
  //   }
  // }

  // void _showNoConnectionDialog() {
  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return AlertDialog(
  //         title: const Text("No Internet Connection"),
  //         content: const Text("Please check your internet connection and try again."),
  //         actions: [
  //           TextButton(
  //             onPressed: () {
  //               Navigator.of(context).pop();
  //               _checkConnection();
  //             },
  //             child: const Text("Retry"),
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }

  // @override
  // void dispose() {
  //   _connectivitySubscription.cancel();
  //   super.dispose();
  // }

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
                      fontSize: 35,
                      fontWeight: FontWeight.bold
                    ),
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
                width: 170,
                child: Center(
                  child: Text(
                    "Daily Weather Forecasts",
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 35,
                      fontWeight: FontWeight.bold
                    ),
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
