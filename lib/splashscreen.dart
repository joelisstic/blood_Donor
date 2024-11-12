import 'dart:async';

import 'package:flutter/material.dart';

import 'onboarding.dart';

class Splashscreen extends StatefulWidget {
  const Splashscreen({super.key});

  @override
  State<Splashscreen> createState() => _SplashscreenState();
}

class _SplashscreenState extends State<Splashscreen> {
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 3),
            ()=>Navigator.pushReplacement(context,
            MaterialPageRoute(builder:
                (context) =>
                Onboarding()
            )
        )
    );
  }
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Icon(Icons.water_drop_rounded,color: Colors.red,size: 150,),
      ),
      backgroundColor: Color(0xfffaeeee),

    );
  }
}
