import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTitle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(children: <Widget>[
      RichText(
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
      ),
      SizedBox(height: 30.0),
      RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          text: 'Language Learning App',
          style: GoogleFonts.portLligatSans(
            textStyle: TextStyle(fontStyle: FontStyle.normal),
            fontSize: 35,
            fontWeight: FontWeight.w600,
            color: Colors.grey[900],
          ),
        ),
      ),
    ]));
  }
}
