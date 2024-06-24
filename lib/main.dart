import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_notetakingapp_uas/login.dart';
import 'package:flutter_notetakingapp_uas/register.dart';
import 'package:flutter_notetakingapp_uas/settings.dart';
import 'homepage.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  await Hive.initFlutter();
  await Hive.openBox('myNote');
  await Hive.openBox('myPin');
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Note Taking App',
      home: LoginPage(),
    );
  }
}
