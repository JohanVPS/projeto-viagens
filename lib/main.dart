import 'package:flutter/material.dart';
import 'package:viagens/firebase_options.dart';
import 'package:viagens/screens/verificaLoginScreen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:viagens/widgets/cores.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform
  );
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  _MainAppState createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  bool isDarkMode = false;

  void _toggleTheme(bool value) {
    setState(() {
      isDarkMode = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: isDarkMode ? ThemeData.dark().copyWith(
              scaffoldBackgroundColor: corCinzaEscuro(),
            )  : ThemeData.light(),
      home: Scaffold(
        body: Verificaloginscreen(
          onThemeChanged: _toggleTheme,
          isDarkMode: isDarkMode,
        ),
      ),
    );
  }
}