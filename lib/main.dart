import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase/screens/home/settings/user_settings.dart';
import 'package:flutter_firebase/screens/wrapper.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_firebase/services/auth.dart';
import 'package:provider/provider.dart';

void main() async {

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    // Replace with actual values
    options: FirebaseOptions(
      apiKey: "AIzaSyC06URVWSgdoC5JPnGxRnChafGE1MjNoyU",
      appId: "1:596581986484:android:2919a55d3069e2052567e1",
      messagingSenderId: "596581986484",
      projectId: "flutter-firebase-63570",
    ),
  );

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: StreamProvider<User?>.value(
          value: AuthService().user,
          initialData: null,
          child: MaterialApp(
            home: Wrapper(),
          )),
    );
  }
}
