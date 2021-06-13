import 'package:flutter/material.dart';
import 'package:karaoke_app/ServiceProvider.dart';
import 'package:karaoke_app/View/HomeView.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  setUp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
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

