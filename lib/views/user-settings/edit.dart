import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:sabalearning/models/user.dart';
import 'package:sabalearning/services/firebase-auth.service.dart';
import 'package:sabalearning/services/firestore-database.service.dart';
import 'package:sabalearning/utils/background-decoration.dart';
import 'package:sabalearning/widgets/primary-button.dart';
import 'package:sabalearning/widgets/user-avatar.dart';

class EditInfo extends StatefulWidget {
  @override
  _EditInfoState createState() => _EditInfoState();
}

class _EditInfoState extends State<EditInfo> {
  final globalKey = GlobalKey<ScaffoldState>();
  FirebaseStorage _storage =
      FirebaseStorage(storageBucket: "gs://sabalearning-53576.appspot.com/");
  PickedFile _image;

  Future getImage(ImageSource imgSource) async {
    var image = await new ImagePicker().getImage(source: imgSource);
    setState(() {
      this._image = image;
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);

    void saveUserDisplayName(String displayName) {
      user.displayName = displayName;
    }

    Future uploadImage(BuildContext context) async {
      if (this._image == null) {
        FirebaseAuthService().updateUserPersonalInfo(user);
      } else {
        String fileName = this._image.path;
        StorageReference storage =
            FirebaseStorage.instance.ref().child(fileName);
        StorageUploadTask task = storage.putFile(File(fileName));
        StorageTaskSnapshot snapshot = await task.onComplete;

        setState(() {
          final snackBar = SnackBar(content: Text('Profile saved'));
          globalKey.currentState.showSnackBar(snackBar);
        });

        storage.getDownloadURL().then((url) async => {
              user.avatarUrl = url,
              FirebaseAuthService().updateUserPersonalInfo(user)
            });
      }
    }

    return new Scaffold(
      key: globalKey,
      appBar: new AppBar(
        backgroundColor: Colors.blueAccent[700],
        title: new Text(
          "Edit user information",
          style: new TextStyle(color: Colors.white),
        ),
      ),
      body: new Container(
          //decoration: backgroundDecoration,
          height: MediaQuery.of(context).size.height,
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.only(left: 20, top: 100, right: 20),
              child: Column(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                          padding: EdgeInsets.only(left: 30),
                          child: UserAvatar(
                              this._image != null
                                  ? this._image.path
                                  : user.avatarUrl,
                              this._image == null,
                              70)),
                      IconButton(
                          icon: Icon(Icons.edit, size: 30.0),
                          onPressed: () {
                            _showPicker(context);
                          })
                    ],
                  ),
                  SizedBox(
                    height: 40.0,
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height / 3,
                    child: Column(
                      children: <Widget>[
                        FormBuilderTextField(
                            attribute: "displayName",
                            initialValue: user.displayName,
                            decoration: InputDecoration(
                                icon: Icon(Icons.perm_identity),
                                labelStyle: new TextStyle(
                                    color: const Color(0xFF424242))),
                            validators: [
                              FormBuilderValidators.required(),
                            ],
                            onChanged: (val) {
                              saveUserDisplayName(val);
                            }),
                        Expanded(child: Container()),
                        PrimaryButton(
                            onButtonClick: () => uploadImage(context),
                            buttonText: 'Save Changes'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          )),
    );
  }

  void _showPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: new Wrap(
                children: <Widget>[
                  new ListTile(
                      leading: new Icon(Icons.photo_library),
                      title: new Text('Photo Library'),
                      onTap: () {
                        getImage(ImageSource.gallery);
                        Navigator.of(context).pop();
                      }),
                  new ListTile(
                    leading: new Icon(Icons.photo_camera),
                    title: new Text('Camera'),
                    onTap: () {
                      getImage(ImageSource.camera);
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }
}
