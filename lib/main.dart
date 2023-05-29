import 'package:advisor/Providers/AdviceProvider.dart';
import 'package:advisor/SplashScreen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        // Provider for ThoughtProvider
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
