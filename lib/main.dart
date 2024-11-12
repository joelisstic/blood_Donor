import 'package:blood_donor/onboarding.dart';
import 'package:blood_donor/splashscreen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(BloodDonationApp());
}

class BloodDonationApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Blood Donation App',
      theme: ThemeData(
        primarySwatch: Colors.red,
        hintColor: Colors.redAccent,

      ),
      home: Splashscreen(),
    );
  }
}
