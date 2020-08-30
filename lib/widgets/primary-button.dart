import 'package:flutter/material.dart';

class PrimaryButton extends StatelessWidget {
  final Function onButtonClick;
  final String buttonText;

  PrimaryButton({this.onButtonClick, this.buttonText});
  @override
  Widget build(BuildContext context) {
    return RaisedButton(
        onPressed: () async{
          await this.onButtonClick();
        },
        textColor: Colors.white,
        padding: const EdgeInsets.all(0.0),
        child: Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.symmetric(vertical: 13),
        alignment: Alignment.center,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(5)),
            border: Border.all(color: Colors.white, width: 2),
            color: Colors.blue),
        child: Text(
          this.buttonText,
          style: TextStyle(
            fontSize: 20,
            color: Colors.black,
            fontWeight: FontWeight.w500
          ),
        ),
        )
      );
  }
}