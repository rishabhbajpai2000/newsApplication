import 'dart:async';

import 'package:advisor/PreviousAdvices.dart';
import 'package:advisor/Providers/AdviceProvider.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';

import 'Utils/utils.dart';

class NewAdvicePage extends StatefulWidget {
  bool offlineMode;
  NewAdvicePage({super.key, required this.offlineMode});

  @override
  State<NewAdvicePage> createState() => _NewAdvicePageState();
}

class _NewAdvicePageState extends State<NewAdvicePage> {
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;

  @override
  void initState() {
    super.initState();
    var offlineMode = widget.offlineMode;
    final newThoughtProvider =
        Provider.of<ThoughtProvider>(context, listen: false);
    // Listen for network connectivity changes
    _connectivitySubscription = _connectivity.onConnectivityChanged.listen(
      (ConnectivityResult result) {
        if (result != ConnectivityResult.none) {
          Utils().toastMessage("Found the internet, new advice coming soon!");
          newThoughtProvider.refreshData();
          setState(() {
            widget.offlineMode = false;
          });
        } else if (result == ConnectivityResult.none) {
          setState(() {
            widget.offlineMode = true;
          });
        }
      },
    );

    // getting the new advice loaded up before firing the widget.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (offlineMode == true) {
        newThoughtProvider.getLastOfflineAdvice();
      } else {
        newThoughtProvider.getNewAdvice();
      }
    });
  }

  @override
  void dispose() {
    // Cancel the connectivity subscription when the widget is disposed
    _connectivitySubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final offlineMode = widget.offlineMode;
    final newThoughtProvider =
        Provider.of<ThoughtProvider>(context, listen: false);

    return MaterialApp(
      home: SafeArea(
        child: GestureDetector(
          onVerticalDragEnd: (DragEndDetails details) =>
              _onVerticalDrag(details, newThoughtProvider, offlineMode),
          child: Scaffold(
            backgroundColor: Colors.grey.shade300,
            body: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/BackgroundNoLogo.png"),
                  fit: BoxFit.cover,
                ),
              ),
              child: Stack(
                children: [
                  Center(
                    child: Padding(
                        padding: const EdgeInsets.fromLTRB(20.0, 0, 20, 0),
                        child: Stack(children: [
                          Container(
                            height: 400,
                            decoration: BoxDecoration(
                                color: Color.fromARGB(255, 14, 64, 99),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                    color: Colors.yellow, width: 10)),
                            margin: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                            padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                            child: Center(
                              // this will listen for any kind of changes inside the thought provider and will update accordingly.
                              child: Consumer<ThoughtProvider>(
                                builder: (BuildContext context, value,
                                    Widget? child) {
                                  if (value.isLoading == true) {
                                    return LoadingAnimationWidget
                                        .staggeredDotsWave(
                                            color: Colors.grey.shade300,
                                            size: 50);
                                  } else {
                                    return Text(
                                      value.thought.toString(),
                                      style: TextStyle(
                                          color: Colors.grey.shade300,
                                          fontSize: 30),
                                    );
                                  }
                                },
                              ),
                            ),
                          ),
                          Positioned(
                              bottom: 0,
                              right: 0,
                              child: Container(
                                width: 70,
                                height: 70,
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.yellow),
                              )),
                          Positioned(
                              top: 0,
                              left: 100,
                              right: 100,
                              child: Container(
                                width: MediaQuery.of(context).size.width * 0.5,
                                height: 40,
                                decoration: BoxDecoration(
                                    color: Colors.yellow,
                                    borderRadius: BorderRadius.circular(10)),
                                child: Center(
                                    child: Text(
                                  "Advice",
                                  style: TextStyle(fontSize: 30),
                                )),
                              ))
                        ])),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child:
                            Column(mainAxisSize: MainAxisSize.min, children: [
                          Opacity(
                            opacity: 0.7,
                            child: Icon(
                              Icons.keyboard_arrow_up,
                              size: 36,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          Opacity(
                            opacity: 0.7,
                            child: Text(
                              "Slide up to view previous Advices",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 14),
                            ),
                          )
                        ]),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // on vertically dragging the up from the screen the previous advices will load
  // on dragging down the advice which you currently have will be refreshed.
  _onVerticalDrag(DragEndDetails details, ThoughtProvider newThoughtProvider,
      bool offlineMode) {
    if (details.primaryVelocity == 0) {
      return;
    }
    if (details.primaryVelocity?.compareTo(0) == -1) {
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => const PreviousAdvices()));
    } else {
      if (offlineMode) {
        Utils().toastMessage(
            "The network is not available, page will refresh once its available. ");
      } else {
        newThoughtProvider.getNewAdvice();
      }
    }
  }
}
