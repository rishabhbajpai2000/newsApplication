import 'package:flutter/material.dart';

class PreviousAdvices extends StatefulWidget {
  const PreviousAdvices({super.key});

  @override
  State<PreviousAdvices> createState() => _PreviousAdvicesState();
}

class _PreviousAdvicesState extends State<PreviousAdvices> {
  final List<String> adviceList = [
    "Try to not compliment people on things they don't control",
    "Value the people in your life.",
    "Winter is coming.",
    "Try to not compliment people on things they don't control",
    "Value the people in your life.",
    "Winter is coming.",
    "Try to not compliment people on things they don't control",
    "Value the people in your life.",
    "Winter is coming.",
    "Try to not compliment people on things they don't control",
    "Value the people in your life.",
    "Winter is coming.",
    // add more advice strings here
  ];
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            body: Column(
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(20, 50, 20, 0),
          child: Text(
            "Previous Advices!",
            style: TextStyle(fontSize: 50),
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: adviceList.length,
            itemBuilder: (context, index) {
              return ListTile(
                  title: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                margin: EdgeInsets.fromLTRB(0, 10, 10, 10),
                padding: EdgeInsets.fromLTRB(0, 10, 10, 10),
                child: Text(
                  adviceList[index],
                  style: TextStyle(fontSize: 30),
                ),
              ));
            },
          ),
        ),
      ],
    )));
  }
}
