import 'package:flutter/material.dart';
import 'package:hospital_management_interface/pages/appointment_page.dart';
import 'package:hospital_management_interface/pages/doctor_page.dart';
import 'package:hospital_management_interface/pages/home_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(colorScheme: .fromSeed(seedColor: Colors.deepPurple)),
      home: HomePage(),
    );
  }
}
