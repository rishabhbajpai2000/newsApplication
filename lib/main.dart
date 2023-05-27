import 'package:advisor/NewAdvice.dart';
import 'package:advisor/Providers/ThoughtProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// void main() {
//   runApp(MaterialApp(
//     home: MultiProvider(
//       providers: [ChangeNotifierProvider(create: (_) => NewThoughtProvider())],
//       child: NewAdvicePage(),
//     ),
//   ));
// }

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThoughtProvider()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: NewAdvicePage(),
    );
  }
}
