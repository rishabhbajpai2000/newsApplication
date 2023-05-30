import 'dart:async';

import 'package:advisor/NewAdvice.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

import 'Utils/utils.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // this function will decide either to send to new advice page
    // or previous advice page depending on the network and api availablity
    pageDecide();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/BackgroundNoLogo.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
            child: Image(
          image: AssetImage("assets/Logo.png"),
        )),
      ),
    );
  }

  Future<void> pageDecide() async {
    // make network call and decide.
    if (await checkNetworkStatus()) {
      Timer(
          const Duration(seconds: 2),
          () => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => NewAdvicePage(
                        offlineMode: false,
                      ))));
    } else {
      Timer(
          const Duration(seconds: 2),
          () => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => NewAdvicePage(offlineMode: true))));
    }
  }

  Future<bool> checkNetworkStatus() async {
    try {
      final connectivityResult = await (Connectivity().checkConnectivity());
      if (connectivityResult == ConnectivityResult.none) {
        Utils().toastMessage(
            "The network is not available, last fetched advice will be shown.");
        return false;
      }
      return true;
    } on Exception {
      Utils().toastMessage(
          "The network is not available, last fetched advice will be shown. ");
      return false;
    }
  }
}
