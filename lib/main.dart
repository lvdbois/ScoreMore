import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import '1start.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(ScoremoreApp());
}

class ScoremoreApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ScoreMore',
      home: StartScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
