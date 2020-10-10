import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:sabalearning/models/user.dart';
import 'package:sabalearning/services/firebase-auth.service.dart';
import 'package:sabalearning/services/firestore-database.service.dart';
import 'package:sabalearning/utils/constants.dart';
import 'package:sabalearning/views/edit.dart';
import 'package:sabalearning/views/welcome/sign-in.dart';
import 'package:sabalearning/widgets/user-avatar.dart';

class Home extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {

    final user = Provider.of<User>(context);
    
    final FirebaseAuthService _auth = new FirebaseAuthService();
    return Scaffold(
            appBar: PreferredSize(
              preferredSize: Size.fromHeight(50.0),
              child: AppBar(
                title: Text('Test'),
                elevation: 0.0,
                actions: <Widget>[
                  IconButton(
                    onPressed: () async {
                      await _auth.signOut();
                    }, 
                    icon: user.avatarUrl == null ? Icon(Icons.person): UserAvatar(user.avatarUrl, true, 20), 
                    ),
                
                  PopupMenuButton<String>(
                    onSelected: ((String val) async {
                      if (val == OptionsListContainer.Edit) {
                        Navigator.push(context,
                        MaterialPageRoute(builder: (context) => EditInfo()));
                      } else if (val == OptionsListContainer.SignOut) {
                          await _auth.signOut();
                      }
                      
                    }),
                    itemBuilder: (BuildContext context){
                      return OptionsListContainer.Choices.map((String choice){
                        return PopupMenuItem<String>(
                          value: choice,
                          child: Text(choice)
                        );
                      }).toList();
                    },
                  )
                ],
              )),
          );
  }
}