import 'package:flutter/material.dart';
import 'package:kayak_booking_app/ui/home/home.dart';

void main() {
  runApp(const KayakBookingApp());
}

class KayakBookingApp extends StatelessWidget {
  const KayakBookingApp({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Yathch Booking App',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const HomePage());
  }
}
