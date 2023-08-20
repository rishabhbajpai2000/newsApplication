import 'package:advisor/Providers/NewsProvider.dart';
import 'package:advisor/view/SplashScreen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    // specifying the providers for the application.
    MultiProvider(
      providers: [
        // Provider for newsprovider
        ChangeNotifierProvider(create: (_) => ThoughtProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: SplashScreen(), // Display the SplashScreen initially
    );
  }
}


