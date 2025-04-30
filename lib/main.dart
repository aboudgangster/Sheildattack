import 'package:flutter/material.dart';
import 'splash_screen.dart';
import 'pin_screen.dart';
import 'main_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ShieldStack',
      theme: ThemeData(
        primarySwatch: Colors.green,
        scaffoldBackgroundColor: Colors.white,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        '/pin': (context) => PinScreen(),
        '/main': (context) => const MainScreen(),
      },
    );
  }
}
