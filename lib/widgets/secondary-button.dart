import 'package:flutter/material.dart';

class SecondaryButton extends StatelessWidget {
  final Function onButtonClick;
  final String buttonText;

  SecondaryButton({this.onButtonClick, this.buttonText});
  @override
  Widget build(BuildContext context) {
    return RaisedButton(
        onPressed: () async {
          await this.onButtonClick();
        },
        padding: const EdgeInsets.all(0.0),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18.0),
            side: BorderSide(color: Colors.redAccent)),
        child: Container(
          width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.symmetric(vertical: 13),
          alignment: Alignment.center,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(18)),
              //border: Border.all(color: Colors.black, width: 2),
              color: Colors.redAccent),
          child: Text(
            this.buttonText,
            style: TextStyle(
                fontSize: 20, color: Colors.black, fontWeight: FontWeight.w500),
          ),
        ));
  }
}
