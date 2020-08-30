import 'package:flutter/material.dart';

const backgroundDecoration = BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(5)),
                gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Color(0xffe46b10), Colors.green]
                )
              );