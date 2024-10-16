import 'package:flutter/material.dart';
import 'package:minhas_viagens_12/pages/home_page.dart';
import 'package:minhas_viagens_12/utils/generate_route.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
      initialRoute: "/",
      onGenerateRoute: RouterGenerator.generateRoute,
    );
  }
}
