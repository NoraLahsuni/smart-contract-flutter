import 'package:flutter/material.dart';
import 'contract_linking.dart';
import 'helloUI.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ContractLinking>(
      create: (_) => ContractLinking(),
      child: MaterialApp(
        title: "Hello World DApp",
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          brightness: Brightness.dark,
          primaryColor: const Color.fromARGB(255, 11, 30, 134),
          hintColor: const Color.fromARGB(255, 15, 10, 100),
          scaffoldBackgroundColor: Colors.grey[850],
          appBarTheme: AppBarTheme(
            backgroundColor: Colors.grey[900],
            elevation: 4,
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromARGB(255, 39, 44, 194),
              foregroundColor: Colors.white,
            ),
          ),
          inputDecorationTheme: InputDecorationTheme(
            border: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.cyan[400]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: const Color.fromARGB(255, 13, 20, 96)!),
            ),
          ),
        ),
        home: HelloUI(),
      ),
    );
  }
}