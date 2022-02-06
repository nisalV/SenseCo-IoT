import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase/screens/authenticate/authenticate.dart';
import 'package:flutter_firebase/screens/home/home.dart';
import 'package:flutter_firebase/shared/loading.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final currentUser = Provider.of<User?>(context);


    // return either Home or Authenticate widget
    if (currentUser == null) {
      return Authenticate();
    } else {
      return Home();
    }
  }
}
