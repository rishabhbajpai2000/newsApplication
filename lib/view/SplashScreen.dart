import 'dart:async';

import 'package:advisor/view/NewNews.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

import '../Utils/utils.dart';

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
    // or previous advice page depending on the network availablity
    pageDecide();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          width: MediaQuery.of(context)
              .size
              .width, // this will take the width of the screen
          decoration: const BoxDecoration(
            color: Color(0xff01c1e33),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("FLASH", style: TextStyle(fontSize: 50, color: Colors.white, fontWeight: FontWeight.bold),),
              SizedBox(height: 15,),
              Container(
                  color: Colors.red,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text("N E W S",style: TextStyle(fontSize: 60, color: Colors.white, fontWeight: FontWeight.bold),),
                  )),
              SizedBox(height: 20,),
              Text("All type of news from all trusted sources",style: TextStyle(fontSize: 15, color: Colors.white, fontWeight: FontWeight.bold),),
              SizedBox(height: 10,),
              Text("for all the types of people",style: TextStyle(fontSize: 15, color: Colors.white, fontWeight: FontWeight.bold),),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> pageDecide() async {
    // make network call and decide which page to load.
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
