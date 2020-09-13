import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTitle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
          text: 'sa',
          style: GoogleFonts.portLligatSans(
            textStyle: TextStyle(fontStyle: FontStyle.italic),
            fontSize: 30,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
          children: [
            TextSpan(
              text: 'ba',
              style: GoogleFonts.portLligatSans(
                textStyle: Theme.of(context).textTheme.display1,
                fontSize: 30,
                fontWeight: FontWeight.w700,
                color: Colors.black,
                ),            
              ),
          ]),
    );
  }
}