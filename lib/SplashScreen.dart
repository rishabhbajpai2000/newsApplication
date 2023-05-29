import 'dart:async';

import 'package:advisor/NewAdvice.dart';
import 'package:advisor/PreviousAdvices.dart';
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
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            "assets/logo2.png",
            width: 100,
            height: 100,
          ),
          // Todo: this animation can be improved.
          AnimatedTextKit(
            animatedTexts: [
              TypewriterAnimatedText(
                'Advisor',
                cursor: "",
                textStyle: const TextStyle(
                    fontSize: 32.0,
                    fontWeight: FontWeight.bold,
                    color: Color(0xff3a243b)),
                speed: const Duration(milliseconds: 250),
              ),
            ],
            isRepeatingAnimation: false,
          )
        ],
      )),
    );
  }

  Future<void> pageDecide() async {
    // make network call and decide.
    if (await checkNetworkStatus()) {
      Timer(
          const Duration(seconds: 2),
          () => Navigator.push(context,
              MaterialPageRoute(builder: (context) =>  NewAdvicePage(offlineMode: false,))));
    } else {
      Timer(
          const Duration(seconds: 2),
          () => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>  NewAdvicePage(offlineMode: true))));
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
