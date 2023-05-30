import 'package:advisor/Providers/AdviceProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PreviousAdvices extends StatefulWidget {
  const PreviousAdvices({super.key});

  @override
  State<PreviousAdvices> createState() => _PreviousAdvicesState();
}

class _PreviousAdvicesState extends State<PreviousAdvices> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final newThoughtProvider =
        Provider.of<ThoughtProvider>(context, listen: false);

    return SafeArea(
        child: Scaffold(
            backgroundColor: Colors.grey.shade300,
            body: Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(
                          "assets/BackgroundNoLogo.png"), // change the background to remove logo from in betweeen
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(30, 50, 20, 0),
                        child: Row(
                          children: [
                            const Expanded(
                              flex: 4,
                              child: Text("Previous Advices!",
                                  style: TextStyle(
                                      fontSize: 50, color: Colors.white)),
                            ),
                            GestureDetector(
                              onTap: () =>
                                  newThoughtProvider.deleteAllAdvices(),
                              child: const Expanded(
                                  flex: 1,
                                  child: Icon(
                                    Icons.delete,
                                    size: 40,
                                    color: Colors.white,
                                  )),
                            )
                          ],
                        ),
                      ),
                      Expanded(child: Container()),
                      // this will listen to any kind of changes that may come while reading the advice either a new advice is added
                      // or from the local storage as well.
                      Consumer<ThoughtProvider>(
                          builder: (BuildContext context, value, child) {
                        value.readAdvices();
                        return SizedBox(
                          height: 400,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: value.adviceList.isNotEmpty
                                ? value.adviceList.length - 1
                                : 0,
                            itemBuilder: (context, index) {
                              return Stack(
                                children: [
                                  Center(
                                    child: Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            20.0, 0, 20, 0),
                                        child: Stack(children: [
                                          Container(
                                            height: 500,
                                            width: 300,
                                            decoration: BoxDecoration(
                                                color: Color.fromARGB(
                                                    255, 14, 64, 99),
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                                border: Border.all(
                                                    color: Colors.yellow,
                                                    width: 10)),
                                            margin: const EdgeInsets.fromLTRB(
                                                10, 10, 10, 10),
                                            padding: const EdgeInsets.fromLTRB(
                                                10, 10, 10, 10),
                                            child: Center(
                                                // this will listen for any kind of changes inside the thought provider and will update accordingly.
                                                child: Text(
                                              value.adviceList[index],
                                              style: TextStyle(
                                                  color: Colors.grey.shade300,
                                                  fontSize: 30),
                                            )),
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
                                        ])),
                                  ),
                                ],
                              );
                            },
                          ),
                        );
                      }),
                      Expanded(flex: 2, child: Container())
                    ],
                  ),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    child: Column(mainAxisSize: MainAxisSize.min, children: [
                      Opacity(
                        opacity: 0.7,
                        child: Icon(
                          Icons.keyboard_arrow_right,
                          size: 36,
                          color: Colors.white,
                        ),
                      ),
                    ]),
                  ),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: Container(
                    child: Column(mainAxisSize: MainAxisSize.min, children: [
                      Opacity(
                        opacity: 0.7,
                        child: Icon(
                          Icons.keyboard_arrow_left,
                          size: 36,
                          color: Colors.white,
                        ),
                      ),
                    ]),
                  ),
                )
              ],
            )));
  }
}
