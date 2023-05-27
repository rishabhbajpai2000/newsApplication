import 'package:advisor/PreviousAdvices.dart';
import 'package:advisor/Providers/ThoughtProvider.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';

class NewAdvicePage extends StatefulWidget {
  const NewAdvicePage({super.key});

  @override
  State<NewAdvicePage> createState() => _NewAdvicePageState();
}

class _NewAdvicePageState extends State<NewAdvicePage> {
  @override
  Widget build(BuildContext context) {
    final newThoughtProvider =
        Provider.of<ThoughtProvider>(context, listen: false);

    return MaterialApp(
      home: SafeArea(
        child: GestureDetector(
          onVerticalDragEnd: (DragEndDetails details) =>
              _onVerticalDrag(details, newThoughtProvider),
          child: Scaffold(
            backgroundColor: Colors.grey.shade300,
            body: Stack(
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(30, 50, 20, 0),
                  child: Text(
                    "Advice!",
                    style: TextStyle(fontSize: 50),
                  ),
                ),
                Center(
                  child: Padding(
                      padding: EdgeInsets.fromLTRB(20.0, 0, 20, 0),
                      child: Container(
                        height: 400,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
                        padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                        child: Center(
                          child: Consumer<ThoughtProvider>(
                            builder:
                                (BuildContext context, value, Widget? child) {
                              if (value.isloading == true) {
                                return LoadingAnimationWidget.staggeredDotsWave(
                                    color: Colors.grey.shade300, size: 50);
                              } else {
                                return Text(
                                  value.thought.toString(),
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineMedium,
                                );
                              }
                            },
                          ),
                        ),
                      )),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _onVerticalDrag(DragEndDetails details, ThoughtProvider newThoughtProvider) {
    if (details.primaryVelocity == 0) {
      return;
    }

    if (details.primaryVelocity?.compareTo(0) == -1) {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => PreviousAdvices()));
    } else {
      newThoughtProvider.getNewThought();
    }
  }
}
