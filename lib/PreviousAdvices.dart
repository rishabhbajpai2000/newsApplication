import 'package:advisor/Providers/ThoughtProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PreviousAdvices extends StatefulWidget {
  const PreviousAdvices({super.key});

  @override
  State<PreviousAdvices> createState() => _PreviousAdvicesState();
}

class _PreviousAdvicesState extends State<PreviousAdvices> {
  @override
  Widget build(BuildContext context) {
    final newThoughtProvider =
        Provider.of<ThoughtProvider>(context, listen: false);
    return SafeArea(
        child: Scaffold(
            backgroundColor: Colors.grey.shade300,
            body: Column(
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(30, 50, 20, 0),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 4,
                        child: Text(
                          "Previous Advices!",
                          style: TextStyle(fontSize: 50),
                        ),
                      ),
                      GestureDetector(
                        onTap: () => newThoughtProvider.deleteAll(),
                        child: Expanded(
                            flex: 1,
                            child: Icon(
                              Icons.delete,
                              size: 40,
                            )),
                      )
                    ],
                  ),
                ),
                Consumer<ThoughtProvider>(
                    builder: (BuildContext context, value, child) {
                  return Expanded(
                    child: ListView.builder(
                      itemCount: value.adviceList.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                            title: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
                          padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                          child: Text(
                            value.adviceList[index],
                            style: TextStyle(fontSize: 30),
                          ),
                        ));
                      },
                    ),
                  );
                }),
              ],
            )));
  }
}
