import 'dart:async';

import 'package:clone_flutter_dev/mainterface/main_page.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Splash extends StatefulWidget {
  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    super.initState();

    Timer(Duration(seconds: 5), () {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (_) => HomeMain()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlue,
      body: Container(
        child: Column(
          children: [
            Container(
              height: MediaQuery.of(context).size.height / 2,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Flutter Dev Clone',
                    style: GoogleFonts.poppins(
                        fontSize: 32,
                        fontWeight: FontWeight.w600,
                        color: Colors.white),
                  ),
                  SizedBox(
                    height: 12,
                  ),
                  Text(
                    'Mobile application intended for making \n clones of the flutter.dev website.',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.montserrat(
                        fontWeight: FontWeight.w400,
                        color: Colors.white,
                        fontSize: 16),
                  ),
                  SizedBox(
                    height: 48,
                  ),
                  CircularProgressIndicator(
                    backgroundColor: Colors.white,
                    valueColor: AlwaysStoppedAnimation(Colors.lightBlue[800]),
                  ),
                ],
              ),
            ),
            Container(
              height: MediaQuery.of(context).size.height / 2,
              child: Image.asset(
                'assets/think.png',
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
