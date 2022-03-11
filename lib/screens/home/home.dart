import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase/screens/home/linkData/sheet_data.dart';
import 'package:flutter_firebase/screens/home/settings/user_settings.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'package:http/http.dart' as http;

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  late String data = "";
  var mapKeys = [];
  var mapValues = [];

  @override
  initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    setState(() {
      mapKeys;
      mapValues;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Home'),
        backgroundColor: Colors.redAccent,
        elevation: 0.0,
        actions: [
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 20, 0),
            child: IconButton(
                onPressed: () async {
                  await _auth.signOut();
                  final snackBar = SnackBar(
                    content: Text(
                      'Signed out',
                      style: TextStyle(
                        fontSize: 20.0,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    backgroundColor: Colors.red,
                  );
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                },
                icon: Icon(
                  Icons.logout,
                  color: Colors.white,
                )),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 20, 0),
            child: IconButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => UserSettings()));
                },
                icon: Icon(
                  Icons.settings,
                  color: Colors.white,
                )
            ),
          ),
        ],
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection("users")
            .doc(_auth.currentUser!.uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Container(
                color: Colors.white,
                child: Center(
                  child: SpinKitPulse(
                    color: Colors.redAccent,
                    size: 50.0,
                  ),
                ));
          } else {
            Map dataMap = snapshot.data!.get('sheets');
            var mapLength = dataMap.keys.length.toString();
            mapKeys = dataMap.keys.toList();
            mapValues = dataMap.values.toList();

            return Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(30, 0, 30, 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                            child: Card(
                          elevation: 6,
                          color: Color(0xFFF1F1F1),
                          shadowColor: Color(0xFF363535),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Center(
                              child: Column(
                                children: [
                                  Text(
                                    "G O O G L E   S H E E T S",
                                    style: TextStyle(
                                      color: Colors.redAccent,
                                      fontSize: 15.0,
                                      fontWeight: FontWeight.w900,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 8.0,
                                  ),
                                  Text(
                                    mapLength,
                                    style: TextStyle(
                                      color: Color(0xFF4BC95C),
                                      fontSize: 25.0,
                                      fontWeight: FontWeight.w900,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        )),
                      ],
                    ),
                  ),
                  Flexible(
                    child: ListView.builder(
                      scrollDirection: Axis.vertical,
                        itemCount: int.parse(mapLength),
                        itemBuilder: (BuildContext context, index) {
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(context, MaterialPageRoute(builder: (context) => SheetData(_auth.currentUser!.uid,mapKeys[index],mapValues[index])));
                            },
                            onLongPress: () {
                              print(mapValues[index]);
                            },
                            child: Card(
                              elevation: 0.0,
                              color: Color(0xFFDCDCDB),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Expanded(
                                    flex: 9,
                                    child: Padding(
                                      padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                                      child: Text(mapKeys[index],
                                      style: TextStyle(
                                        fontSize: 15
                                      ),),
                                    ),
                                  ),
                                  // Expanded(
                                  //   flex: 1,
                                  //   child: IconButton(
                                  //     color: Colors.redAccent,
                                  //       splashColor: Color(0xFFFAC7C6),
                                  //       hoverColor: Color(0xFFFAC7C6),
                                  //       splashRadius: 17,
                                  //       onPressed: () {
                                  //
                                  //       },
                                  //       icon: Icon(Icons.delete, color: Colors.redAccent,
                                  //       size: 22,)),
                                  // )
                                ],
                              ),

                            ),
                          );
                        },
                    ),
                  )
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
