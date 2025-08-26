import 'package:flutter/material.dart';
import 'screens/splash_screen.dart';
import 'routes.dart';

class MyPlotWayApp extends StatelessWidget {
  const MyPlotWayApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My Plot Way',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(colorSchemeSeed: Colors.indigo, useMaterial3: true),
      routes: appRoutes,
      home: const SplashScreen(),
    );
  }
}
