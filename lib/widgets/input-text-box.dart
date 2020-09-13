import 'package:flutter/material.dart';
class InputTextField extends StatelessWidget {
  final String title;
  final bool isPassword;
  final Function onChange;

  InputTextField({this.title, this.isPassword, this.onChange});
  
  @override
  Widget build(BuildContext context) {
    return Container(
          margin: EdgeInsets.symmetric(vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                title,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              ),
              SizedBox(
                height: 10,
              ),
              TextField(
                  obscureText: isPassword,
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      fillColor: Color(0xfff3f3f4),
                      filled: true),
                      onChanged: (val) {
                        this.onChange(val);
                      },),
            ],
      ));
  }
}