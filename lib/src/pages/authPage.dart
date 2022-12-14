import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shopelt/src/components/authForm.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: [
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.amber,
                Colors.amberAccent,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        Center(
          child: SingleChildScrollView(
            child: SizedBox(
              width: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    margin: const EdgeInsets.only(bottom: 30),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 70,
                      vertical: 10,
                    ),
                    //Cascade Operator (..)
                    transform: Matrix4.rotationZ(-9 * pi / 180)..translate(-16.2),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.amber.shade800,
                      boxShadow: const [
                        BoxShadow(
                          blurRadius: 8,
                          color: Colors.black26,
                          offset: Offset(0, 5),
                        )
                      ],
                    ),
                    child: Text(
                      'Shopelt',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.anton(
                        fontSize: 32,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: AuthForm(),
                  ),
                ],
              ),
            ),
          ),
        )
      ],
    ));
  }
}
