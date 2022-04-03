import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_progress_dialog/flutter_progress_dialog.dart';
import 'package:stadium_booking/view/screen/add_stadium_screen.dart';
import 'package:stadium_booking/view/screen/login_screen.dart';
import 'package:stadium_booking/view/screen/main_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:stadium_booking/view/screen/splash_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ProgressDialog(
      child: MaterialApp(
        title: 'Stadium Booking',
        theme: ThemeData(
          primarySwatch: Colors.purple,
        ),
        home: MyHomePage(title: 'Flutter Demo Home Page'),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    FirebaseFirestore.instance.clearPersistence();

    return Scaffold(
      body: SplashScreen(),
    );
  }
}
