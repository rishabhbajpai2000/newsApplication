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
  Widget build(BuildContext context) {
    final newThoughtProvider =
        Provider.of<ThoughtProvider>(context, listen: false);
    return SafeArea(
        child: Scaffold(
            backgroundColor: Colors.grey.shade300,
            body: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(30, 50, 20, 0),
                  child: Row(
                    children: [
                      const Expanded(
                        flex: 4,
                        child: Text(
                          "Previous Advices!",
                          style: TextStyle(fontSize: 50),
                        ),
                      ),
                      GestureDetector(
                        onTap: () => newThoughtProvider.deleteAllAdvices(),
                        child: const Expanded(
                            flex: 1,
                            child: Icon(
                              Icons.delete,
                              size: 40,
                            )),
                      )
                    ],
                  ),
                ),

                // this will listen to any kind of changes that may come while reading the advice either a new advice is added 
                // or from the local storage as well. 
                Consumer<ThoughtProvider>(
                    builder: (BuildContext context, value, child) {
                  value.readAdvices();
                    return Expanded(
                      child: ListView.builder(
                        itemCount: value.adviceList.isNotEmpty
                            ? value.adviceList.length - 1
                            : 0,
                        itemBuilder: (context, index) {
                          return ListTile(
                              title: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            margin: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                            padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                            child: Text(
                              value.adviceList[index],
                              style: const TextStyle(fontSize: 30),
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
