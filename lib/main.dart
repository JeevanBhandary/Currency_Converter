
import 'package:dollar_conv/ScaffoldScreen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const CurrencyConverterApp());
}

class CurrencyConverterApp extends StatelessWidget {
  const CurrencyConverterApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'CURRENCY  CONVERTER',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const CurrencyConverterScreen(),
    );
  }
}

class CurrencyConverterScreen extends StatelessWidget {
  const CurrencyConverterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const ScaffoldScreen();
  }
}