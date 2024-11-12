import 'package:blood_donor/home.dart';
import 'package:blood_donor/registration.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class Onboarding extends StatefulWidget {
  @override
  _OnboardingState createState() => _OnboardingState();
}

class _OnboardingState extends State<Onboarding> {
  int _currentIndex = 0;
  final List<Widget> _pages = [
    PageViewContainer(
      'Welcome to Blood Donation App',
      'Find nearby blood donors and save lives.',
      'assets/images/secure.json',
    ),
    PageViewContainer(
      'Easy to Connect',
      'Connect with donors instantly with just a few taps.',
      'assets/images/blood.json',
    ),
    PageViewContainer(
      'Secure & Reliable',
      'Your safety and privacy are our priority.',
      'assets/images/welcome.json',
    ),
  ];



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView(
            children: _pages,
            onPageChanged: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
          ),
          Positioned(
            bottom: 80,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                _pages.length,
                    (index) => AnimatedContainer(
                  duration: Duration(milliseconds: 300),
                  margin: EdgeInsets.symmetric(horizontal: 5),
                  width: _currentIndex == index ? 12 : 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: _currentIndex == index ? Colors.redAccent : Colors.grey,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      bottomSheet: _currentIndex == _pages.length - 1
          ? Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
                    onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage()));
                    },
                    child: Text('Get Started',style: TextStyle(color: Colors.white),),
                    style: ElevatedButton.styleFrom(
            minimumSize: Size(200, 50),backgroundColor: Colors.redAccent
                    ),
                  ),
          )
          : Container(height: 0),
      backgroundColor: Color(0xfffaeeee),
    );
  }
}

class PageViewContainer extends StatelessWidget {
  final String title;
  final String description;
  final String lottiePath;

  PageViewContainer(this.title, this.description, this.lottiePath);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 60, horizontal: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(

            child: Lottie.asset(
              lottiePath,
              fit: BoxFit.cover,
            ),
          ),

          Text(
            title,
            style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold,fontSize: 30),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 20),
          Text(
            description,
            style: TextStyle(fontSize: 16),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
