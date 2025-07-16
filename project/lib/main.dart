import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/window_provider.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const WindowCalculatorApp());
}

class WindowCalculatorApp extends StatelessWidget {
  const WindowCalculatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => WindowProvider(),
      child: MaterialApp(
        title: 'نظام حساب تكلفة النوافذ',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
          fontFamily: 'Cairo',
          textTheme: const TextTheme(
            bodyLarge: TextStyle(fontSize: 16),
            bodyMedium: TextStyle(fontSize: 14),
            titleLarge: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            titleMedium: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
            elevation: 2,
          ),
          cardTheme: CardTheme(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          inputDecorationTheme: InputDecorationTheme(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Colors.blue, width: 2),
            ),
          ),
        ),
        home: const HomeScreen(),
      ),
    );
  }
}