import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UserAvatar extends StatelessWidget {
  String _image;
  bool isNetwork;
  double radius;
  UserAvatar(this._image, this.isNetwork, this.radius);

  @override
  Widget build(BuildContext context) {
    var imageSource;
    if (this._image != null) {
      imageSource = !isNetwork
          ? Image.file(File(this._image))
          : Image.network(this._image, fit: BoxFit.cover);
    }
    return CircleAvatar(
      radius: radius,
      child: ClipOval(child: SizedBox.expand(child: imageSource)),
    );
  }
}
