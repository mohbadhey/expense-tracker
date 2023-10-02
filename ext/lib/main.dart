import 'package:ext/googlesheets_api.dart';
import 'package:flutter/material.dart';

import 'homePage.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
GooglesheetsApi().init();
  runApp(  const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}