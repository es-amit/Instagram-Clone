import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/firebase_options.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.blueGrey,
        indicatorColor: Colors.blueGrey
      ),
      theme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.blue
      ),
      themeMode: ThemeMode.dark,
      debugShowCheckedModeBanner: false,
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("home page"),
      ),
    );
  }
}