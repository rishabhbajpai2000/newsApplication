import 'package:advisor/PreviousAdvices.dart';
import 'package:flutter/material.dart';

class NewAdvicePage extends StatefulWidget {
  const NewAdvicePage({super.key});

  @override
  State<NewAdvicePage> createState() => _NewAdvicePageState();
}

class _NewAdvicePageState extends State<NewAdvicePage> {
  String newdvice = "";
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SafeArea(
        child: GestureDetector(
          onVerticalDragEnd: (DragEndDetails details) =>
              _onVerticalDrag(details),
          child: Scaffold(
            body: Stack(
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(20, 50, 20, 0),
                  child: Text(
                    "Advise! ",
                    style: TextStyle(fontSize: 50),
                  ),
                ),
                Center(
                  child: Padding(
                      padding: EdgeInsets.fromLTRB(20.0, 0, 20, 0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        margin: EdgeInsets.fromLTRB(0, 10, 10, 10),
                        padding: EdgeInsets.fromLTRB(0, 10, 10, 10),
                        child: Text(
                          "agar hum wahan aae to aapki maa hi chod denge ",
                          style: TextStyle(fontSize: 50),
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

  _onVerticalDrag(DragEndDetails details) {
    if (details.primaryVelocity == 0)
      return; // user have just tapped on screen (no dragging)

    if (details.primaryVelocity?.compareTo(0) == -1) {
      print('dragged from bottom');
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => PreviousAdvices()));
    } else {
      // Now we need to update the page to get a new advice.
      print('dragged from up');
    }
  }
}
