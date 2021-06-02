import 'package:flutter/material.dart';
import 'package:karaoke_app/HomeView.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Karaoke',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomView(),
    );
  }
}

