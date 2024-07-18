import 'dart:convert';
import 'package:dollar_conv/secret.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ScaffoldScreen extends StatelessWidget {
  const ScaffoldScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const ScaffolScreen();
  }
}

class ScaffolScreen extends StatefulWidget {
  const ScaffolScreen({super.key});

  @override
  State<ScaffolScreen> createState() => _ScaffolScreenState();
}

class _ScaffolScreenState extends State<ScaffolScreen> {
  double result = 0.0;
  late Future<Map<String, dynamic>> currencyFuture;
  final TextEditingController _controller = TextEditingController();
  String fromCurrency = 'USD';
  String toCurrency = 'INR';

  Future<Map<String, dynamic>> getCurrency() async {
    try {
      final res = await http.get(
          Uri.parse("https://v6.exchangerate-api.com/v6/$api_key/latest/USD"));
      final currency = jsonDecode(res.body);

      if (currency["result"] == "error") {
        throw 'Unexpected error occurred';
      }
      return currency;
    } catch (e) {
      throw e.toString();
    }
  }

  @override
  void initState() {
    super.initState();
    currencyFuture = getCurrency();
  }

  void _convert(Map<String, dynamic> rates) {
    setState(() {
      double fromRate = (rates[fromCurrency] as num).toDouble();
      double toRate = (rates[toCurrency] as num).toDouble();
      double amount = double.tryParse(_controller.text) ?? 0.0;
      result = (amount / fromRate) * toRate;
      _controller.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CURRENCY CONVERTER',
            style: TextStyle(fontWeight: FontWeight.w900)),
        centerTitle: true,
        backgroundColor: const Color.fromRGBO(233, 13, 13, 0.004),
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: currencyFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const LinearProgressIndicator();
          }
          if (snapshot.hasError) {
            return Center(child: Text(snapshot.error.toString()));
          }

          if (snapshot.hasData) {
            final data = snapshot.data!;
            final rates = data["conversion_rates"];

            if (rates == null) {
              return const Center(child: Text('No rates available'));
            }

            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "$result",
                    style: const TextStyle(fontSize: 20),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("From"),
                      SizedBox(
                        width: 250,
                        child: DropdownButton<String>(
                          value: fromCurrency,
                          items: rates.keys
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          onChanged: (newValue) {
                            setState(() {
                              fromCurrency = newValue!;
                            });
                          },
                          isExpanded: true,
                          underline: Container(
                            height: 2,
                            color: Colors.blue,
                          ),
                        ),
                      ),
                      const Text("To"),
                      SizedBox(
                        width: 250,
                        child: DropdownButton<String>(
                          value: toCurrency,
                          items: rates.keys
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            setState(() {
                              toCurrency = newValue!;
                            });
                          },
                          isExpanded: true,
                          underline: Container(
                            height: 2,
                            color: Colors.blue,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 300,
                        child: TextField(
                          controller: _controller,
                          decoration: const InputDecoration(
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 10.0, horizontal: 10.0),
                            labelText: 'Enter amount',
                            border: OutlineInputBorder(),
                            hintText: 'Enter amount here...',
                            prefixIcon: Icon(Icons.attach_money),
                          ),
                          keyboardType:
                              const TextInputType.numberWithOptions(decimal: true),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  TextButton(
                    onPressed: () => _convert(rates),
                    style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.all<Color>(
                          Colors.blue), // Background color of the button
                      foregroundColor: WidgetStateProperty.all<Color>(
                          Colors.white), // Text (foreground) color
                      padding: WidgetStateProperty.all<EdgeInsetsGeometry>(
                          const EdgeInsets.all(15)), // Padding around the button content
                      textStyle: WidgetStateProperty.all<TextStyle>(
                          const TextStyle(fontSize: 16)), // Text style of the button text
                    ),
                    child: const Text('Convert'),
                  ),
                ],
              ),
            );
          } else {
            return const Center(child: Text('No data available'));
          }
        },
      ),
    );
  }
}

void main() {
  runApp(const MaterialApp(
    home: ScaffoldScreen(),
  ));
}
