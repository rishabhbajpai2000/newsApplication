import 'dart:async';

import 'package:advisor/NewAdvice.dart';
import 'package:advisor/PreviousAdvices.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
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
    // make network call 
    
    if (await makeNetworkCall()){
      Timer(
          const Duration(seconds: 2),
          () => Navigator.push(context,
              MaterialPageRoute(builder: (context) => NewAdvicePage())));
    }
    else{
        Timer(
          const Duration(seconds: 2),
          () => Navigator.push(context,
              MaterialPageRoute(builder: (context) => PreviousAdvices())));
    }
  }

    Future<bool> makeNetworkCall() async {
    final response = await http.get(Uri.parse("https://api.adviceslip.com/advice"));
    return response.statusCode == 200;
  }
}
